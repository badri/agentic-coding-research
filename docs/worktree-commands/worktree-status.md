---
description: Show comprehensive status of all worktrees with Claude sessions
---

You are tasked with showing the status of all git worktrees, their tmux sessions, and Claude activity.

The user may provide optional filters:
- `/worktree-status` - Show all worktrees
- `/worktree-status <worktree-name>` - Show detailed status for specific worktree
- `/worktree-status --active` - Show only worktrees with active tmux sessions
- `/worktree-status --working` - Show only sessions where Claude is actively working

## Steps to Execute

### 1. Discover All Worktrees

Run `git worktree list` to get all worktrees and their branches.

### 2. For Each Worktree, Gather Information

For each worktree, collect the following data:

#### A. Git Status
- Path to worktree
- Branch name
- Commits ahead/behind main: `git rev-list --count main..<branch>` (ahead) and `git rev-list --count <branch>..main` (behind)
- Working directory status: `git -C <worktree-path> status --porcelain`
  - Count uncommitted files
  - Determine if clean or dirty

#### B. Tmux Session Status
- Check if session exists: `tmux has-session -t wt-<branch-name> 2>/dev/null`
- If exists, get session info:
  - Session uptime/creation time: `tmux display-message -t wt-<branch-name> -p '#{session_created}'`
  - Number of windows: `tmux list-windows -t wt-<branch-name> | wc -l`

#### C. Claude Activity Detection
If tmux session exists, capture the last 20 lines:
```bash
tmux capture-pane -t wt-<branch-name> -p | tail -20
```

Parse the output to detect:
- **Idle**: Look for prompt line `> ` or `⏵⏵ bypass permissions on`
- **Working**: Look for tool usage indicators like:
  - `[Using tool: Read]`
  - `[Using tool: Write]`
  - `[Using tool: Edit]`
  - `[Using tool: Bash]`
  - `[Using tool: Grep]`
  - `[Using tool: Glob]`
  - Or any other tool indicators
- **Error**: Look for error messages or stack traces
- **Waiting**: Look for user confirmation prompts

Extract:
- Current tool being used (if any)
- Last visible output (1-2 lines)
- File being worked on (if mentioned)

#### D. Bead Integration (Optional)
If `.beads/` exists in main repo:
- Check if beads commands need no-daemon mode (worktree compatibility)
- Try to get bead info: `BEADS_NO_DAEMON=1 bd show <branch-name> 2>/dev/null`
- Parse bead status, priority, type if found
- Note: Using BEADS_NO_DAEMON=1 ensures correct worktree operation (see https://github.com/steveyegge/beads/issues/170)

### 3. Format and Display Output

Create a structured output for each worktree:

```
📁 <worktree-name>
├─ Branch: <branch-name> (<commits> ahead of main)
├─ Status: [✓ Clean | ⚠️ X uncommitted files]
├─ Tmux: [✓ wt-<name> (running Xm) | ✗ No session]
├─ Bead: <bead-info> (if available)
└─ Activity: [🟢 Working | 🟡 Idle | 🔴 Error | ⚫ Not running]
   │ <activity details>
```

**Status Indicators**:
- 🟢 Working - Claude is actively using tools
- 🟡 Idle - Session running, waiting for input
- 🔴 Error - Error detected in output
- ⚫ Not running - No tmux session

### 4. Summary Section

At the end, provide:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total worktrees: X
Active sessions: X/X
Working: X | Idle: X | Error: X | Not running: X
Uncommitted changes: X worktrees

Quick actions:
  • View all sessions: tmux ls | grep "^wt-"
  • Attach to specific: tmux attach -t wt-<name>
  • Kill all sessions: tmux kill-session -t wt- (use with caution)

Important: Beads in worktrees
  • Tmux sessions have BEADS_NO_DAEMON=1 set automatically
  • Manual bd commands in worktrees need: export BEADS_NO_DAEMON=1
  • Reference: https://github.com/steveyegge/beads/issues/170
```

### 5. Detailed View (if specific worktree requested)

If user provided a specific worktree name, show:
- All of the above information
- Last 50 lines of tmux output
- Recent git commits (last 5): `git log --oneline -5`
- List of modified files: `git status --short`
- Attach command ready to copy

### 6. Filtered Views

If `--active` flag: Only show worktrees with active tmux sessions
If `--working` flag: Only show worktrees where Claude is actively working (not idle)

## Important Notes

- Handle cases where git commands fail (worktree might not exist anymore)
- Handle cases where tmux session names don't follow the `wt-<name>` pattern
- Calculate session runtime from creation timestamp
- Be concise but informative
- Use clear visual separators for readability
- Provide actionable next steps in the summary

## Example Activity Detection Logic

Parse last 20 lines of tmux output:
- If contains `> ` at the end → **Idle**
- If contains `[Using tool:` → **Working** (extract tool name)
- If contains `Error:` or `error:` or stack trace patterns → **Error**
- If contains `Do you want to` or `Confirm` → **Waiting for user**
- Otherwise → **Unknown** (show last line)

## Time Formatting

Convert tmux session creation timestamp to human-readable:
- Less than 60s: "Xs"
- Less than 60m: "Xm"
- Otherwise: "Xh Ym"

Example: Session created 920 seconds ago → "15m"
