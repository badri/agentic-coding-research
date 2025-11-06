# Organic Pattern Capture Tools

Lightweight scripts to capture learnings from real Claude Code work.

## Installation

Add to your PATH:

```bash
# Add to ~/.zshrc or ~/.bashrc
export PATH="$HOME/agentic-coding-research/tools:$PATH"

# Reload
source ~/.zshrc  # or source ~/.bashrc
```

Or create aliases:

```bash
# Add to ~/.zshrc or ~/.bashrc
alias claude-session='~/agentic-coding-research/tools/claude-session'
alias claude-pattern='~/agentic-coding-research/tools/claude-pattern'
alias claude-review='~/agentic-coding-research/tools/claude-review'
```

## Usage

### `claude-session` - Start a session note

**When to use:** Beginning of a Claude Code work session

```bash
cd your-project
claude-session
```

Creates `.claude/sessions/YYYY-MM-DD-HHMM.md` with template for:
- Session goals
- Interactions with Claude
- Patterns observed
- Outcomes

**Benefits:**
- Context across sessions (solves your devrag need organically)
- Pattern capture during work
- Git-trackable (versions with your code)

---

### `claude-pattern` - Quick pattern capture

**When to use:**
- Something works really well → capture immediately
- Something breaks → capture the pain point
- Discovery moment → capture the insight

```bash
# Capture a win
claude-pattern "Using TypeScript interfaces in first prompt gets perfect types"

# Capture a pain point
claude-pattern "Lost context after 3 refactoring iterations - need session breaks"

# Capture an innovation
claude-pattern "Combining beads + Claude sessions = perfect task tracking"
```

**Saves to:** `~/agentic-coding-research/patterns/YYYY-MM.md`

**Benefits:**
- Zero friction capture
- Monthly aggregation automatic
- Feeds into reviews
- Can commit to git for project context

---

### `claude-review` - Monthly review

**When to use:** End of month (30 minutes)

```bash
# Review current month
claude-review

# Review specific month
claude-review 2025-01
```

**Does:**
1. Shows all patterns captured this month
2. Counts projects and patterns
3. Creates insight template
4. Helps decide: Ship, Fix, or Wait

**Saves to:** `~/agentic-coding-research/insights/YYYY-MM.md`

**Benefits:**
- See what's working/breaking across projects
- Identify patterns worth sharing
- Prioritize tool improvements
- Track evolution over time

---

## Workflow

### Daily (While Working)

```bash
# Start session
cd project
claude-session

# ... work with Claude Code ...

# Quick capture as you go
claude-pattern "Zod + React Hook Form prompt pattern works perfectly"

# ... more work ...

claude-pattern "Context limit hit on large refactor - split into smaller tasks"

# End session (update session note with outcomes)
```

### Monthly (30 minutes)

```bash
# Run review
claude-review

# Opens editor with:
# - All patterns from this month
# - Template for insights
# - Decision framework (Ship/Fix/Wait)

# Fill in:
# - Projects shipped
# - What worked / what broke
# - Decisions for next month
```

### Quarterly (Share Something)

```bash
# Look back at 3 months of insights
cat ~/agentic-coding-research/insights/2025-*.md

# Extract:
# - Top patterns to share (blog post)
# - Top pain points to fix (build tool)
# - Top innovations (case study)
```

---

## File Structure

After a month of use:

```
your-project/
├── .claude/
│   └── sessions/
│       ├── 2025-01-15-1430.md  # Session notes
│       ├── 2025-01-16-0900.md
│       └── 2025-01-20-1530.md
│
~/agentic-coding-research/
├── patterns/
│   ├── 2025-01.md              # Aggregated patterns
│   └── 2025-02.md
├── insights/
│   ├── 2025-01.md              # Monthly reviews
│   └── 2025-02.md
└── tools/
    ├── claude-session*
    ├── claude-pattern*
    └── claude-review*
```

---

## Integration with Existing Tools

### With Beads

```bash
# After completing a bead, capture the approach
bd complete <bead-id>
claude-pattern "Used [approach] to solve [problem] - worked great"

# Or link session to bead
claude-session  # In notes, reference: "Working on bead: <id>"
```

### With Git

Session notes are in `.claude/sessions/` - you can:

```bash
# Commit session notes with code
git add .claude/sessions/
git commit -m "Feature X implementation + session notes"

# Or keep private (add to .gitignore)
echo ".claude/" >> .gitignore
```

### With Worktrees

Each worktree gets its own `.claude/` directory:

```bash
# In worktree A
cd worktrees/feature-a
claude-session  # Creates worktrees/feature-a/.claude/sessions/...

# In worktree B
cd worktrees/feature-b
claude-session  # Creates worktrees/feature-b/.claude/sessions/...

# Patterns aggregate to central repo
```

---

## Examples

### Example Session Note

```markdown
# Session: 2025-01-15-1430

## Goal
Implement JWT authentication with refresh token rotation

## Starting Point
- Basic Express server set up
- Prisma schema defined
- No auth yet

---

## Interactions

### Initial Auth Implementation

**Prompt:**
```
Implement JWT authentication for Express with:
- Access tokens (15min)
- Refresh tokens (7 days) with rotation
- Roles stored in JWT claims as array
- Permissions as object in claims
```

**Result:** ✅ Success

**Notes:**
- Specifying exact JWT structure upfront got perfect implementation
- Claude understood refresh token rotation without further clarification
- Generated both middleware and route handlers

### Security Improvements

**Prompt:**
```
Add httpOnly cookies for token storage and CSRF protection
```

**Result:** ⚠️ Partial

**Notes:**
- Got httpOnly cookies correctly
- CSRF implementation needed refinement
- Asked Claude to use csurf package specifically → perfect

---

## Outcomes

- [X] JWT auth with refresh rotation
- [X] httpOnly cookie storage
- [X] CSRF protection
- [X] Unit tests for auth flow

## Patterns Observed

**Wins:**
- Detailed upfront specs for JWT structure = no back-and-forth
- Asking for specific packages when you know them = faster

**Pain Points:**
- Generic "security" prompts need more detail
- Context started getting long after 4 iterations

## Next Session

- [ ] Add role-based authorization middleware
- [ ] Integration tests

---

## Time Spent
Start: 14:30
End: 16:45
Duration: 2h 15min
```

### Example Pattern Capture

```markdown
# Patterns: January 2025

---
**Date:** 2025-01-15 16:00
**Project:** saas-api
**Pattern:** Specifying exact TypeScript interfaces in prompts eliminates type errors

---
**Date:** 2025-01-16 10:30
**Project:** saas-api
**Pattern:** Context limit hit after 4 refactoring iterations - break into new session

---
**Date:** 2025-01-18 14:00
**Project:** client-dashboard
**Pattern:** Using shadcn/ui + Tailwind in initial prompt gets perfect component structure

---
**Date:** 2025-01-20 09:15
**Project:** client-dashboard
**Pattern:** Beads + Claude sessions = perfect task tracking with context
```

### Example Monthly Insight

```markdown
# Insights: January 2025

## Projects Shipped

1. **saas-api** - JWT auth, Stripe integration, email notifications
2. **client-dashboard** - React dashboard with shadcn/ui
3. **automation-tool** - CLI tool for client workflow

## Patterns That Emerged

### What Worked 🟢

- **Detailed upfront specs:** Providing exact TypeScript interfaces, JWT structures, or component props in the first prompt consistently produces production-ready code without iterations

- **Package-specific requests:** When I know the right package (e.g., "use csurf for CSRF"), specifying it directly is faster than letting Claude choose

- **Beads + Sessions:** Linking Claude session notes to bead IDs creates perfect context continuity

### What Broke 🔴

- **Context limits:** After 3-4 refactoring iterations, context gets long and Claude loses track. Need to break into new sessions more proactively

- **Worktree coordination:** Still manually switching tmux panes between worktrees - friction point

- **Inter-session context:** Starting new sessions requires me to manually summarize previous work

### Innovations 💡

- **Session notes in `.claude/`:** Project-specific session tracking works better than global notes

- **Pattern capture during work:** Quick `claude-pattern` commands capture insights when fresh

## Tools Status

### Claude Code
- **Usage:** 45 sessions across 3 projects
- **Satisfaction:** 9/10
- **Top use case:** Full-stack feature implementation with detailed specs
- **Biggest frustration:** Context limits on long refactoring sessions

### Beads
- **Projects tracked:** 3
- **What's working:** Dependency tracking, git integration
- **What needs improvement:** Would love Claude to auto-update beads

### Worktrees + Tmux
- **What's working:** Isolation per feature
- **What's breaking:** Manual coordination between sessions

## Decisions

### Ship 🚀
- [X] Blog post: "My Claude Code Prompting Patterns for Production Apps"
  - Share the 5 patterns that consistently work
  - Real examples from saas-api and client-dashboard

### Fix 🔧
- [ ] Build `claude-session-summary` - Auto-summarize previous session for next one
  - Addresses inter-session context loss
  - Should be 50 lines of bash max
  - Use Claude to summarize .claude/sessions/*.md

### Wait ⏸️
- [ ] Worktree coordination - Need more data on what specific coordination breaks
- [ ] Claude-flow evaluation - No clear use case yet

## Next Month Focus

- [ ] Try session summaries manually (before building tool)
- [ ] Capture specific worktree coordination pain points
- [ ] Write and publish blog post
- [ ] Ship 3 more real projects

## Notes

Really happy with how session notes + pattern capture is working. The friction is low enough that I actually do it. Monthly review taking only 30 minutes is key - makes it sustainable.

The "Ship/Fix/Wait" framework is clarifying. Blog post is ready to write. Tool building can wait until I've tried manual session summaries a few times.
```

---

## Philosophy

These tools follow the organic research philosophy:

1. **Zero friction:** Quick capture, no overhead
2. **Real work:** Patterns from actual projects, not synthetic
3. **Monthly cycles:** Sustainable rhythm
4. **Ship/Fix/Wait:** Clear decision framework
5. **Build only when pain is clear:** 3+ occurrences = tool time

---

## Evolution

These tools will evolve based on YOUR usage:

- If pattern capture feels clunky → improve the script
- If monthly review is too manual → add automation
- If new workflow emerges → add new tool

**The tools serve the practice, not the other way around.**

---

## Next Steps

1. Install (add to PATH)
2. Start using in your current project
3. Give it a month
4. Review and decide what's working
5. Improve or discard

**Let real needs drive evolution.**
