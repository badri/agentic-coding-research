# Experiment Workflow

## Pre-Implementation Setup

### 1. Recording Setup
```bash
# Install asciinema for terminal recording
brew install asciinema

# Or for full screen recording
# Use OBS Studio or QuickTime Player
```

### 2. Time Tracking
```bash
# Start timer for each implementation
echo "Start: $(date)" > implementation-A-timeline.txt

# End timer
echo "End: $(date)" >> implementation-A-timeline.txt
```

---

## Implementation A: Claude Code (Granular Control)

### Goal
Demonstrate Claude Code's strength in handling detailed architectural requirements through conversational refinement.

### Workflow

**1. Initial Prompt (Broad):**
```
I want to build a SaaS starter application. Let's start with authentication.
```

**2. Granular Refinement (Interactive):**
```
Use JWT tokens. Store roles as an array and permissions as an object in the claims.
The access token should expire in 15 minutes, refresh in 7 days.
Implement refresh token rotation - each use generates a new refresh token.
```

**3. Tech Stack Specification (As Needed):**
```
For the UI, use shadcn/ui components with Tailwind CSS.
For the database, use Prisma with PostgreSQL.
For validation, use Zod schemas everywhere.
```

**4. Progressive Building:**
- Start with auth
- Add todos
- Add Stripe billing
- Add email notifications
- Iterate on each until perfect

**5. Documentation as You Go:**
Create a log file tracking:
- Each major prompt
- Claude's responses
- Your clarifications
- Time spent per feature
- Issues encountered
- How issues were resolved

### Recording Strategy
```bash
# Record each session
asciinema rec claude-code-session-1-auth.cast
asciinema rec claude-code-session-2-todos.cast
asciinema rec claude-code-session-3-billing.cast
asciinema rec claude-code-session-4-email.cast

# Or use one continuous recording with timestamps
asciinema rec claude-code-full-implementation.cast
```

### Measurement Points

**Track:**
- Total time from first prompt to working app
- Number of interactive clarifications needed
- Number of course corrections
- Specification adherence (checklist of 8 granular requirements)
- Code quality metrics (TypeScript errors, test coverage)
- Your satisfaction level (1-10) with control granularity

**Create:** `/Users/lakshminp/agentic-coding-research/claude-code-impl/METRICS.md`

---

## Implementation B: Claude-Flow (Autonomous)

### Goal
Demonstrate claude-flow's strength in autonomous decomposition and parallel execution.

### Workflow

**1. Create Workflow JSON:**

Save to: `~/claude-tools/claude-flow/workflows/saas-starter.json`

```json
{
  "name": "saas-starter-build",
  "description": "Build production SaaS starter with auth, billing, notifications",
  "variables": {
    "app_name": "saas-starter",
    "frontend_framework": "nextjs",
    "ui_library": "shadcn",
    "css_framework": "tailwind",
    "backend_framework": "express",
    "database": "postgresql",
    "orm": "prisma",
    "validation": "zod",
    "auth_method": "JWT",
    "jwt_access_ttl": "15m",
    "jwt_refresh_ttl": "7d",
    "jwt_refresh_rotation": true,
    "jwt_roles": ["user", "premium", "admin"],
    "jwt_permissions": {
      "todos": ["read", "write", "delete"],
      "billing": ["read", "write"],
      "admin": ["manage_users"]
    },
    "billing_provider": "stripe",
    "subscription_tiers": ["free", "premium", "team"],
    "email_provider": "sendgrid"
  },
  "topology": "hierarchical",
  "agents": [
    {
      "id": "architect",
      "type": "architect",
      "capabilities": ["system-design", "database-design"]
    },
    {
      "id": "backend-dev",
      "type": "implementer",
      "capabilities": ["nodejs", "express", "prisma", "jwt"]
    },
    {
      "id": "frontend-dev",
      "type": "implementer",
      "capabilities": ["react", "nextjs", "shadcn", "tailwind"]
    },
    {
      "id": "integration-dev",
      "type": "implementer",
      "capabilities": ["stripe", "sendgrid", "api-integration"]
    },
    {
      "id": "tester",
      "type": "tester",
      "capabilities": ["testing", "vitest", "integration-testing"]
    }
  ],
  "tasks": [
    {
      "id": "architecture",
      "name": "Design system architecture",
      "type": "architecture-design",
      "assignedTo": "architect",
      "claudePrompt": "Design a SaaS starter application architecture with:\n- Database schema for users, todos, subscriptions, refresh tokens\n- API endpoints for auth, todos, billing\n- JWT authentication with roles: ${jwt_roles} and permissions structure: ${jwt_permissions}\n- Tech stack: ${frontend_framework}, ${backend_framework}, ${database}, ${orm}\n\nProvide detailed schema definitions and API specifications.",
      "requirements": {
        "minReliability": 0.9
      }
    },
    {
      "id": "database-setup",
      "name": "Setup Prisma database schema",
      "type": "database-setup",
      "assignedTo": "backend-dev",
      "dependencies": ["architecture"],
      "claudePrompt": "Implement Prisma schema based on architecture from previous task:\n1. User model with roles array: ${jwt_roles}\n2. Todo model with user relation\n3. Subscription model with Stripe fields\n4. RefreshToken model for token rotation\n\nUse ${database} as database provider.\nInclude migrations setup.",
      "requirements": {
        "minReliability": 0.9
      }
    },
    {
      "id": "auth-implementation",
      "name": "Implement JWT authentication",
      "type": "feature-implementation",
      "assignedTo": "backend-dev",
      "dependencies": ["database-setup"],
      "claudePrompt": "Implement JWT authentication with EXACT specifications:\n\nJWT Payload Structure:\n```typescript\ninterface JWTPayload {\n  userId: string;\n  email: string;\n  roles: string[]; // ${jwt_roles}\n  permissions: ${jwt_permissions};\n  iat: number;\n  exp: number;\n}\n```\n\nRequirements:\n- Access token TTL: ${jwt_access_ttl}\n- Refresh token TTL: ${jwt_refresh_ttl}\n- Refresh token rotation: ${jwt_refresh_rotation}\n- Secure httpOnly cookies\n- bcrypt password hashing (10 rounds)\n\nImplement endpoints:\n- POST /auth/register\n- POST /auth/login\n- POST /auth/refresh (with rotation)\n- POST /auth/logout\n- GET /auth/me\n\nUse ${validation} for input validation.",
      "requirements": {
        "minReliability": 0.95
      },
      "constraints": {
        "maxRetries": 3
      }
    },
    {
      "id": "todos-implementation",
      "name": "Implement todos CRUD",
      "type": "feature-implementation",
      "assignedTo": "backend-dev",
      "dependencies": ["auth-implementation"],
      "claudePrompt": "Implement todos feature:\n- CRUD endpoints (protected by JWT)\n- Role-based access control using JWT permissions\n- User-scoped todos (users only see their todos)\n- Todo schema: title, description, completed, dueDate\n\nUse ${orm} for database access.\nUse ${validation} for input validation.",
      "requirements": {
        "minReliability": 0.9
      }
    },
    {
      "id": "stripe-integration",
      "name": "Integrate Stripe billing",
      "type": "integration",
      "assignedTo": "integration-dev",
      "dependencies": ["database-setup"],
      "claudePrompt": "Integrate ${billing_provider} for subscription billing:\n\nSubscription Tiers: ${subscription_tiers}\n- free: 10 todos limit\n- premium: $10/mo, unlimited todos\n- team: $25/mo, unlimited + team features\n\nImplement:\n1. Stripe Checkout session creation\n2. Webhook handler for subscription events (created, updated, cancelled)\n3. Customer portal session creation\n4. Subscription status sync to database\n\nEndpoints:\n- POST /billing/create-checkout-session\n- POST /billing/create-portal-session\n- POST /billing/webhook\n- GET /billing/subscription\n\nUse Stripe API v2023-10-16.",
      "requirements": {
        "minReliability": 0.95
      }
    },
    {
      "id": "email-notifications",
      "name": "Setup email notifications",
      "type": "integration",
      "assignedTo": "integration-dev",
      "dependencies": ["auth-implementation", "stripe-integration"],
      "claudePrompt": "Implement email notifications using ${email_provider}:\n\nTriggers:\n1. Welcome email on registration\n2. Todo due date reminder (24h before)\n3. Subscription created/cancelled\n4. Payment succeeded/failed\n\nImplement:\n- Email service abstraction\n- Email templates (HTML + text)\n- Queue system for async sending (optional: Bull/BullMQ)\n- Fallback to console.log in development\n\nProvide configuration for both ${email_provider} and console logging.",
      "requirements": {
        "minReliability": 0.85
      }
    },
    {
      "id": "frontend-ui",
      "name": "Build frontend UI",
      "type": "feature-implementation",
      "assignedTo": "frontend-dev",
      "dependencies": ["auth-implementation", "todos-implementation"],
      "claudePrompt": "Build frontend using ${frontend_framework} with EXACT tech stack:\n\nUI Stack:\n- UI Library: ${ui_library}\n- Styling: ${css_framework}\n- State Management: Zustand\n- Form Handling: React Hook Form + ${validation}\n\nPages:\n1. /login - Login form\n2. /register - Registration form\n3. /dashboard - Todo list with CRUD\n4. /billing - Subscription management\n\nComponents (use ${ui_library}):\n- TodoList, TodoItem, TodoForm\n- AuthForm (login/register)\n- SubscriptionCard, BillingPortalButton\n\nRequirements:\n- All forms use React Hook Form + Zod validation\n- API calls use custom fetch wrapper with JWT handling\n- Protected routes check authentication\n- Responsive design with ${css_framework}",
      "requirements": {
        "minReliability": 0.9
      }
    },
    {
      "id": "integration-testing",
      "name": "Write integration tests",
      "type": "testing",
      "assignedTo": "tester",
      "dependencies": ["todos-implementation", "stripe-integration", "email-notifications"],
      "claudePrompt": "Write integration tests using Vitest + Supertest:\n\nTest Coverage:\n1. Auth flow: register → login → refresh → logout\n2. Todo CRUD with authentication\n3. Role-based access control\n4. Stripe webhook handling\n5. Email trigger events\n\nRequirements:\n- Test database setup/teardown\n- Mock Stripe API calls\n- Mock email sending\n- JWT token verification in tests\n- Target: >70% coverage\n\nUse Vitest for test runner.",
      "requirements": {
        "minReliability": 0.85
      }
    }
  ]
}
```

**2. Execute Workflow:**
```bash
cd ~/claude-tools/claude-flow

# Start recording
asciinema rec ~/agentic-coding-research/recordings/claude-flow-execution.cast

# Run workflow
npm start -- run-workflow workflows/saas-starter.json \
  --output ~/agentic-coding-research/claude-flow-impl \
  --log-level debug

# Or if using the Hive Mind interface:
npm start
# Then: create swarm → load workflow → execute
```

**3. Monitor Execution:**
```bash
# Watch agent activity
tail -f logs/swarm-execution.log

# Monitor task status
# (Use claude-flow's UI or CLI commands to check progress)
```

**4. Collect Results:**
```bash
# After completion, copy output
cp -r ~/claude-tools/claude-flow/output/saas-starter ~/agentic-coding-research/claude-flow-impl/

# Export execution metrics
# (claude-flow should provide this - check docs for export command)
```

### Measurement Points

**Track:**
- Total time from workflow submission to completion
- Number of agents spawned
- Task execution timeline (which ran in parallel?)
- Number of task failures/retries
- Specification adherence (checklist of 8 granular requirements)
- Code quality metrics
- Post-execution manual fixes needed

**Create:** `/Users/lakshminp/agentic-coding-research/claude-flow-impl/METRICS.md`

---

## Comparison Phase

### Metrics Template

Create: `/Users/lakshminp/agentic-coding-research/docs/COMPARISON.md`

```markdown
# Implementation Comparison

## Time Metrics
| Metric | Claude Code | Claude-Flow |
|--------|-------------|-------------|
| Total time | X hours | Y hours |
| Auth feature | X min | Y min |
| Todos feature | X min | Y min |
| Billing feature | X min | Y min |
| Email feature | X min | Y min |
| Frontend | X min | Y min |
| Testing | X min | Y min |
| **Total** | **X hours** | **Y hours** |

## Granular Control Adherence (8 Requirements)
| Requirement | Claude Code | Claude-Flow |
|-------------|-------------|-------------|
| 1. JWT claims structure (exact fields) | ✅/❌ | ✅/❌ |
| 2. Token rotation (refresh on each use) | ✅/❌ | ✅/❌ |
| 3. UI library (shadcn/ui specifically) | ✅/❌ | ✅/❌ |
| 4. Stripe Checkout flow | ✅/❌ | ✅/❌ |
| 5. Email provider (SendGrid) | ✅/❌ | ✅/❌ |
| 6. ORM (Prisma) | ✅/❌ | ✅/❌ |
| 7. Testing framework (Vitest) | ✅/❌ | ✅/❌ |
| 8. Deployment target (Vercel) | ✅/❌ | ✅/❌ |
| **Score** | X/8 | Y/8 |

## Code Quality
| Metric | Claude Code | Claude-Flow |
|--------|-------------|-------------|
| TypeScript errors | X | Y |
| Test coverage | X% | Y% |
| Security issues (npm audit) | X | Y |
| Lines of code | X | Y |
| Files created | X | Y |

## Developer Experience
| Aspect | Claude Code | Claude-Flow |
|--------|-------------|-------------|
| Ease of specification | X/10 | Y/10 |
| Control granularity | X/10 | Y/10 |
| Manual intervention needed | X/10 | Y/10 |
| Debugging ease | X/10 | Y/10 |
| Learning curve | X/10 | Y/10 |

## Qualitative Observations

### Claude Code Strengths
- [What worked well?]
- [Where did granular control shine?]
- [Unexpected benefits?]

### Claude Code Weaknesses
- [What was frustrating?]
- [Where did you want more autonomy?]
- [What broke?]

### Claude-Flow Strengths
- [What worked well?]
- [Where did autonomy shine?]
- [Unexpected benefits?]

### Claude-Flow Weaknesses
- [What was frustrating?]
- [Where did you want more control?]
- [What did it get wrong about granular specs?]

## Hypothesis Validation

**Original Hypothesis:** Claude-flow lacks granular control - great for "build me an app" but bad for "implement this specific architectural decision"

**Result:** [CONFIRMED / PARTIALLY CONFIRMED / REJECTED]

**Evidence:**
- [Specific examples from the experiment]
- [Which granular requirements were missed?]
- [Which were handled correctly?]

## Recommendations

**Use Claude Code when:**
- [Based on experiment results]

**Use Claude-Flow when:**
- [Based on experiment results]

**Use Both (Hybrid) when:**
- [Based on experiment results]
```

---

## Blog Post Outline

### Title
"Claude Code vs Claude-Flow: The Granular Control Test - Building a SaaS Starter Two Ways"

### Structure

**1. Introduction**
- The agentic coding landscape
- Two approaches: Interactive (Claude Code) vs. Autonomous (claude-flow)
- The central question: Can autonomous agents handle granular architectural requirements?

**2. The Experiment**
- Task: SaaS starter (auth, billing, notifications)
- 8 granular requirements that test control
- Methodology: Same requirements, two tools

**3. Implementation A: Claude Code**
- Conversational workflow
- Example interactions (with screenshots/recordings)
- How granular control was specified
- Time breakdown
- Results

**4. Implementation B: Claude-Flow**
- Workflow JSON configuration
- Agent swarm execution
- Parallel task execution
- Time breakdown
- Results

**5. The Comparison**
- Side-by-side metrics
- Granular control adherence
- Code quality comparison
- Developer experience

**6. Findings**
- Hypothesis validation
- What each tool excels at
- Surprising discoveries
- The hybrid approach

**7. Recommendations**
- Decision framework for tool selection
- When to use what
- The future of agentic coding

**8. Conclusion**
- Key takeaways
- Next steps in the journey
- Call to action (try it yourself)

### Assets
- Terminal recordings (asciinema → GIF)
- Code snippets (key architectural decisions)
- Metrics comparison charts
- Workflow diagrams
- GitHub repo with full implementations

---

## Timeline

**Week 1: Implementation**
- Day 1-2: Claude Code implementation (record everything)
- Day 3-4: Claude-Flow implementation (record everything)
- Day 5: Comparison and metrics collection

**Week 2: Documentation**
- Day 1-2: Write blog post
- Day 3: Create assets (recordings, diagrams, charts)
- Day 4: Review and editing
- Day 5: Publish and share

---

## Success Criteria

**Minimum:**
- Both implementations functional
- Metrics collected
- Blog post published

**Ideal:**
- Both implementations production-ready
- Detailed metrics comparison
- Blog post + video walkthrough
- GitHub repo with docs
- Social media thread

**Dream:**
- Claude-flow PR with improvements discovered
- "Claude Code best practices" extracted
- Multiple blog posts (this is post #1 in series)
- Conference talk proposal
