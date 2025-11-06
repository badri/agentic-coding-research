# 👋 START HERE

Welcome to your organic agentic coding research system!

## What is this?

A **zero-overhead system** to capture learnings from your real Claude Code work and turn them into valuable knowledge.

**Not:** Academic research, synthetic experiments, or tool polish.
**Yes:** Real projects → capture patterns → share learnings → improve tools.

---

## Quick Start (5 minutes)

### 1. Install (1 min)

```bash
cd ~/agentic-coding-research
./install.sh
source ~/.zshrc  # or ~/.bashrc
```

### 2. Test (1 min)

```bash
# Quick test
claude-pattern "Testing - this is my first pattern capture!"

# Check it worked
cat ~/agentic-coding-research/patterns/2025-01.md
```

### 3. Read Overview (3 min)

```bash
# Quick reference
cat QUICKREF.md

# Full overview
cat README.md
```

---

## Your First Session (Right Now)

### Go to your current project

```bash
cd your-actual-project  # Whatever you're building NOW
```

### Start a session

```bash
claude-session
```

This creates `.claude/sessions/YYYY-MM-DD-HHMM.md` with template.

### Work with Claude Code as usual

Build whatever you're building. No changes to your workflow.

### Capture patterns as you go

When something works:
```bash
claude-pattern "Using TypeScript interfaces upfront eliminates type errors"
```

When something breaks:
```bash
claude-pattern "Lost context after 4 refactorings - need session breaks"
```

When you discover something:
```bash
claude-pattern "Beads + Claude sessions = perfect task context tracking"
```

**That's it.** You're now doing organic research.

---

## Three Simple Tools

| Tool | When | Time |
|------|------|------|
| `claude-session` | Start of work | 30 seconds |
| `claude-pattern "..."` | During work | 5 seconds |
| `claude-review` | End of month | 30 minutes |

---

## The Monthly Cycle

**Week 1-4:** Build projects, capture patterns
**End of month:** `claude-review` (30 min)
**Result:** Decide what to Ship, Fix, or Wait

---

## What Happens Next?

### After 1 Month
- You'll have 10-20 patterns captured
- First monthly review done
- Clear picture of what works/breaks
- Possibly first blog post or tool

### After 3 Months
- Patterns across multiple projects
- Recurring pain points identified
- First tool built or blog post published
- Established organic research habit

### After 1 Year
- Deep knowledge of your Claude Code practice
- Multiple blog posts / tools / talks
- Reputation for agentic coding expertise
- Improved workflow from iterative refinement

---

## The Philosophy

> **"Ship real things. Document what works. Share generously. Build tools only when pain is clear."**

**Research emerges from practice, not before it.**

You're not:
- ❌ Building synthetic experiments
- ❌ Polishing tools nobody uses
- ❌ Doing research for research's sake

You are:
- ✅ Building real projects (bread and butter)
- ✅ Capturing what works (zero overhead)
- ✅ Sharing learnings (build in public)
- ✅ Improving tools (when pain is clear)

---

## Documents Guide

**Start here:**
- `START_HERE.md` ← You are here
- `QUICKREF.md` - One-page command reference

**Understand the system:**
- `README.md` - Overview and philosophy
- `ORGANIC_WORKFLOW.md` - Detailed workflow

**Use the tools:**
- `tools/README.md` - Tool documentation

**Reference (not active):**
- `docs/` - Original synthetic experiment plan (kept for reference)

---

## Common Questions

### "Do I need to do anything different with Claude Code?"

**No.** Work exactly as you do now. Just capture patterns as you go.

### "What if I forget to capture patterns?"

**Fine.** Capture what you remember at end of day/session. Better than nothing.

### "How much overhead is this?"

**~5 seconds per pattern.** Plus 30 minutes monthly review.

### "What if I don't have time for monthly review?"

**Skip it.** The patterns are still captured. Review when you have time.

### "Do I need to share publicly?"

**No.** Capture for yourself. Share if/when you want.

### "Should I use claude-flow?"

**Wait.** Let pain points from real work tell you if you need it. (See README.md for full analysis)

---

## First Steps Checklist

- [ ] Install tools (`./install.sh`)
- [ ] Test pattern capture (`claude-pattern "test"`)
- [ ] Read `QUICKREF.md`
- [ ] Go to real project
- [ ] Start `claude-session`
- [ ] Capture 1 pattern today
- [ ] Update session note at end
- [ ] Do monthly review at end of month

---

## Need Help?

**Quick reference:** `cat QUICKREF.md`
**Full docs:** `cat README.md`
**Philosophy:** `cat ORGANIC_WORKFLOW.md`

---

## Ready?

```bash
# Install
./install.sh && source ~/.zshrc

# Go to your current project
cd your-project

# Start capturing
claude-session
```

**You're now doing organic agentic coding research.** 🚀

The research IS the practice.
The practice IS the research.

Ship real things. Document what works. Share generously.
