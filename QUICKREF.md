# Quick Reference Card

One-page reference for organic pattern capture workflow.

---

## Installation (One Time)

```bash
cd ~/agentic-coding-research
./install.sh
source ~/.zshrc  # or ~/.bashrc
```

---

## Daily Workflow

### Start Work Session

```bash
cd your-project
claude-session
```

Creates `.claude/sessions/YYYY-MM-DD-HHMM.md`

### Capture Patterns (Throughout Day)

```bash
# When something works great
claude-pattern "Using Zod schemas in first prompt gets perfect validation"

# When something breaks
claude-pattern "Context limit after 4 refactors - need to split session"

# When you discover something
claude-pattern "Combining beads + Claude sessions = perfect context tracking"
```

### End of Day (Optional)

Update session note with outcomes and next steps.

---

## Monthly Workflow (30 minutes)

### Last Day of Month

```bash
claude-review
```

This:
1. Shows all patterns from the month
2. Creates insight template
3. Helps you decide: Ship / Fix / Wait

### Fill in Template

- **Projects shipped:** What you built
- **What worked:** Patterns to keep using
- **What broke:** Pain points to address
- **Decisions:** Ship (blog/tool), Fix (improve), Wait (need more data)

---

## Quarterly Workflow (Share Something)

### Review Quarter

```bash
cat ~/agentic-coding-research/insights/2025-{01,02,03}.md
```

### Pick One Thing to Share

**Option 1: Blog Post**
- Top 5 prompting patterns
- Case study of real project
- Tool you built

**Option 2: Tool**
- Extract pain point that hit 3+ times
- Build minimal solution
- Share on GitHub

**Option 3: Video**
- Screen recording of workflow
- Explain your patterns
- Share on YouTube/Twitter

---

## File Structure Reminder

```
your-project/
└── .claude/
    └── sessions/
        ├── 2025-01-15-1430.md
        └── 2025-01-16-0900.md

~/agentic-coding-research/
├── patterns/
│   └── 2025-01.md              # Auto-aggregated
├── insights/
│   └── 2025-01.md              # Monthly review
└── tools/
    ├── claude-session*
    ├── claude-pattern*
    └── claude-review*
```

---

## Commands Cheat Sheet

| Command | When | What it does |
|---------|------|--------------|
| `claude-session` | Start of work | Creates session note template |
| `claude-pattern "..."` | During work | Captures pattern quickly |
| `claude-review` | End of month | Monthly review workflow |

---

## Decision Framework

### Ship 🚀
- Pattern works consistently (3+ times)
- Worth sharing publicly
- → Blog post, tweet, video

### Fix 🔧
- Pain point recurring (3+ times)
- Solution is clear
- → Build minimal tool (80/20 rule)

### Wait ⏸️
- Interesting but unclear
- Need more data
- → Keep observing

---

## Integration with Other Tools

### With Beads

```bash
# Link session to bead
claude-session
# In note: "Working on bead: issue-123"

# After completing bead
bd complete issue-123
claude-pattern "Approach used for issue-123 worked great"
```

### With Git

```bash
# Commit session with code (optional)
git add .claude/sessions/
git commit -m "Feature X + session notes"

# Or keep private
echo ".claude/" >> .gitignore
```

### With Worktrees

Each worktree gets own `.claude/` directory.
Patterns aggregate to central `~/agentic-coding-research/`.

---

## Philosophy Reminder

1. **Capture during work, not after**
2. **Real projects, not synthetic experiments**
3. **Ship consistently, improve iteratively**
4. **Build tools only when pain is clear (3+ times)**
5. **Share generously, learn publicly**

---

## Help

**Detailed docs:**
- `~/agentic-coding-research/README.md` - Overview
- `~/agentic-coding-research/ORGANIC_WORKFLOW.md` - Full workflow
- `~/agentic-coding-research/tools/README.md` - Tool documentation

**Quick test:**
```bash
cd ~/agentic-coding-research
claude-pattern "Testing pattern capture - it works!"
cat patterns/2025-01.md
```

---

## Next Steps

1. ✅ Install tools (`./install.sh`)
2. ✅ Go to real project
3. ✅ Start `claude-session`
4. ✅ Capture patterns with `claude-pattern`
5. ✅ Monthly review with `claude-review`
6. ✅ Quarterly: ship something

**The research IS the practice.** 🚀
