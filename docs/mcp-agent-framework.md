# MCP Agent Framework Architecture

## Overview

A lightweight framework for connecting Claude Code agents to MCP servers via `mcp-cli`.

```
┌─────────────────┐     CLI/JSON      ┌─────────────┐    HTTP/SSE     ┌────────────────┐
│  Claude Code    │ ──────────────────▶│   mcp-cli   │ ───────────────▶│   MCP Server   │
│  Agent/Skill    │                    │   (daemon)  │                 │ (any HTTP MCP) │
└─────────────────┘                    └─────────────┘                 └────────────────┘
```

## Components

### 1. mcp-cli (Protocol Bridge)

**Purpose:** Dumb pipe between agents and MCP servers.

**Responsibilities:**
- Translate CLI calls → MCP JSON-RPC
- Handle OAuth/auth
- Manage sessions
- Pool connections (daemon mode)
- Cache tool definitions

**Not responsible for:**
- MCP-specific logic
- Server lifecycle
- Business logic

### 2. Server Configuration

`~/.mcp-cli/servers.json`:

```json
{
  "servers": {
    "betterstack": {
      "url": "https://mcp.betterstack.com",
      "type": "query",
      "category": "logs",
      "schema_discovery": {
        "method": "sample_query",
        "query": "SELECT * FROM remote({table}_logs) LIMIT 1"
      },
      "hints": {
        "table_pattern": "t{team_id}_{source_name}",
        "time_column": "dt",
        "common_filters": ["level", "service", "trace_id"]
      }
    },
    "supabase": {
      "url": "https://mcp.supabase.com/mcp?project_ref=xxx&read_only=true",
      "type": "query",
      "category": "database",
      "schema_discovery": {
        "method": "tool_call",
        "tool": "list_tables",
        "args": {}
      }
    },
    "playwright": {
      "url": "http://localhost:8087",
      "type": "action",
      "category": "browser",
      "lifecycle": {
        "start_command": "npx @playwright/mcp --port 8087",
        "cleanup_tool": "browser_close"
      }
    }
  }
}
```

### 3. MCP Categories

| Category | Pattern | Examples |
|----------|---------|----------|
| **Query** | Discover schema → Build query → Execute | Logs, DB, metrics, search |
| **Action** | Sequential ops → Cleanup | Browser, API calls, file ops |
| **CRUD** | Create/Read/Update/Delete | Storage, records, config |
| **Monitor** | List → Get status → Act on alerts | Uptime, incidents, alerts |

### 4. Agent Templates

#### Query MCP Agent (logs, DB, metrics)

```markdown
## Workflow
1. Check daemon status
2. Discover tools
3. Discover schema (SELECT * LIMIT 1 or equivalent)
4. Build query from user intent
5. Execute and handle errors
6. Synthesize results

## Schema Discovery
- Always query schema before building queries
- Cache column names for session
- Re-discover on "unknown column" errors
```

#### Action MCP Agent (browser, API)

```markdown
## Workflow
1. Ensure server is running
2. Discover available actions
3. Execute sequence of actions
4. Handle errors/retries
5. Cleanup (close browser, etc.)

## Lifecycle
- Check server: `curl -s {url}/health`
- Start if needed: `{start_command} &`
- Always cleanup: call `{cleanup_tool}` when done
```

#### CRUD MCP Agent (storage, records)

```markdown
## Workflow
1. Discover resources/collections
2. Map user intent to CRUD operation
3. Execute with appropriate method
4. Confirm result

## Safety
- Confirm destructive operations (delete, update)
- Use transactions where available
- Log all write operations
```

## Updating MCP Tools

### When Updates Happen

1. **MCP server updates tools** - New tools, changed schemas, deprecated endpoints
2. **Our cache becomes stale** - Wrong tool names, outdated schemas
3. **Queries fail** - Unknown tool, schema mismatch, new required params

### Update Strategies

#### Automatic (TTL-based)
```python
TOOLS_CACHE_TTL = 300  # 5 minutes (current)
SCHEMA_CACHE_TTL = 3600  # 1 hour (proposed)
```

#### Manual Refresh
```bash
mcp-cli --refresh betterstack          # Refresh single server
mcp-cli --refresh-all                  # Refresh all servers
mcp-cli --clear-cache                  # Nuclear option
```

#### Error-triggered
```python
def handle_tool_error(error):
    if "unknown tool" in error or "schema" in error:
        refresh_cache(server)
        retry_query()
```

#### Version-aware (if MCP supports it)
```python
def check_version():
    current = get_cached_version(server)
    remote = call_mcp(server, "get_version")
    if remote != current:
        refresh_cache(server)
```

### Cache Storage (SQLite)

```sql
-- Tool definitions
CREATE TABLE tools_cache (
    server TEXT PRIMARY KEY,
    tools_json TEXT,
    version TEXT,
    cached_at INTEGER,
    expires_at INTEGER
);

-- Schema cache (for query MCPs)
CREATE TABLE schema_cache (
    server TEXT,
    table_name TEXT,
    columns_json TEXT,
    cached_at INTEGER,
    PRIMARY KEY (server, table_name)
);

-- Query patterns (learned from usage)
CREATE TABLE query_patterns (
    server TEXT,
    intent TEXT,  -- "recent errors", "user activity"
    query_template TEXT,
    success_count INTEGER,
    last_used INTEGER
);
```

### Update Flow

```
User query
    │
    ▼
┌─────────────────────┐
│ Check tools cache   │
│ (TTL expired?)      │
└─────────────────────┘
    │ yes              │ no
    ▼                  ▼
┌─────────────┐    ┌─────────────┐
│ Refresh     │    │ Use cached  │
│ from MCP    │    │ tools       │
└─────────────┘    └─────────────┘
    │                  │
    └────────┬─────────┘
             ▼
┌─────────────────────┐
│ Check schema cache  │
│ (for query MCPs)    │
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ Build & execute     │
│ query               │
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│ Error?              │
│ - Unknown tool      │──yes──▶ Refresh tools, retry
│ - Schema mismatch   │──yes──▶ Refresh schema, retry
│ - Auth expired      │──yes──▶ Re-auth, retry
└─────────────────────┘
    │ no
    ▼
  Return results
```

## Skills vs Agents

### When to Use Skills

```markdown
/query-logs "errors in last hour"
/db-query "SELECT * FROM users LIMIT 5"
/browser-screenshot "https://example.com"
```

- Simple, single-purpose
- User knows exactly what they want
- Fast, stays in main context

### When to Use Agents

```markdown
"Investigate why user X's publish failed"
"Check for any issues in the last 6 hours"
"Test the login flow and report any problems"
```

- Multi-step investigation
- Correlate across sources
- Autonomous decision-making
- Keep main context clean

### Hybrid Pattern

```python
# Skill handles simple case
if is_simple_query(user_input):
    return skill_query(server, user_input)

# Agent handles complex case
else:
    return spawn_agent("debug-backend", user_input)
```

## Future: mcp-gen (Auto-generate Agents)

Given a new MCP server, auto-generate agent instructions:

```bash
mcp-gen --server newserver --url https://mcp.newserver.com
```

Output:
1. Discover all tools
2. Categorize MCP type (query/action/crud)
3. Generate agent markdown with:
   - Available tools
   - Schema discovery commands
   - Common query patterns
   - Workflow template

```markdown
## Auto-generated: newserver Agent

### Available Tools
- tool_1: Description...
- tool_2: Description...

### Schema Discovery
[auto-detected based on tools]

### Common Operations
[generated from tool descriptions]
```

## Implementation Phases

### Phase 1 (Current)
- [x] mcp-cli with daemon mode
- [x] Manual agent creation (debug-backend)
- [x] In-memory caching

### Phase 2
- [ ] SQLite persistent cache
- [ ] Schema caching
- [ ] Manual refresh commands
- [ ] Error-triggered refresh

### Phase 3
- [ ] Server config with hints
- [ ] Agent templates per category
- [ ] Skills for simple queries

### Phase 4
- [ ] mcp-gen auto-generation
- [ ] Query pattern learning
- [ ] Cross-MCP correlation agents

## Creating Your Own Agents

### General Agent Structure

Every MCP agent follows this pattern:

```markdown
---
name: your-agent-name
description: When to use this agent (triggers auto-invocation)
tools: Bash, Read, Grep
---

# Agent Title

Brief description of what this agent does.

## Prerequisites

How to ensure the MCP server is ready.

## Discovery

Commands to discover available tools and schema.

## Common Operations

Copy-paste commands for typical tasks.

## Workflow

Step-by-step process the agent follows.

## Output Format

How results should be structured.

## Guidelines

Do's and don'ts.
```

### Templates by Category

#### Query MCP Template (logs, DB, metrics, search)

```markdown
---
name: [service]-query
description: Query [service] for [data type]. Use for [typical requests].
tools: Bash, Read, Grep
---

# [Service] Query Agent

Query [service] for [logs/records/metrics].

## Prerequisites

\`\`\`bash
mcp-cli --daemon-status || mcp-cli --daemon
\`\`\`

## Discovery

**List tools:**
\`\`\`bash
mcp-cli --daemon-tools [server]
\`\`\`

**Discover schema:**
\`\`\`bash
mcp-cli --query [server] [query-tool] '{"query": "SELECT * FROM [table] LIMIT 1"}'
\`\`\`

## Common Operations

**Recent records:**
\`\`\`bash
mcp-cli --query [server] [query-tool] '{"query": "SELECT * FROM [table] ORDER BY [time_col] DESC LIMIT 20"}'
\`\`\`

**Filter by condition:**
\`\`\`bash
mcp-cli --query [server] [query-tool] '{"query": "SELECT * FROM [table] WHERE [condition] ORDER BY [time_col] DESC LIMIT 50"}'
\`\`\`

**Time-based query:**
\`\`\`bash
mcp-cli --query [server] [query-tool] '{"query": "SELECT * FROM [table] WHERE [time_col] > now() - INTERVAL [N] HOUR"}'
\`\`\`

## Workflow

1. **Check daemon** - Ensure mcp-cli daemon is running
2. **Understand request** - What data is the user looking for?
3. **Discover schema** - Query column names before building queries
4. **Build query** - Construct query based on user intent and actual schema
5. **Execute** - Run query, handle errors
6. **Synthesize** - Summarize findings, highlight important data

## Output Format

\`\`\`json
{
  "query_executed": "...",
  "record_count": N,
  "summary": "Brief description of findings",
  "data": [...],
  "notable": ["Any anomalies or important observations"]
}
\`\`\`

## Guidelines

- Always discover schema before building queries
- Use LIMIT to avoid huge result sets
- If query fails, check schema and retry
- Note what you found vs what you inferred
```

#### Action MCP Template (browser, API, automation)

```markdown
---
name: [service]-action
description: Perform [actions] using [service]. Use for [typical requests].
tools: Bash, Read, Grep
---

# [Service] Action Agent

Automate [actions] using [service].

## Prerequisites

**Check server:**
\`\`\`bash
curl -s http://localhost:[port]/health || ([start-command] &; sleep 3)
\`\`\`

## Discovery

**List actions:**
\`\`\`bash
mcp-cli --daemon-tools [server]
\`\`\`

## Common Operations

**Navigate:**
\`\`\`bash
mcp-cli --query [server] [navigate-tool] '{"url": "..."}'
\`\`\`

**Interact:**
\`\`\`bash
mcp-cli --query [server] [click-tool] '{"element": "..."}'
mcp-cli --query [server] [fill-tool] '{"element": "...", "value": "..."}'
\`\`\`

**Capture:**
\`\`\`bash
mcp-cli --query [server] [screenshot-tool] '{}'
\`\`\`

**Cleanup:**
\`\`\`bash
mcp-cli --query [server] [close-tool] '{}'
\`\`\`

## Workflow

1. **Ensure server running** - Start if needed
2. **Understand goal** - What sequence of actions needed?
3. **Execute actions** - One at a time, verify each step
4. **Handle errors** - Retry or report failure
5. **Capture result** - Screenshot, data extraction
6. **Cleanup** - Always close/cleanup when done

## Output Format

\`\`\`json
{
  "actions_performed": ["navigate", "click", "fill", "submit"],
  "success": true,
  "result": "Description of outcome",
  "screenshots": ["path1", "path2"],
  "errors": []
}
\`\`\`

## Guidelines

- Always cleanup (close browser, etc.) when done
- Verify each action succeeded before next
- Capture screenshots at key steps
- Handle timeouts and element-not-found gracefully
```

#### Monitor MCP Template (uptime, incidents, alerts)

```markdown
---
name: [service]-monitor
description: Monitor [resources] via [service]. Use for [status checks, incident response].
tools: Bash, Read, Grep
---

# [Service] Monitor Agent

Monitor and respond to [alerts/incidents] via [service].

## Prerequisites

\`\`\`bash
mcp-cli --daemon-status || mcp-cli --daemon
\`\`\`

## Discovery

\`\`\`bash
mcp-cli --daemon-tools [server]
\`\`\`

## Common Operations

**List active incidents:**
\`\`\`bash
mcp-cli --query [server] list_incidents '{"status": "open"}'
\`\`\`

**Get incident details:**
\`\`\`bash
mcp-cli --query [server] get_incident '{"id": "..."}'
\`\`\`

**Check resource status:**
\`\`\`bash
mcp-cli --query [server] list_monitors '{}'
\`\`\`

**Acknowledge incident:**
\`\`\`bash
mcp-cli --query [server] acknowledge_incident '{"id": "..."}'
\`\`\`

## Workflow

1. **Check daemon** - Ensure running
2. **Assess situation** - List open incidents/alerts
3. **Gather details** - Get specifics on each issue
4. **Correlate** - Check related resources
5. **Recommend action** - Acknowledge, escalate, or resolve

## Output Format

\`\`\`json
{
  "status": "healthy|degraded|outage",
  "open_incidents": [...],
  "affected_resources": [...],
  "recommended_actions": [...]
}
\`\`\`
```

### Combining Multiple MCPs

For agents that query multiple sources:

```markdown
---
name: multi-source-investigator
description: Investigate issues across logs, database, and monitoring
tools: Bash, Read, Grep
---

# Multi-Source Investigator

Correlate data across multiple MCP servers to investigate issues.

## Available Sources

- **betterstack**: Logs and telemetry
- **supabase**: Database records
- **sentry**: Error tracking (if configured)

## Workflow

1. **Understand the issue** - What are we investigating?
2. **Query logs** - Find relevant log entries (betterstack)
3. **Query database** - Get related records (supabase)
4. **Correlate** - Match by timestamp, user_id, request_id
5. **Build timeline** - Sequence of events
6. **Identify root cause** - What went wrong?

## Cross-Source Correlation

**Find user in logs:**
\`\`\`bash
mcp-cli --query betterstack telemetry_query '{"query": "... WHERE user_id = '\''[ID]'\'' ..."}'
\`\`\`

**Find user in database:**
\`\`\`bash
mcp-cli --query supabase execute_sql '{"query": "SELECT * FROM profiles WHERE id = '\''[ID]'\''"}'
\`\`\`

**Match by timestamp:**
- Get timestamp from one source
- Query other sources with time window (±5 minutes)

## Output Format

\`\`\`json
{
  "summary": "Root cause statement",
  "timeline": [
    {"time": "...", "source": "logs", "event": "..."},
    {"time": "...", "source": "database", "event": "..."}
  ],
  "evidence": {
    "logs": [...],
    "database": [...]
  },
  "root_cause": "Detailed explanation",
  "recommended_fix": "What to do"
}
\`\`\`
```

### Quick Start: Create Your Agent

1. **Identify MCP category** (query/action/monitor)

2. **Copy template** from above

3. **Fill in placeholders:**
   - `[server]` - your server name from servers.json
   - `[query-tool]` - actual tool name from `--daemon-tools`
   - `[table]`, `[time_col]` - from schema discovery

4. **Add server-specific hints:**
   - Common filters for your data
   - Typical query patterns
   - Known gotchas

5. **Save to** `~/.claude/agents/your-agent.md`

6. **Test it:**
   ```
   "Use the [your-agent] to [do something]"
   ```

### Example: Creating a Sentry Agent

```bash
# 1. Add server config
cat >> ~/.mcp-cli/servers.json << 'EOF'
{
  "sentry": {
    "url": "https://mcp.sentry.io",
    "headers": {"Authorization": "Bearer YOUR_TOKEN"}
  }
}
EOF

# 2. Discover tools
mcp-cli --auth sentry
mcp-cli --daemon-tools sentry

# 3. Create agent from template
# Copy Query MCP Template, fill in:
# - [server] = sentry
# - [query-tool] = (from discovery)
# - Add Sentry-specific patterns

# 4. Save to ~/.claude/agents/sentry-errors.md
```

## Tool Update Frequency

MCP tools don't change frequently. Typical scenarios:

| Event | Frequency | Action |
|-------|-----------|--------|
| New tools added | Rare (monthly?) | Refresh cache, update agent |
| Tool deprecated | Very rare | Errors trigger refresh |
| Schema change | Rare | Error-triggered refresh |
| Auth rotation | Varies | Re-run `--auth` |

**Recommendation:**
- TTL of 1 hour for tools cache is plenty
- Schema cache can be longer (24hr) since it's self-correcting on errors
- Don't over-engineer update mechanisms

## Error Handling

### Error Categories

| Category | Example | Handler |
|----------|---------|---------|
| **Network** | Connection refused, timeout | Retry with backoff |
| **Auth** | Token expired, invalid scope | Re-auth, retry |
| **Schema** | Unknown column, table not found | Refresh schema, retry |
| **Tool** | Unknown tool, invalid args | Refresh tools cache, retry |
| **Server** | MCP returns error | Surface to agent |
| **Daemon** | Socket not found | Start daemon, retry |

### mcp-cli Error Response Format

All errors return consistent JSON:

```json
{
  "ok": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "retryable": true,
    "hint": "Suggested action"
  }
}
```

**Error codes:**

| Code | Meaning | Retryable | Action |
|------|---------|-----------|--------|
| `DAEMON_NOT_RUNNING` | Socket not found | Yes | `mcp-cli --daemon` |
| `CONNECTION_FAILED` | Can't reach MCP server | Yes | Check URL, retry |
| `TIMEOUT` | Request timed out | Yes | Retry with longer timeout |
| `AUTH_EXPIRED` | Token expired | Yes | `mcp-cli --auth <server>` |
| `AUTH_SCOPE` | Missing required scope | No | Re-auth with correct scopes |
| `UNKNOWN_TOOL` | Tool doesn't exist | Maybe | Refresh tools cache |
| `INVALID_ARGS` | Bad tool arguments | No | Fix arguments |
| `SCHEMA_ERROR` | Column/table not found | Yes | Refresh schema, fix query |
| `MCP_ERROR` | Server returned error | Varies | Check error message |
| `PARSE_ERROR` | Invalid response | No | Check MCP server |

### Retry Logic (mcp-cli)

```python
def query_with_retry(server, tool, args, max_retries=2):
    for attempt in range(max_retries + 1):
        result = daemon_send({"action": "call", ...})

        if result.get("ok"):
            return result

        error = result.get("error", {})
        code = error.get("code")

        # Non-retryable errors
        if code in ["INVALID_ARGS", "AUTH_SCOPE", "PARSE_ERROR"]:
            return result

        # Auth errors - re-auth and retry
        if code == "AUTH_EXPIRED":
            do_oauth_flow(server)
            continue

        # Schema errors - refresh and retry
        if code == "SCHEMA_ERROR" or "unknown column" in error.get("message", ""):
            refresh_schema_cache(server)
            continue

        # Tool errors - refresh and retry
        if code == "UNKNOWN_TOOL":
            refresh_tools_cache(server)
            continue

        # Network errors - backoff and retry
        if code in ["CONNECTION_FAILED", "TIMEOUT"]:
            time.sleep(2 ** attempt)
            continue

    return result  # Return last error after retries exhausted
```

### Agent Error Handling

Agents should handle errors gracefully:

```markdown
## Error Handling

When a query fails:

1. **Check error code** in response
2. **If retryable:**
   - Schema error → re-discover schema, rebuild query
   - Auth error → inform user to re-authenticate
   - Timeout → retry once, then report
3. **If not retryable:**
   - Report error to user with context
   - Suggest fix if known

**Example:**
\`\`\`bash
# Query fails with unknown column
result=$(mcp-cli --query server tool '{"query": "SELECT bad_column..."}')

if echo "$result" | grep -q "unknown column"; then
    # Re-discover schema
    schema=$(mcp-cli --query server tool '{"query": "SELECT * FROM table LIMIT 1"}')
    # Rebuild query with correct columns
    # Retry
fi
\`\`\`
```

### Common Error Scenarios

**1. Daemon not running:**
```bash
$ mcp-cli --query betterstack ...
{
  "ok": false,
  "error": {
    "code": "DAEMON_NOT_RUNNING",
    "message": "Daemon not running. Start with --daemon"
  }
}

# Fix:
$ mcp-cli --daemon
```

**2. Auth expired:**
```bash
{
  "ok": false,
  "error": {
    "code": "AUTH_EXPIRED",
    "message": "OAuth token expired"
  }
}

# Fix:
$ mcp-cli --auth betterstack
$ mcp-cli --daemon-stop && mcp-cli --daemon  # Restart to pick up new token
```

**3. Schema mismatch:**
```bash
{
  "ok": true,
  "data": {
    "result": {
      "isError": true,
      "content": [{"text": "Unknown column 'message'..."}]
    }
  }
}

# Fix: Discover actual schema
$ mcp-cli --query betterstack telemetry_query '{"query": "SELECT * FROM ... LIMIT 1", ...}'
```

**4. MCP server down:**
```bash
{
  "ok": false,
  "error": {
    "code": "CONNECTION_FAILED",
    "message": "Request failed: Connection refused"
  }
}

# Fix: Check server status, wait and retry
```

### Error Handling Implementation Status

**Current (mcp-cli):**
- [x] Basic error wrapping in JSON
- [x] Timeout handling
- [x] Auth token refresh attempt
- [ ] Structured error codes
- [ ] Retry logic
- [ ] Error-triggered cache refresh

**Needed:**
- [ ] Add error codes to all failure paths
- [ ] Implement retry with backoff
- [ ] Auto-refresh on schema/tool errors
- [ ] `--retry` flag for manual retry control

## Open Questions

1. **Go rewrite?** - Better for distribution, but Python works for now
2. **Threading in daemon?** - Needed for parallel agents (bead exists)
3. **MCP server lifecycle?** - Agent responsibility, not mcp-cli
4. **Credential rotation?** - How to handle token refresh gracefully
5. **Error telemetry?** - Log errors for debugging? Privacy considerations?
