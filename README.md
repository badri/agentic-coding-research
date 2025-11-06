# Organic Agentic Coding Research

**Research emerges from real work, not synthetic experiments.**

This is my engineering practice with Claude Code, documented and shared.

## Philosophy

> "Ship real things. Document what works. Share generously. Build tools only when pain is clear."

I use Claude Code as my bread-and-butter coding tool. This repo captures:
- ✅ Patterns that work (prompting, workflows, tool combinations)
- ❌ Pain points that emerge (what needs fixing)
- 💡 Innovations discovered (novel approaches)
- 🚀 Things worth sharing (blog posts, tools, case studies)

**Not academic research. Organic evolution from production work.**

---

## Current Stack

**Primary Tools:**
- **Claude Code** - Interactive AI coding (daily driver)
- **Beads** - Task management with git integration
- **Git worktrees** - Multi-session isolation
- **Tmux** - Session persistence
- **Devrag fork** - Experimenting with inter-session storage

**Capture Tools (This Repo):**
- `claude-session` - Session note templates
- `claude-pattern` - Quick pattern capture
- `claude-review` - Monthly review workflow

---

## Repository Structure

```
agentic-coding-research/
├── README.md                    # This file
├── ORGANIC_WORKFLOW.md          # Philosophy and workflow details
│
├── tools/
│   ├── README.md                # Tool documentation
│   ├── claude-session*          # Session note creator
│   ├── claude-pattern*          # Pattern capture script
│   └── claude-review*           # Monthly review helper
│
├── patterns/
│   ├── 2025-01.md               # Patterns from January
│   └── 2025-02.md               # Patterns from February
│
├── insights/
│   ├── 2025-01.md               # Monthly review & decisions
│   └── 2025-02.md
│
└── docs/
    ├── REQUIREMENTS.md          # (Reference: Synthetic experiment spec)
    ├── EXPERIMENT_WORKFLOW.md   # (Reference: Original comparison plan)
    └── COMPARISON.md            # (Reference: Comparison template)
```

The `docs/` directory contains the original synthetic experiment plan (Claude Code vs claude-flow comparison). **I'm not doing that.** Instead, I'm capturing learnings from real projects organically.

Those docs are useful as reference templates but not the active workflow.

---

## Quick Start

### 1. Install Tools

```bash
# Add to your PATH
export PATH="$HOME/agentic-coding-research/tools:$PATH"

# Or create aliases in ~/.zshrc
alias claude-session='~/agentic-coding-research/tools/claude-session'
alias claude-pattern='~/agentic-coding-research/tools/claude-pattern'
alias claude-review='~/agentic-coding-research/tools/claude-review'

# Reload shell
source ~/.zshrc
```

### 2. Start Capturing (In Your Real Project)

```bash
cd your-actual-project

# Start a session
claude-session

# ... work with Claude Code ...

# Capture patterns as you go
claude-pattern "Using Zod schemas upfront gets perfect validation code"

# ... continue working ...

claude-pattern "Context limit after 4 refactors - need session breaks"
```

### 3. Monthly Review (30 minutes)

```bash
# End of month
claude-review

# Opens editor with:
# - All patterns captured
# - Template for insights
# - Ship/Fix/Wait decision framework
```

### 4. Quarterly Sharing (Share Something)

```bash
# Review 3 months
cat ~/agentic-coding-research/insights/2025-*.md

# Pick something to share:
# - Blog post about patterns
# - Tool to solve pain point
# - Case study of real project
```

---

## Workflow

### Daily: Capture Patterns

**While building real projects:**
- Start session notes (`.claude/sessions/`)
- Quick pattern captures (`claude-pattern`)
- Document what works and what breaks

### Monthly: Extract Insights

**Review and decide:**
1. What worked across projects?
2. What pain points emerged?
3. What's worth sharing (Ship)?
4. What needs fixing (Fix)?
5. What needs more data (Wait)?

### Quarterly: Share Knowledge

**Pick one:**
- Blog post about patterns
- Tool to solve pain point
- Video walkthrough
- Conference talk proposal

---

## Current Status

**Started:** 2025-01-06 (adjusted from synthetic experiment to organic research)

**Tracking:**
- Real projects with Claude Code
- Patterns and pain points as they emerge
- Monthly reviews and decisions

**Next milestones:**
- First month of pattern capture
- First monthly review
- First blog post or tool

---

## Why Not the Synthetic Experiment?

I originally planned to build a "SaaS starter" twice (Claude Code vs claude-flow) for comparison.

**Problem:** That's research for research's sake.

**Better approach:**
- Build real projects (bread and butter work)
- Capture what works organically
- Share learnings from production experience
- Build tools only when pain is clear (3+ occurrences)

**The research IS the practice.**

---

## Evaluation Criteria for Tools

When considering new tools (like claude-flow):

### ✅ Adopt When:
- Pain point hits 3+ times in a month
- Solution is clear and scoped
- I'll use it immediately
- Doesn't disrupt bread-and-butter flow

### ⏸️ Wait When:
- Interesting but no clear use case
- Solution unclear
- Need more data
- Would be nice to have

### ❌ Reject When:
- Doesn't solve real pain point
- Too much overhead
- Academic interest only
- Disrupts productive workflow

---

## Claude-Flow Status

**Explored:** Deep dive completed (see commit history for analysis)

**Finding:** Sophisticated multi-agent system with:
- 10+ agent templates
- Health monitoring & auto-scaling
- 3-tier memory (cache → distributed → SQLite)
- 60+ task types
- 4 coordination topologies

**Gap identified:** Lacks type-safe granular control (technical specs are string-based)

**Decision:** Wait
- No clear use case in current work
- Claude Code handles everything I'm building
- Will revisit if parallel agent execution becomes necessary
- Potential hybrid workflow exists but not needed yet

**Potential contribution:** Type-safe technical constraints (if I adopt claude-flow)

---

## Success Metrics

### Shipping (Primary)
- ✅ Projects completed per month
- ✅ Client satisfaction
- ✅ Revenue

### Learning
- ✅ Patterns discovered
- ✅ Skills leveled up
- ✅ Problems solved uniquely

### Sharing
- ✅ Blog posts published
- ✅ Tools released
- ✅ Community feedback

### Tool Evolution
- ✅ Pain points reduced
- ✅ Workflows improved
- ✅ Time saved (measured)

**NOT:**
- ❌ "Completed synthetic experiment"
- ❌ "Built tool nobody uses"
- ❌ "Research for research's sake"

---

## Get Involved

Doing similar work? I'd love to hear:
- Your Claude Code patterns
- Your pain points
- Your innovations

Open an issue or start a discussion!

---

## Resources

- [Organic Workflow Details](ORGANIC_WORKFLOW.md) - Full philosophy and process
- [Tool Documentation](tools/README.md) - How to use capture scripts
- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code) - Official docs

---

## License

MIT - Use these tools and workflows however you'd like!

---

**Last Updated:** 2025-01-06

**Status:** 🟢 Active - Capturing patterns from real projects
