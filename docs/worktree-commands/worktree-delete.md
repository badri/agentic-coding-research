---
description: Merge a worktree branch into current branch and delete it after confirmation
---

You are tasked with merging a worktree's branch and deleting the worktree after user confirmation.

The user will provide a worktree name or branch name as an argument (e.g., `/worktree-delete jwt-auth-2`).

Follow these steps CAREFULLY and IN ORDER:

## Phase 1: Pre-merge Checks

1. Identify the target worktree and its branch
2. Check if the worktree exists using `git worktree list`
3. Verify the current branch you're on (the target branch for merging)
4. Check if the worktree has uncommitted changes:
   - Navigate to the worktree directory
   - Run `git status --porcelain`
   - If there are uncommitted changes, WARN the user and ask if they want to proceed

## Phase 2: Attempt Merge

5. Switch to the current branch in the main repo
6. Attempt to merge the worktree's branch: `git merge <branch-name>`
7. Check if the merge was successful:
   - If successful: Continue to Phase 3
   - If conflicts: Show conflicted files and STOP HERE
     * Display: "Merge conflicts detected in the following files:"
     * List all conflicted files
     * Instruct: "Please resolve conflicts manually, then run `/worktree-delete <name>` again"
     * DO NOT proceed to deletion

## Phase 3: User Confirmation (ONLY if merge succeeded)

8. Show merge summary:
   - Worktree path
   - Branch name
   - Number of commits merged
   - Files changed
9. Ask user for confirmation using the AskUserQuestion tool:
   - Question: "Merge completed successfully. Delete worktree and branch?"
   - Options:
     * "Yes, delete worktree and branch" (destructive)
     * "Keep worktree, delete branch only"
     * "Keep both worktree and branch"

## Phase 4: Cleanup (Based on user choice)

10. If user chose "Yes, delete worktree and branch":
    - Check if a tmux session exists for this worktree: `tmux has-session -t wt-<branch-name> 2>/dev/null`
    - If tmux session exists, kill it: `tmux kill-session -t wt-<branch-name>`
    - Remove the worktree: `git worktree remove <path>`
    - Delete the branch: `git branch -d <branch-name>`
    - Confirm deletion to user (including tmux session if it was killed)

11. If user chose "Keep worktree, delete branch only":
    - Keep worktree but delete the branch: `git branch -d <branch-name>`
    - Warn user: "Worktree still exists but is now detached"
    - Note: "Tmux session (if any) was kept running"

12. If user chose "Keep both":
    - Do nothing, inform user that merge is complete but worktree/branch remain
    - Note: "Tmux session (if any) remains active"

## Important Notes:

- NEVER delete a worktree or branch without successful merge and user confirmation
- If merge fails with conflicts, STOP and wait for manual resolution
- Always check for uncommitted changes before merging
- Provide clear feedback at each step
- If the worktree doesn't exist, show available worktrees using `git worktree list`

## Example Interaction:

```
User: /worktree-delete jwt-auth-2