# Organic Agentic Coding Research

## Philosophy

**Research emerges from real work, not synthetic experiments.**

This isn't a comparison lab. This is your engineering practice, documented and shared.

---

## The System

### 1. Build Real Projects (Your Bread & Butter)

**Use Claude Code for everything you're shipping:**
- Client projects
- Side projects
- Open source contributions
- Learning new tech

**Existing setup:**
- ✅ Claude Code (primary tool)
- ✅ Beads (task management)
- ✅ Git worktrees (multi-session work)
- ✅ Tmux (persistence)
- ✅ Devrag fork (experimenting with storage)

### 2. Capture Patterns As They Emerge

**Not before. Not after. DURING.**

**Quick capture template** (keep in project root):

```bash
# In any project
echo "---
Date: $(date)
Project: [name]
Pattern: [what worked/broke]
---" >> ~/agentic-coding-research/patterns/$(date +%Y-%m).md
```

**What to capture:**

#### 🟢 Things That Work
- Prompting patterns that consistently produce good code
- Workflows that feel smooth
- Bead structures that scale well
- Claude Code + tool combinations that shine

#### 🔴 Pain Points
- Where you wish for more autonomy (claude-flow territory)
- Where coordination breaks (worktree/tmux issues)
- Where context is lost (inter-session storage gaps)
- Where you repeat yourself (could be automated)

#### 💡 Innovations
- Novel workflows you invented
- Problems you solved uniquely
- Patterns worth sharing

---

## Monthly Review Cycle

**Every month (30 minutes):**

### 1. Review Captured Patterns
```bash
cd ~/agentic-coding-research
cat patterns/$(date +%Y-%m).md
```

### 2. Extract Insights

**Template:** `insights/YYYY-MM.md`

```markdown
# Month: [Month Year]

## Projects Shipped
1. [Project name] - [Brief description]
2. ...

## Patterns That Emerged

### What Worked
- [Pattern 1 with example]
- [Pattern 2 with example]

### What Broke
- [Pain point 1 with example]
- [Pain point 2 with example]

### Innovations
- [New workflow/pattern discovered]

## Tools Status

### Claude Code
- Usage: [X hours / Y sessions]
- Satisfaction: [/10]
- Top use case: [What worked best]
- Biggest frustration: [What needs fixing]

### Beads
- Projects tracked: [X]
- What's working: [...]
- What needs improvement: [...]

### Worktrees + Tmux
- Sessions coordinated: [X]
- What's working: [...]
- What's breaking: [...]

### Devrag
- Experiments: [...]
- Findings: [...]

## Next Month Focus
- [ ] [Thing to try]
- [ ] [Thing to improve]
- [ ] [Thing to document]
```

### 3. Decide: Ship, Fix, or Wait

**Ship:** Pattern is solid → Blog post / Tweet / GitHub
**Fix:** Pain point is recurring → Build solution
**Wait:** Not enough data → Keep observing

---

## When to Build vs. When to Document

### Build Tools When:
- ✅ Pain point hits 3+ times in a month
- ✅ Solution is clear and scoped
- ✅ You'll use it immediately
- ✅ 80/20 rule: 20% effort, 80% value

### Document Patterns When:
- ✅ Something worked surprisingly well
- ✅ You solved a problem uniquely
- ✅ Others might benefit
- ✅ You want to remember it

### Integrate External Tools When:
- ✅ Your pain point is their strength
- ✅ Cost < benefit (learning + integration time)
- ✅ Doesn't disrupt bread & butter flow

---

## Quarterly: "Look Ma, This Works" Moments

**Every 3 months, ship something substantial:**

### Q1 2025 (Example)
**Ship:** Blog post "My Claude Code Workflow for Production Apps"
- Real projects built
- Actual prompting patterns
- Beads + Claude Code integration
- What you learned

### Q2 2025 (Example)
**Ship:** Tool "claude-session-notes"
- Pain point: Losing context between sessions
- Solution: Simple markdown-based session notes
- Works with beads
- 2 hours to build, use it daily

### Q3 2025 (Example)
**Ship:** Blog series "Building a Multi-Claude Coordination System"
- Document your worktree + tmux setup
- What works, what's duct tape
- How you improved it
- Bridge to claude-flow (if relevant)

### Q4 2025 (Example)
**Ship:** "The Agentic Coding Stack (2025)"
- Year in review
- Tools you actually use
- Workflows that stuck
- Advice for others

---

## Project-Level Pattern Capture

### In Every Project

**Create:** `PROJECT_ROOT/.claude/`

```
.claude/
├── sessions/           # Session notes
│   ├── 2025-01-15.md
│   └── 2025-01-20.md
├── patterns.md         # Patterns specific to this project
├── decisions.md        # Architecture decisions
└── learnings.md        # Things you learned
```

**Session note template** (`.claude/sessions/YYYY-MM-DD.md`):

```markdown
# Session: [Date]

## Goal
[What you're trying to build today]

## Starting Point
[Current state]

## Interactions

### [Feature/Task]
**Prompt:**
```
[What you asked Claude]
```

**Result:** ✅ / ⚠️ / ❌
**Notes:** [What worked, what didn't]

---

## Outcomes
- [X] Feature A completed
- [ ] Feature B blocked on [reason]

## Patterns Observed
- [Pattern worth noting]

## Next Session
- [ ] [What to continue]
```

**Benefits:**
- Context across sessions (addresses devrag need organically)
- Pattern capture happens naturally
- Works with git (tracks with code)
- Feeds into monthly review

---

## Lightweight Tools Worth Building

Based on real needs, not speculation:

### 1. `claude-session` (10 lines of bash)
```bash
#!/bin/bash
# Quick session note creator
SESSION_DIR=".claude/sessions"
mkdir -p $SESSION_DIR
DATE=$(date +%Y-%m-%d)
FILE="$SESSION_DIR/$DATE.md"

if [ ! -f "$FILE" ]; then
  cat > "$FILE" <<EOF
# Session: $DATE

## Goal
[What are you building today?]

## Interactions
EOF
fi

${EDITOR:-vim} "$FILE"
```

### 2. `claude-pattern` (5 lines of bash)
```bash
#!/bin/bash
# Capture a pattern quickly
echo "Pattern: $1" >> ~/agentic-coding-research/patterns/$(date +%Y-%m).md
echo "Project: $(basename $PWD)" >> ~/agentic-coding-research/patterns/$(date +%Y-%m).md
echo "Date: $(date)" >> ~/agentic-coding-research/patterns/$(date +%Y-%m).md
echo "" >> ~/agentic-coding-research/patterns/$(date +%Y-%m).md
```

Usage:
```bash
# When something works great
claude-pattern "Using React Hook Form + Zod schemas in initial prompt gets perfect form code"

# When something breaks
claude-pattern "Claude Code loses context after 3 refactoring iterations - need session export"
```

### 3. Integration with Beads
```bash
# After completing a bead, capture learnings
bd complete <bead-id> && claude-pattern "$(bd show <bead-id>)"
```

---

## Claude-Flow Integration (When/If Needed)

**Don't force it. Let need drive it.**

### Evaluate Claude-Flow When:
- ✅ You hit a project that genuinely needs parallel agent execution
- ✅ Manual coordination becomes unsustainable
- ✅ You have a clear use case (not exploration)

### How to Evaluate:
1. **Try it on ONE real project** (not synthetic experiment)
2. **Document the experience** (same pattern capture)
3. **Compare to Claude Code workflow** (for THAT project)
4. **Decide:** Adopt, hybrid, or stick with Claude Code

### Potential Hybrid Workflow (When It Emerges):
```
Real Project: E-commerce Platform

Phase 1: Architecture (Claude Code)
- Interactive design decisions
- Tech stack choices
- Database schema

Phase 2: Parallel Implementation (Claude-Flow)
- Frontend: Agent 1
- Backend API: Agent 2
- Admin panel: Agent 3

Phase 3: Integration & Polish (Claude Code)
- Debugging
- Refinement
- Production readiness
```

**But only if this pain point actually surfaces from real work.**

---

## Sharing Strategy

### Continuous (Twitter/X Threads)
**Weekly:** Share 1 pattern, win, or learning

```
Working on [project] with Claude Code.

Found this prompting pattern works great for [use case]:

[Code snippet or prompt template]

Shipped in 20 min what used to take 2 hours.
```

### Monthly (Blog Posts)
**Short, tactical posts:**
- "5 Claude Code Prompting Patterns That Ship Faster"
- "How I Use Beads + Claude Code for Client Projects"
- "Debugging with Claude: A Real Session Breakdown"

### Quarterly (Deep Dives)
**Comprehensive guides:**
- "My Production Claude Code Stack (2025)"
- "Building [Real Project] with Agentic Coding"
- "When to Use Claude Code vs. When to Reach for Claude-Flow"

### Yearly (State of the Practice)
**Looking back:**
- Projects shipped
- Tools evolved
- Community impact
- What's next

---

## Success Metrics (Real Ones)

### Shipping
- ✅ Projects completed per month
- ✅ Client satisfaction
- ✅ Revenue (if applicable)

### Learning
- ✅ New patterns discovered
- ✅ Skills leveled up
- ✅ Problems solved uniquely

### Sharing
- ✅ Blog posts published
- ✅ Patterns shared
- ✅ Community feedback

### Tool Evolution
- ✅ Pain points reduced
- ✅ Workflows improved
- ✅ Time saved (real measurement)

**NOT:**
- ❌ "Completed synthetic comparison"
- ❌ "Built tool nobody uses"
- ❌ "Research for research's sake"

---

## The Difference

### Old Approach (Academic):
1. Design experiment
2. Build synthetic project
3. Compare tools
4. Write paper
5. (Maybe) use insights

### New Approach (Organic):
1. Build real project
2. Capture what works/breaks
3. Repeat monthly
4. Share learnings
5. Improve tools when pain point is clear
6. Teach while building

**The research IS the practice.**
**The practice IS the research.**

---

## Next Actions

### This Week
- [ ] Create `.claude/` directory in current project
- [ ] Install tiny capture scripts (`claude-session`, `claude-pattern`)
- [ ] Start capturing patterns as you work

### This Month
- [ ] Keep shipping with Claude Code (your bread & butter)
- [ ] Capture 10+ patterns (good and bad)
- [ ] Do first monthly review
- [ ] Write ONE blog post or thread

### This Quarter
- [ ] Ship 3+ real projects
- [ ] Identify 1-2 major pain points
- [ ] Build ONE tiny tool to solve them
- [ ] Share "Look Ma, This Works" moment

### This Year
- [ ] Establish organic research practice
- [ ] Build in public consistently
- [ ] Evolve tools based on real needs
- [ ] Become known for agentic coding wisdom

---

## Tools at a Glance

### Current Stack (Bread & Butter)
- **Claude Code:** Primary coding tool
- **Beads:** Task management
- **Git worktrees:** Multi-session isolation
- **Tmux:** Session persistence
- **Devrag:** Experimenting with storage

### Lightweight Additions (Build This Week)
- **`.claude/` directories:** Project-level pattern capture
- **`claude-session`:** Quick session notes
- **`claude-pattern`:** Pattern capture script

### Future (When Pain Points Emerge)
- **Session exporter:** If context loss becomes critical
- **Swarm coordinator:** If multi-Claude coordination breaks
- **Claude-flow hybrid:** If parallel execution becomes necessary

---

## Philosophy Summary

> **"Ship real things. Document what works. Share generously. Build tools only when pain is clear. Research emerges from practice, not before it."**

You're not building a research project.
You're building real products.
The research is a byproduct.

**That's infinitely more valuable.**

---

Ready to capture your first pattern from real work? 🚀
