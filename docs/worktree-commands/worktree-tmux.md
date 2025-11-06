---
description: Attach to a worktree's tmux session or create one if it doesn't exist
---

You are tasked with helping the user attach to a worktree's tmux session.

The user will provide a worktree/branch name as an argument (e.g., `/worktree-tmux jwt-auth-2`).

**Optional**: The user may also provide a custom prompt to send to an existing Claude session.

Usage formats:
- `/worktree-tmux my-feature` - Attach to or create tmux session
- `/worktree-tmux my-feature "work on bead my-feature-5"` - Send custom prompt to the session (if it exists)

Follow these steps:

1. **Identify the worktree**:
   - List all worktrees using `git worktree list`
   - Find the worktree matching the provided name
   - If not found, show available worktrees and exit

2. **Check for existing tmux session**:
   - Session name format: `wt-<branch-name>`
   - Check if session exists: `tmux has-session -t wt-<branch-name> 2>/dev/null`

3. **If session exists**:
   - Inform user: "Tmux session 'wt-<branch-name>' found"
   - **If custom prompt provided**:
     * Send the prompt to the tmux session: `tmux send-keys -t "wt-<branch-name>" "<custom-prompt>" Enter`
     * Confirm: "Custom prompt sent to the Claude session in tmux"
   - Provide attach command: `tmux attach -t wt-<branch-name>`
   - Note: You cannot directly attach from Claude Code, provide the command for user to run

4. **If session does NOT exist**:
   - Inform user: "No tmux session found for this worktree"
   - Offer to create one:
     * Create new tmux session: `tmux new-session -d -s "wt-<branch-name>" -c "<worktree-path>"`
     * Set BEADS_NO_DAEMON for the session: `tmux send-keys -t "wt-<branch-name>" "export BEADS_NO_DAEMON=1" Enter`
     * Start Claude in the session: `tmux send-keys -t "wt-<branch-name>" "/Users/lakshminp/.claude/local/claude --dangerously-skip-permissions" Enter`
     * **If custom prompt provided**:
       - Wait for Claude to start: `sleep 8`
       - Send the prompt: `tmux send-keys -t "wt-<branch-name>" "<custom-prompt>" Enter`
     * Provide attach command: `tmux attach -t wt-<branch-name>`
     * Note: "BEADS_NO_DAEMON=1 has been set for this session (worktree compatibility)"

5. **List all worktree tmux sessions** (helpful context):
   - Show all active tmux sessions that start with `wt-`: `tmux list-sessions 2>/dev/null | grep "^wt-"`

Provide the user with:
- Status of the tmux session (exists or created)
- Command to attach to the session
- List of all worktree-related tmux sessions
- Tip: "Use Ctrl+b, then d to detach from tmux session"

Example output:
```
Tmux session 'wt-jwt-auth-2' found!

To attach to this session, run:
  tmux attach -t wt-jwt-auth-2

Active worktree sessions:
  wt-jwt-auth-2: 1 windows
  wt-redis-registry-3: 1 windows
  wt-websocket-connection-mgr-4: 1 windows

Tip: Press Ctrl+b, then d to detach without closing the session
```
