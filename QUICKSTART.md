# Quick Start Guide

Get up and running with the Claude Code vs Claude-Flow experiment in minutes.

## Prerequisites

- Claude Code installed and configured
- Claude-flow cloned and set up at `~/claude-tools/claude-flow`
- `asciinema` for recording (optional): `brew install asciinema`

## 5-Minute Setup

### 1. Review the Requirements (2 min)
```bash
cd ~/agentic-coding-research
cat docs/REQUIREMENTS.md | less
```

**Key points:**
- Build a SaaS starter (todos + auth + billing + email)
- 8 granular requirements to test control
- Exact tech stack specifications

### 2. Choose Your Starting Point (1 min)

**Option A: Start with Claude Code**
```bash
cd claude-code-impl
echo "Start: $(date)" > METRICS.md
asciinema rec ../recordings/claude-code-$(date +%Y%m%d).cast
claude
```

**Option B: Start with Claude-Flow**
```bash
cd ~/claude-tools/claude-flow
# Copy the workflow (you'll create this from EXPERIMENT_WORKFLOW.md)
cp ~/agentic-coding-research/docs/saas-starter-workflow.json workflows/
npm start
```

### 3. Track As You Go (ongoing)

**For Claude Code:**
- Update `claude-code-impl/JOURNAL.md` after each session
- Log time in `claude-code-impl/METRICS.md`
- Note granular control prompts

**For Claude-Flow:**
- Monitor execution in real-time
- Update `claude-flow-impl/JOURNAL.md` with observations
- Log metrics in `claude-flow-impl/METRICS.md`

---

## Detailed Workflow

### Implementation A: Claude Code

#### Step 1: Initial Prompt
Start broad, then refine:

```
I want to build a SaaS starter application with:
1. Todo CRUD functionality
2. Authentication
3. Stripe billing
4. Email notifications

Let's start with the project setup and database schema.
```

#### Step 2: Granular Refinement
As you build each feature, specify technical details:

**For Auth:**
```
Implement JWT authentication with these exact specifications:

JWT Payload:
{
  userId: string,
  email: string,
  roles: string[],  // ['user', 'premium', 'admin']
  permissions: {
    todos: ['read', 'write', 'delete'],
    billing: ['read', 'write']
  }
}

Token TTLs:
- Access: 15 minutes
- Refresh: 7 days
- Rotation: Yes (new refresh token on each use)

Storage: httpOnly cookies
```

**For UI:**
```
For the frontend, use exactly:
- shadcn/ui for components (not Chakra, not MUI)
- Tailwind CSS for styling
- Zustand for state management
- React Hook Form + Zod for forms
```

#### Step 3: Journal & Measure
After each feature:
1. Update JOURNAL.md with interaction details
2. Record time spent in METRICS.md
3. Note any course corrections

---

### Implementation B: Claude-Flow

#### Step 1: Create Workflow JSON

Extract from `docs/EXPERIMENT_WORKFLOW.md` or create your own:

```bash
cd ~/claude-tools/claude-flow/workflows
# Copy the full workflow JSON from EXPERIMENT_WORKFLOW.md
```

**Key sections to customize:**
- `variables`: Technical stack choices
- `agents`: Types and capabilities
- `tasks`: Detailed prompts with constraints

#### Step 2: Execute

```bash
# Option 1: CLI
npm start -- run-workflow workflows/saas-starter.json \
  --output ~/agentic-coding-research/claude-flow-impl \
  --log-level debug

# Option 2: Interactive UI
npm start
# Then: create swarm → load workflow → execute
```

#### Step 3: Monitor & Journal

While it runs:
```bash
# Watch logs
tail -f logs/swarm-execution.log

# Monitor agent status
# (Use claude-flow's monitoring interface)
```

Update JOURNAL.md with:
- Task completion times
- Agent behaviors
- Granular control adherence

---

## Recording Best Practices

### Terminal Recording (asciinema)

**Full session:**
```bash
asciinema rec my-session.cast
# ... work ...
# Press Ctrl+D to stop
```

**Multiple sessions:**
```bash
asciinema rec session-1-auth.cast
# ... build auth ...
# Ctrl+D

asciinema rec session-2-todos.cast
# ... build todos ...
# Ctrl+D
```

**Convert to GIF (for blog):**
```bash
# Install agg
brew install agg

# Convert
agg session-1-auth.cast session-1-auth.gif
```

### Screen Recording (for video)

**macOS QuickTime:**
1. Open QuickTime Player
2. File → New Screen Recording
3. Record the development session

**OBS Studio (more control):**
1. Install: `brew install obs`
2. Setup scene with terminal + editor
3. Record as you work

---

## Metrics Tracking Cheat Sheet

### Time Tracking

**Start of feature:**
```bash
echo "Auth - Start: $(date)" >> METRICS.md
```

**End of feature:**
```bash
echo "Auth - End: $(date)" >> METRICS.md
```

### Granular Control Checklist

After implementation, check each:

- [ ] 1. JWT claims: exact fields (userId, email, roles[], permissions{})
- [ ] 2. Token rotation: refresh rotates on each use
- [ ] 3. UI: shadcn/ui specifically used
- [ ] 4. Stripe: Checkout flow (not Payment Intents)
- [ ] 5. Email: SendGrid (or specified provider)
- [ ] 6. ORM: Prisma (not alternatives)
- [ ] 7. Testing: Vitest (not Jest)
- [ ] 8. Deployment: Vercel-ready

### Code Quality Checks

**After completion:**
```bash
# TypeScript errors
npx tsc --noEmit | tee -a METRICS.md

# Test coverage
npm run test:coverage | tee -a METRICS.md

# Security audit
npm audit | tee -a METRICS.md
```

---

## Common Issues & Solutions

### Claude Code

**Issue: Context getting too long**
- **Solution:** Split into multiple sessions, reference previous work

**Issue: Claude misunderstands granular requirement**
- **Solution:** Be more explicit, provide examples, use code blocks

**Issue: Need to course correct**
- **Solution:** Direct feedback, show what you want vs. what you got

### Claude-Flow

**Issue: Workflow JSON syntax error**
- **Solution:** Validate JSON, check for trailing commas

**Issue: Agent not following technical constraint**
- **Solution:** Make prompt more explicit, add examples to prompt

**Issue: Task failing repeatedly**
- **Solution:** Check logs, simplify task, split into subtasks

---

## Tips for Success

### General

1. **One requirement at a time:** Don't try to specify everything upfront
2. **Document as you go:** Don't wait until the end
3. **Take screenshots:** Capture key moments
4. **Be honest:** Track failures and issues, not just successes

### Claude Code Specific

1. **Start broad, refine gradually:** Let Claude ask questions
2. **Use code examples:** Show exactly what you want
3. **Leverage conversation:** Ask "why" and "how" for learning

### Claude-Flow Specific

1. **Invest in workflow design:** Time spent on clear prompts pays off
2. **Use variables wisely:** Make it reusable
3. **Monitor execution:** Watch for early issues

---

## After Completion

### 1. Fill in COMPARISON.md (1-2 hours)
- Copy metrics from both METRICS.md files
- Run code quality checks on both
- Fill in all comparison tables
- Write qualitative analysis

### 2. Write Blog Post (2-3 hours)
- Use COMPARISON.md as source
- Add narrative and storytelling
- Include code snippets and recordings
- Share key insights

### 3. Publish (30 min)
- GitHub repo (make public)
- Blog platform (dev.to, Medium, personal blog)
- Social media (Twitter/X, LinkedIn)
- HN, Reddit (if appropriate)

---

## Questions?

If you get stuck:

1. **Check the docs:**
   - `docs/REQUIREMENTS.md` - Full requirements
   - `docs/EXPERIMENT_WORKFLOW.md` - Detailed workflows
   - `docs/COMPARISON.md` - Comparison template

2. **Consult journals:**
   - `claude-code-impl/JOURNAL.md` - Track issues here
   - `claude-flow-impl/JOURNAL.md` - Track issues here

3. **Review recordings:**
   - Go back and see what happened

4. **Iterate:**
   - This is research, not production
   - Failures are data points
   - Document everything

---

## Timeline Reference

**Week 1: Implementation**
- Days 1-2: Claude Code
- Days 3-4: Claude-Flow
- Day 5: Comparison metrics

**Week 2: Documentation**
- Days 1-2: Blog post
- Day 3: Assets (recordings, diagrams)
- Day 4: Review
- Day 5: Publish

---

**Ready? Let's go!** 🚀

```bash
cd ~/agentic-coding-research
# Choose your path and start tracking!
```
