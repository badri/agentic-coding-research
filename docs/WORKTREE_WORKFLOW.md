# Git Worktree + Tmux + Claude Workflow

Complete guide to managing multiple features with git worktrees, tmux sessions, and Claude Code.

## Overview

This workflow enables:
- ✅ Work on multiple features simultaneously (each in isolated worktree)
- ✅ Each feature has its own tmux session with Claude running
- ✅ Quick switching between features with visual dashboard
- ✅ Beads integration for task tracking (with BEADS_NO_DAEMON=1)
- ✅ Clean merge workflow with conflict resolution

## Architecture

```
Main Repository
├── .git/
├── .beads/              # Shared across all worktrees
└── [main branch code]

Worktrees (siblings)
├── project-worktrees/
│   ├── feature-a/       # Worktree 1
│   │   └── [feature-a branch code]
│   ├── feature-b/       # Worktree 2
│   │   └── [feature-b branch code]
│   └── redis-cache/     # Worktree 3
│       └── [redis-cache branch code]

Tmux Sessions
├── wt-feature-a         # Claude running with BEADS_NO_DAEMON=1
├── wt-feature-b         # Claude running with BEADS_NO_DAEMON=1
└── wt-redis-cache       # Claude running with BEADS_NO_DAEMON=1
```

**Key insight:** All worktrees share the same `.git` and `.beads` directory, so:
- Git operations are synchronized
- Bead database is shared
- No symlinks needed (git handles it)
- BEADS_NO_DAEMON=1 prevents daemon conflicts

## Quick Start

### 1. Create a New Feature Worktree

```bash
# One command: creates worktree + tmux session + starts Claude + sends work
/worktree-new feature-name "work on bead issue-123"
```

This automatically:
- Creates worktree at `../project-worktrees/feature-name/`
- Creates branch `feature-name`
- Creates tmux session `wt-feature-name`
- Sets `BEADS_NO_DAEMON=1` in session
- Starts Claude Code
- Sends custom prompt to Claude

### 2. See All Worktrees

```bash
# Visual dashboard
wt
```

Shows:
- All worktrees with status indicators
- 🟢 Working | 🟡 Idle | 🔴 Error | ⚫ No session
- Commits ahead of main
- Quick attach with Enter key

### 3. Switch Between Features

```bash
# Option 1: Use wt TUI
wt
# Select with j/k or numbers, press Enter

# Option 2: Direct attach
tmux attach -t wt-feature-name

# Option 3: From within tmux
tmux switch-client -t wt-feature-name
```

### 4. Detach Without Closing

```bash
# Inside tmux session
Ctrl+b, d

# Session keeps running in background
# Claude continues if working on something
```

### 5. Merge When Done

```bash
# From main branch
git merge feature-name

# If conflicts detected, git-merge-agent helps (coming soon)
```

## Commands Reference

### `/worktree-new` - Create Worktree + Session

**Purpose:** Create new worktree with tmux session and Claude running

**Usage:**
```bash
# With custom prompt (recommended)
/worktree-new <feature-name> "<prompt-for-claude>"

# Without prompt (you'll type manually)
/worktree-new <feature-name>

# Just worktree, no tmux session
/worktree-new <feature-name> --no-session
```

**Examples:**
```bash
# Start work on a bead
/worktree-new auth-jwt "work on bead auth-jwt-5"

# Implement specific feature
/worktree-new redis-cache "implement Redis caching layer with connection pooling"

# Just create the worktree
/worktree-new experiment --no-session
```

**What it does:**
1. Creates worktree in `../project-worktrees/<feature-name>/`
2. Creates new branch `<feature-name>` (or uses existing)
3. Creates tmux session `wt-<feature-name>`
4. Sets `export BEADS_NO_DAEMON=1` in session
5. Starts Claude with `--dangerously-skip-permissions`
6. Waits 8 seconds for Claude to initialize
7. Sends custom prompt (if provided)

**Beads integration:**
- BEADS_NO_DAEMON=1 set automatically
- All bd commands work correctly
- Shared database across worktrees
- Reference: https://github.com/steveyegge/beads/issues/170

---

### `/worktree-list` - List All Worktrees

**Purpose:** Show all worktrees with status

**Usage:**
```bash
/worktree-list
```

**Output:**
```
Worktrees for myproject:

1. /path/to/myproject (main)
   ✓ Clean working directory

2. /path/to/myproject-worktrees/auth-jwt (auth-jwt)
   → 3 commits ahead of main
   ⚠ Uncommitted changes

3. /path/to/myproject-worktrees/redis-cache (redis-cache)
   → 2 commits ahead of main
   ✓ Clean working directory

Total: 3 worktrees

Important: When using bd commands in worktrees, ensure BEADS_NO_DAEMON=1 is set
Tmux sessions created via /worktree-new have this set automatically
Reference: https://github.com/steveyegge/beads/issues/170
```

---

### `/worktree-status` - Comprehensive Status

**Purpose:** Show detailed status of all worktrees, sessions, and Claude activity

**Usage:**
```bash
# All worktrees
/worktree-status

# Specific worktree
/worktree-status <worktree-name>

# Only active sessions
/worktree-status --active

# Only sessions where Claude is working
/worktree-status --working
```

**Output:**
```
📁 auth-jwt
├─ Branch: auth-jwt (3↑ main)
├─ Status: ⚠️ 2 uncommitted files
├─ Tmux: ✓ wt-auth-jwt (running 15m)
├─ Bead: agentic-coding-research-1 (P2, open)
└─ Activity: 🟢 Working
   │ [Using tool: Edit]
   │ Editing: src/auth/jwt.ts

📁 redis-cache
├─ Branch: redis-cache (2↑ main)
├─ Status: ✓ Clean
├─ Tmux: ✓ wt-redis-cache (running 42m)
├─ Bead: None
└─ Activity: 🟡 Idle
   │ > (waiting for input)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total worktrees: 3
Active sessions: 2/3
Working: 1 | Idle: 1 | Error: 0 | Not running: 0
Uncommitted changes: 1 worktrees

Quick actions:
  • View all sessions: tmux ls | grep "^wt-"
  • Attach to specific: tmux attach -t wt-<name>
  • Kill all sessions: tmux kill-session -t wt- (use with caution)

Important: Beads in worktrees
  • Tmux sessions have BEADS_NO_DAEMON=1 set automatically
  • Manual bd commands in worktrees need: export BEADS_NO_DAEMON=1
  • Reference: https://github.com/steveyegge/beads/issues/170
```

---

### `/worktree-tmux` - Attach or Create Session

**Purpose:** Attach to existing session or create new one for worktree

**Usage:**
```bash
# Attach to existing or create new
/worktree-tmux <worktree-name>

# With custom prompt for existing session
/worktree-tmux <worktree-name> "<prompt-for-claude>"
```

**Examples:**
```bash
# Attach to auth-jwt session
/worktree-tmux auth-jwt

# Send command to existing session
/worktree-tmux auth-jwt "run the tests"

# Create session if it doesn't exist
/worktree-tmux redis-cache "start working on caching"
```

**What it does:**
1. Checks if tmux session `wt-<name>` exists
2. If exists: Provides attach command (or sends custom prompt)
3. If not: Creates session with BEADS_NO_DAEMON=1 and starts Claude

---

### `/worktree-delete` - Merge and Delete

**Purpose:** Merge worktree branch to main and delete worktree

**Usage:**
```bash
/worktree-delete <worktree-name>
```

**Workflow:**
1. **Pre-merge checks:**
   - Verifies worktree exists
   - Checks for uncommitted changes (warns if found)
   - Shows what will be merged

2. **Attempts merge:**
   - `git merge <branch-name>`
   - If conflicts: Stops and shows conflicted files
   - If success: Continues to confirmation

3. **User confirmation:**
   - Shows merge summary
   - Options:
     * "Yes, delete worktree and branch"
     * "Keep worktree, delete branch only"
     * "Keep both worktree and branch"

4. **Cleanup (if confirmed):**
   - Kills tmux session if exists
   - Removes worktree
   - Deletes branch

**Important:** NEVER deletes without successful merge + confirmation

---

### `wt` - Interactive Dashboard

**Purpose:** Visual TUI for quick session switching

**Usage:**
```bash
wt           # Launch dashboard
wt refresh   # Re-run (refresh data)
```

**Features:**
- Visual snapshot of all worktrees
- Status indicators: 🟢 Working | 🟡 Idle | 🔴 Error | ⚫ No session
- Shows commits ahead of main
- Keyboard navigation (j/k, arrows, Enter)
- Quick attach to any session

**Keyboard shortcuts:**
- `Enter` - Attach to selected session
- `j/k` or `↑/↓` - Navigate
- `q/Esc` - Quit

**Status detection:**
- 🟢 **Working:** Claude is using tools (`[Using tool:]` in output)
- 🟡 **Idle:** Session active, prompt visible (`> `)
- 🔴 **Error:** Error detected in session output
- ⚫ **No session:** No tmux session exists

**Requirements:**
- `gum` (install: `brew install gum`)

---

## Complete Workflow Examples

### Example 1: New Feature Development

```bash
# 1. Create worktree + session + start work
/worktree-new user-auth "implement JWT authentication with refresh tokens"

# 2. Claude starts working immediately
# (Wait 8 seconds for initialization, then prompt is sent)

# 3. Need to check another feature? Detach
Ctrl+b, d

# 4. See all sessions
wt

# 5. Jump back to user-auth
# (Select with j/k, press Enter)

# 6. When done, merge and cleanup
git checkout main
/worktree-delete user-auth
# Choose: "Yes, delete worktree and branch"
```

---

### Example 2: Multiple Parallel Features

```bash
# Morning: Set up 3 features
/worktree-new feature-a "work on bead feature-a-1"
/worktree-new feature-b "work on bead feature-b-2"
/worktree-new feature-c "work on bead feature-c-3"

# All Claude sessions running in background

# Switch between them with wt
wt
# Select feature-a, press Enter
# Work...
# Ctrl+b, d to detach

wt
# Select feature-b, press Enter
# Work...
# Ctrl+b, d to detach

# End of day: All sessions still running
# Tomorrow: wt → pick up where you left off
```

---

### Example 3: Quick Experiment

```bash
# Create worktree without session
/worktree-new experiment --no-session

# Work in it manually
cd ../myproject-worktrees/experiment
# ... manual work ...

# Later, create session for it
/worktree-tmux experiment "continue the experiment"

# If useful, merge it
git checkout main
git merge experiment

# If not useful, just delete
/worktree-delete experiment
# Choose: "Yes, delete worktree and branch"
```

---

### Example 4: Using with Beads

```bash
# Check ready beads
bd ready

# Create worktree for a bead
/worktree-new issue-5 "work on bead issue-5"

# bd commands work in the worktree (BEADS_NO_DAEMON=1 set)
bd show issue-5
bd update issue-5 --status in-progress

# When done
bd close issue-5

# Merge and cleanup
git checkout main
/worktree-delete issue-5
```

---

## Best Practices

### 1. Naming Conventions

**Good names:**
- `feature-auth` - Clear, descriptive
- `fix-memory-leak` - Purpose obvious
- `redis-cache` - Short, meaningful

**Avoid:**
- `test` - Too generic
- `tmp` - What is it?
- `asdfasdf` - Meaningless

### 2. Bead Integration

**Always link worktrees to beads:**
```bash
# Good: Bead name in worktree
/worktree-new issue-5 "work on bead issue-5"

# Even better: Bead context in prompt
/worktree-new auth-feature "work on bead auth-feature-7, implement JWT with refresh token rotation"
```

### 3. Session Management

**Detach, don't exit:**
```bash
# Good: Detach (keeps session running)
Ctrl+b, d

# Bad: exit (kills the session)
exit
```

**Use wt for switching:**
```bash
# Good: Visual overview before switching
wt

# Okay: Direct attach (if you remember the name)
tmux attach -t wt-feature-name
```

### 4. Cleanup Regularly

**Don't accumulate stale worktrees:**
```bash
# Weekly: Check what's active
/worktree-status

# Merge or delete old worktrees
/worktree-delete old-feature
```

### 5. Beads + Worktrees

**Always use BEADS_NO_DAEMON=1:**
- Automatic in tmux sessions created by `/worktree-new`
- Manual: `export BEADS_NO_DAEMON=1` before bd commands
- Prevents database conflicts
- Reference: https://github.com/steveyegge/beads/issues/170

---

## Troubleshooting

### Problem: "attempt to write a readonly database"

**Cause:** Beads daemon conflict with worktrees

**Solution:**
```bash
# In worktree tmux session
export BEADS_NO_DAEMON=1
bd <command>

# Or use flag per command
bd --no-daemon <command>
```

**Prevention:** Use `/worktree-new` - sets BEADS_NO_DAEMON=1 automatically

---

### Problem: Can't attach to session

**Cause:** Not in a tmux session, or session doesn't exist

**Solution:**
```bash
# Check if session exists
tmux ls | grep wt-

# Attach from outside tmux
tmux attach -t wt-feature-name

# Switch from inside tmux
tmux switch-client -t wt-feature-name
```

---

### Problem: Lost track of which worktrees exist

**Solution:**
```bash
# Quick view
/worktree-list

# Detailed view
/worktree-status

# Visual dashboard
wt
```

---

### Problem: Tmux session stuck/frozen

**Solution:**
```bash
# Check what it's doing
/worktree-status feature-name

# Kill and recreate
tmux kill-session -t wt-feature-name
/worktree-tmux feature-name
```

---

### Problem: Merge conflicts

**Current solution:**
```bash
git merge feature-name
# If conflicts, resolve manually
vim <conflicted-file>
git add <conflicted-file>
git commit
```

**Future solution (coming soon):**
```bash
git-merge-agent feature-name
# Context-aware conflict resolution with Claude
```

---

## Integration with Other Tools

### With Beads

**Worktrees and beads work together:**
```bash
# Create worktree for bead
bd ready  # See what's ready
/worktree-new issue-5 "work on bead issue-5"

# Work on it (bd commands work with BEADS_NO_DAEMON=1)
bd show issue-5
bd update issue-5 --status in-progress

# Complete it
bd close issue-5
git checkout main
/worktree-delete issue-5
```

### With wt Dashboard

**wt shows all worktrees at a glance:**
```bash
wt  # Visual snapshot
# Select, press Enter
# Work...
# Ctrl+b, d
# wt again to switch
```

### With git-merge-agent (Coming Soon)

**Context-aware conflict resolution:**
```bash
git checkout main
git merge feature-name
# If conflicts:
git-merge-agent feature-name
# Claude helps resolve with full context
```

---

## Advanced Usage

### Custom Prompts

**Be specific with initial prompts:**
```bash
# Generic (okay)
/worktree-new api "build API"

# Specific (better)
/worktree-new api "build REST API with Express, implement user CRUD endpoints with Prisma"

# Bead-linked (best)
/worktree-new api-users "work on bead api-users-3, implement GET/POST/PUT/DELETE /users endpoints with validation"
```

### Multiple Tmux Windows

**Inside a worktree session:**
```bash
# Create new window
Ctrl+b, c

# Switch windows
Ctrl+b, n  # Next
Ctrl+b, p  # Previous
Ctrl+b, 0-9  # Window by number

# Rename window
Ctrl+b, ,
```

### Session Persistence

**Sessions survive:**
- ✅ Terminal closing
- ✅ System sleep
- ✅ SSH disconnection (if using tmux on remote)

**Sessions don't survive:**
- ❌ System restart
- ❌ tmux server crash
- ❌ Manual kill

---

## Performance Tips

### Keep Sessions Lean

**Don't run too many simultaneous Claude sessions:**
- 3-5 is manageable
- More than 5 → consider if you really need them all

### Clean Up Regularly

**Weekly cleanup:**
```bash
# See what's active
wt

# Delete merged worktrees
/worktree-delete old-feature-1
/worktree-delete old-feature-2

# Kill unused sessions
tmux kill-session -t wt-unused
```

### Use --no-session When Appropriate

**For quick experiments:**
```bash
# No need for Claude session
/worktree-new quick-test --no-session
cd ../project-worktrees/quick-test
# ... quick manual work ...
cd -
git worktree remove ../project-worktrees/quick-test
```

---

## Reference

### File Locations

**Worktree commands:** `~/.claude/commands/worktree-*.md`
**wt command:** `~/agentic-coding-research/tools/wt`
**Documentation:** `~/agentic-coding-research/docs/WORKTREE_WORKFLOW.md`

### Key Environment Variables

**BEADS_NO_DAEMON=1:** Required for beads in worktrees
**TMUX:** Set when inside tmux session

### Tmux Session Naming

**Pattern:** `wt-<feature-name>`
**Example:** `wt-auth-jwt`, `wt-redis-cache`

### Related Issues

**Beads + Worktrees:** https://github.com/steveyegge/beads/issues/170

---

## Summary

**Five commands, complete workflow:**

1. `/worktree-new <name> "<prompt>"` - Create and start
2. `wt` - See and switch
3. `Ctrl+b, d` - Detach without closing
4. `/worktree-status` - Check what's happening
5. `/worktree-delete <name>` - Merge and cleanup

**That's it.** Everything else is built on these foundations.

**Start simple. Scale as needed. Ship actual work.**
