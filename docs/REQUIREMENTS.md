# SaaS Starter Requirements

## Overview
Build a production-ready SaaS starter application with authentication, billing, and notifications.

## Functional Requirements

### 1. Todo Application
- Create, read, update, delete todos
- Mark todos as complete/incomplete
- Todo ownership (belongs to user)
- Todo metadata: created_at, updated_at, due_date
- Filter todos: all, active, completed

### 2. Authentication & Authorization
**Method:** JWT (JSON Web Tokens)

**Token Structure:**
```typescript
interface JWTPayload {
  userId: string;
  email: string;
  roles: string[];  // ['user', 'admin', 'premium']
  permissions: {
    todos: ['read', 'write', 'delete'];
    billing: ['read', 'write'];
    admin?: ['manage_users'];
  };
  iat: number;
  exp: number;
}
```

**Token Lifecycle:**
- Access token: 15 minutes TTL
- Refresh token: 7 days TTL
- Refresh token rotation: Yes (new refresh token on each use)
- Secure storage: httpOnly cookies for web, secure storage for mobile

**Endpoints:**
- POST /auth/register
- POST /auth/login
- POST /auth/refresh
- POST /auth/logout
- GET /auth/me

### 3. Billing Integration (Stripe)
**Features:**
- Subscription tiers: Free, Premium ($10/mo), Team ($25/mo)
- Usage-based limits: Free (10 todos), Premium (unlimited), Team (unlimited + team features)
- Stripe Checkout integration
- Webhook handling for subscription events
- Customer portal for subscription management

**Endpoints:**
- POST /billing/create-checkout-session
- POST /billing/create-portal-session
- POST /billing/webhook (Stripe webhooks)
- GET /billing/subscription

### 4. Email Notifications
**Triggers:**
- Welcome email on registration
- Todo due date reminder (24h before)
- Subscription created/cancelled
- Payment succeeded/failed

**Provider:** Configurable (SendGrid, Resend, or console log for dev)

## Technical Requirements

### Tech Stack (EXACT specifications)

#### Frontend
- **Framework:** Next.js 14 (App Router)
- **UI Library:** shadcn/ui
- **Styling:** Tailwind CSS
- **State Management:** Zustand
- **Form Handling:** React Hook Form + Zod validation
- **HTTP Client:** Fetch with custom wrapper

#### Backend
- **Runtime:** Node.js 20+
- **Framework:** Express (or Next.js API routes)
- **Database:** PostgreSQL
- **ORM:** Prisma
- **Validation:** Zod
- **Testing:** Vitest + Supertest

#### Infrastructure
- **Deployment:** Vercel (or Docker compose for self-hosting)
- **Database Hosting:** Neon or Supabase
- **File Storage:** Vercel Blob or S3

### Database Schema

```prisma
model User {
  id            String   @id @default(cuid())
  email         String   @unique
  passwordHash  String
  roles         String[] // ['user', 'premium', 'admin']
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt

  todos         Todo[]
  subscription  Subscription?
}

model Todo {
  id          String    @id @default(cuid())
  title       String
  description String?
  completed   Boolean   @default(false)
  dueDate     DateTime?
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt

  userId      String
  user        User      @relation(fields: [userId], references: [id])
}

model Subscription {
  id                String   @id @default(cuid())
  userId            String   @unique
  stripeCustomerId  String   @unique
  stripeSubscriptionId String @unique
  status            String   // active, canceled, past_due
  tier              String   // free, premium, team
  currentPeriodEnd  DateTime
  createdAt         DateTime @default(now())
  updatedAt         DateTime @updatedAt

  user              User     @relation(fields: [userId], references: [id])
}

model RefreshToken {
  id        String   @id @default(cuid())
  token     String   @unique
  userId    String
  expiresAt DateTime
  createdAt DateTime @default(now())
}
```

### Security Requirements
- Password hashing: bcrypt (10 rounds)
- SQL injection prevention: Prisma (parameterized queries)
- XSS prevention: Input sanitization + Content-Security-Policy headers
- CSRF protection: SameSite cookies + CSRF tokens for mutations
- Rate limiting: 100 req/min per IP for auth endpoints
- Input validation: Zod schemas on all endpoints

### Quality Requirements
- TypeScript strict mode: enabled
- Test coverage: >70% for business logic
- Error handling: Centralized error handler with proper status codes
- Logging: Structured logging (JSON) with request IDs
- API documentation: OpenAPI/Swagger spec

## Granular Control Test Cases

These are the specific requirements that test whether the tool can handle detailed architectural decisions:

1. **JWT Claims Structure:** Can I specify exact fields in JWT payload?
2. **Token Rotation:** Can I require refresh token rotation on each use?
3. **UI Library:** Can I mandate shadcn/ui specifically (not just "a UI library")?
4. **Stripe Integration:** Can I specify Checkout flow vs. Payment Intents?
5. **Email Provider:** Can I choose SendGrid vs. Resend vs. Postmark?
6. **Database ORM:** Can I require Prisma vs. Drizzle vs. TypeORM?
7. **Testing Framework:** Can I specify Vitest vs. Jest?
8. **Deployment Target:** Can I require Vercel-specific features?

## Success Criteria

### Functional
- All CRUD operations work
- Authentication flow completes (register → login → refresh → logout)
- Stripe checkout creates subscription
- Role-based access control enforces permissions
- Email sends on triggers (or logs in dev mode)

### Non-Functional
- No security vulnerabilities (run `npm audit`)
- TypeScript compiles with no errors
- Tests pass with >70% coverage
- Application runs locally with single `docker-compose up` or `npm run dev`

## Deliverables

1. **Source Code:** Fully functional application
2. **Documentation:**
   - README with setup instructions
   - API documentation
   - Architecture decision records (ADRs) for key choices
3. **Tests:** Unit + integration tests
4. **Deployment:** Instructions or deployed demo

## Measurement Criteria

Track for comparison:
- **Time to completion:** Start to functional app
- **Agent/session count:** How many iterations/agents used
- **Code quality:** TypeScript errors, test coverage, security issues
- **Specification adherence:** Did it follow ALL granular requirements?
- **Developer experience:** How much manual intervention needed?
- **Learnings:** What worked, what didn't, what surprised you?
