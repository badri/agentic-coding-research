# Claude Code Instructions for This Project

## Project Context

This is an **organic agentic coding research system** - a lightweight framework for capturing learnings from real Claude Code work and turning them into valuable knowledge.

**Philosophy:** Research emerges from practice, not synthetic experiments.

## Working on This Project

### Core Principles

1. **Keep it simple:** Tools should be <100 lines of bash when possible
2. **Zero overhead:** Pattern capture should take <5 seconds
3. **Organic evolution:** Only add features when pain is clear (3+ occurrences)
4. **Real use first:** Test on real projects before adding complexity

### When Making Changes

**Before adding features, ask:**
- Is this solving a real pain point from actual usage?
- Has this pain point hit 3+ times?
- Is this the simplest solution (80/20 rule)?
- Will this add overhead to the daily workflow?

**If no to any → Wait for more data**

### Documentation Standards

- Keep README.md as single source of truth
- START_HERE.md for 5-minute onboarding
- QUICKREF.md for one-page command reference
- Code comments for "why" not "what"

### Commit Style

Follow conventional commits:
```
feat: Add session summary tool
fix: Pattern capture with special chars
docs: Update workflow examples
refactor: Simplify review script
```

Keep commits atomic and meaningful.

### Testing Philosophy

**For bash scripts:**
- Test manually on real projects first
- Edge cases: special characters, empty input, missing files
- Cross-shell compatibility (bash, zsh)

**Before release:**
- Test on fresh project
- Test monthly review with actual captured patterns
- Verify install.sh on clean environment

## Project Structure

```
tools/           - Core capture scripts (keep simple)
patterns/        - Auto-generated pattern captures
insights/        - Monthly review outputs
docs/            - Reference material (not active workflow)
```

## Common Tasks

### Adding a New Tool

1. Start with bash script in `tools/`
2. Keep it simple (<100 lines if possible)
3. Follow existing naming: `claude-*`
4. Add to `tools/README.md`
5. Update QUICKREF.md with new command
6. Test manually on real project
7. Commit with descriptive message

### Updating Documentation

1. README.md is primary - update first
2. Cascade changes to START_HERE.md and QUICKREF.md
3. Keep philosophy consistent across docs
4. Use real examples from actual usage

### Improving Existing Tools

1. Verify pain point from real usage
2. Check if it's hit 3+ times
3. Implement simplest fix
4. Test on actual project
5. Update docs
6. Commit

## What NOT to Do

❌ **Don't add complexity without clear need**
- No frameworks when bash works
- No config files until needed
- No abstraction until pattern is clear

❌ **Don't break the workflow**
- Pattern capture must stay <5 seconds
- Session notes must stay simple
- Monthly review must stay ~30 minutes

❌ **Don't add synthetic examples**
- Use real projects for testing
- Document actual patterns from usage
- Share real learnings

## Integration Points

### With Beads
- Link session notes to bead IDs
- Capture patterns when completing beads
- Document bead-based workflows

### With Git Worktrees
- Each worktree gets own `.claude/` directory
- Patterns aggregate to central repo
- Document coordination patterns

### With Devrag
- Session notes provide input for embeddings
- Pattern captures feed knowledge base
- Document integration when it emerges

## Future Considerations

**When to evaluate tools:**
- Pain point hits 3+ times (clear need)
- Solution is obvious (no speculation)
- Won't disrupt bread-and-butter work

**Potential additions (only when needed):**
- Session summarizer (if context loss recurring)
- Pattern search (if volume gets high)
- Integration exporters (if clear use case)

**Claude-flow integration:**
- Wait for real use case from actual work
- Document hybrid workflows if they emerge
- Consider contribution if adoption happens

## Remember

> "Ship real things. Document what works. Share generously. Build tools only when pain is clear."

**Keep the system:**
- ✅ Simple (bash scripts, markdown files)
- ✅ Fast (5-second captures)
- ✅ Organic (features from real needs)
- ✅ Useful (solves actual problems)

**The research IS the practice.**

## Claude Code Workflow Tips

### When Working on This Project

**Good prompts:**
- "Add error handling to claude-pattern for special characters in quotes"
- "Update START_HERE.md to reflect new session summary feature"
- "Simplify claude-review to remove unnecessary complexity"

**Less effective:**
- "Make this better" (too vague)
- "Add all possible features" (against philosophy)
- "Rewrite in Python" (unnecessary complexity)

### Maintaining Simplicity

If Claude suggests complex solutions:
- Ask: "Is there a simpler bash/markdown approach?"
- Remind: "This should stay under 100 lines"
- Check: "Does this add overhead to daily workflow?"

### Documentation Updates

When docs get out of sync:
- "Review all markdown files and ensure consistency"
- "Update QUICKREF.md to match current tool capabilities"
- "Verify examples in START_HERE.md still work"

## Contributing Back

If this system helps others and patterns emerge:

**Good contributions:**
- Blog posts about real usage
- Case studies from actual projects
- Minimal tools solving real problems
- Workflow patterns that work

**Avoid:**
- Premature abstractions
- Over-engineered solutions
- Synthetic examples
- Feature bloat

---

**Last updated:** 2025-01-06

Keep it simple. Keep it real. Keep shipping.
