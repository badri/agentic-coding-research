---
description: List all git worktrees with their status
---

You are tasked with listing all git worktrees for the current project.

Follow these steps:

1. Determine the current project's root directory
2. Run `git worktree list` to show all worktrees
3. For each worktree, display:
   - Worktree path
   - Current branch
   - Latest commit hash (short)
   - Status (ahead/behind main, clean/dirty)

Provide the user with:
- A formatted table or list of all worktrees
- Branch status relative to main (commits ahead/behind)
- Working directory status (clean or uncommitted changes)
- Total number of worktrees
- **Important note**: Reminder about beads usage in worktrees:
  * "When using bd commands in worktrees, ensure BEADS_NO_DAEMON=1 is set"
  * "Tmux sessions created via /worktree-new have this set automatically"
  * "Reference: https://github.com/steveyegge/beads/issues/170"

Example output format:
```
Worktrees for kubenest-hub:

1. /Users/lakshminp/sb/kubenest-hub (main)
   ✓ Clean working directory

2. /Users/lakshminp/sb/kubenest-hub-worktrees/jwt-auth-2 (jwt-auth-2)
   → 3 commits ahead of main
   ⚠ Uncommitted changes

3. /Users/lakshminp/sb/kubenest-hub-worktrees/redis-registry-3 (redis-registry-3)
   → 2 commits ahead of main
   ✓ Clean working directory

Total: 3 worktrees
```

Use `git status --porcelain` to check for uncommitted changes in each worktree.
Use `git rev-list --count main..branch` to count commits ahead of main.
