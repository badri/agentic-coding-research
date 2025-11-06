---
description: Create a new git worktree in a sibling worktrees directory
---

You are tasked with creating a new git worktree following a specific convention.

The user will provide a feature name as an argument to this command (e.g., `/worktree-new my-feature`).

**Optional**: The user may also provide:
- A custom prompt to send to Claude after starting the session
- The `--no-session` flag to skip creating a tmux/Claude session

Usage formats:
- `/worktree-new my-feature` - Creates worktree and starts Claude session (default)
- `/worktree-new my-feature "work on bead my-feature-5"` - Creates worktree, starts Claude, and sends the custom prompt
- `/worktree-new my-feature --no-session` - Creates worktree only, no tmux session

Follow these steps:

**First, parse the arguments**:
- Extract the feature name (first argument)
- Check if `--no-session` flag is present anywhere in the arguments
- Extract custom prompt if present (quoted string that is not `--no-session`)

**Then proceed**:

1. Determine the current project's root directory and project name
2. Navigate to the parent directory of the project
3. Create a folder named `<project-name>-worktrees/` if it doesn't exist (as a sibling to the project directory)
4. Create a new git worktree under `<project-name>-worktrees/<feature-name>/`
5. The worktree should create a new branch named after the feature (or use an existing branch if specified)
6. **BD Integration**: Configure beads to work in no-daemon mode for worktree compatibility (see below)

Example:
- Current project: `/path/to/myproject`
- Feature name: `new-feature`
- Worktrees folder: `/path/to/myproject-worktrees/`
- New worktree: `/path/to/myproject-worktrees/new-feature/`
- Branch: `new-feature`
- BD symlink (if applicable): `/path/to/myproject-worktrees/new-feature/.beads -> /path/to/myproject/.beads`

Use `git worktree add` with appropriate flags to create the worktree and branch.

After creating the worktree:
1. Check if the main repository has a `.beads/` directory
2. If yes, configure beads for no-daemon mode to avoid database conflicts in worktrees:
   - Beads daemon doesn't properly track which worktree operations originate from
   - Using no-daemon mode ensures bd commands work correctly in all worktrees
3. Inform the user that bd commands in this worktree should be run with `--no-daemon` flag OR by setting `export BEADS_NO_DAEMON=1`
4. Optional: Test bd access by running `bd --no-daemon stats` in the worktree directory (if bd is available)

## Tmux Integration:

5. **ONLY if `--no-session` flag is NOT present**, create a new tmux session for this worktree:
   - Session name should be based on the feature name (e.g., `wt-new-feature`)
   - The session should start in the worktree directory
   - Automatically start Claude Code in the new tmux session
   - If a custom prompt was provided, send it to Claude after it starts

   Commands to execute:
   ```bash
   # Create tmux session and start Claude in it with --dangerously-skip-permissions
   tmux new-session -d -s "wt-<feature-name>" -c "/path/to/worktree"

   # Set BEADS_NO_DAEMON=1 for the session, then start Claude
   tmux send-keys -t "wt-<feature-name>" "export BEADS_NO_DAEMON=1" Enter
   tmux send-keys -t "wt-<feature-name>" "/Users/lakshminp/.claude/local/claude --dangerously-skip-permissions" Enter

   # If custom prompt provided, send it to Claude after initialization
   # Wait longer for Claude to fully initialize (7-10 seconds)
   sleep 8

   # Send the custom prompt
   # Example: tmux send-keys -t "wt-<feature-name>" "work on bead my-feature-5" Enter
   ```

   **Important**:
   - Wait 8-10 seconds after starting Claude before sending the custom prompt
   - This ensures Claude has fully initialized and is ready to receive input
   - Claude Code initialization can take 5-10 seconds depending on system load
   - The custom prompt should be sent exactly as the user provided it

6. **If `--no-session` flag is present**:
   - Skip all tmux/Claude session creation
   - Inform the user that the worktree was created without a session
   - Provide instructions: "To start a Claude session later, run: /worktree-tmux <feature-name>"

7. **If tmux session was created**, inform the user how to attach:
   ```bash
   tmux attach -t wt-<feature-name>
   ```

Provide the user with:
- The path to the new worktree
- Confirmation that the branch was created
- **If beads is available**: Important note about bd usage in worktrees:
  * "BD configured for no-daemon mode in this worktree"
  * "The session has BEADS_NO_DAEMON=1 set automatically"
  * "All bd commands will work correctly without manual flags"
  * "Reference: https://github.com/steveyegge/beads/issues/170"
- **If `--no-session` flag was used**:
  * Note: "Worktree created without tmux session"
  * Instruction: "To start a Claude session later: /worktree-tmux <feature-name>"
  * **Important**: "When starting Claude manually in this worktree, set: export BEADS_NO_DAEMON=1"
- **If tmux session was created**:
  * The tmux session name that was created
  * If custom prompt was sent: Confirmation that the prompt was sent to Claude
  * Command to attach to the tmux session: `tmux attach -t wt-<feature-name>`
  * Note: "A new tmux session has been created with Claude Code running. BEADS_NO_DAEMON=1 is set automatically. Use the attach command above to switch to it."

**Why no-daemon mode for beads in worktrees**:
- The bd daemon doesn't properly track which worktree operations originate from
- This can cause commits/pushes to the wrong branch
- No-daemon mode (BEADS_NO_DAEMON=1) makes bd operate directly on the database
- All worktrees share the same `.beads/` directory (git worktrees share .git)
- Issues, notes, dependencies remain synchronized across all worktrees
- The `issues.jsonl` file (version controlled) stays in sync automatically
- Reference: https://github.com/steveyegge/beads/issues/170
