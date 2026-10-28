# Node.js/TypeScript Development Rules

Standards and patterns for Node.js and TypeScript development.

---

## Project Structure

```
src/
├── routes/           # Route handlers (Express/Fastify)
├── services/        # Business logic
├── models/          # Data models/schemas
├── middleware/      # Express middleware
├── utils/           # Helper functions
├── types/           # TypeScript type definitions
└── config/          # Configuration
```

**Principles:**
- Group by feature, not by file type
- Keep related code together
- Shallow directory depth (max 3 levels)

---

## TypeScript Standards

### Type Safety

```typescript
// ✅ GOOD - Explicit types
function getUser(id: string): Promise<User> { ... }

// ❌ BAD - any type
function getUser(id: any): any { ... }

// ✅ GOOD - Interface for data shapes
interface CreateUserDTO {
  name: string;
  email: string;
}

// ❌ BAD - No type for external data
function createUser(data) { ... }
```

### Type Rules

- **NEVER** use `any` - use `unknown` for truly unknown data
- **ALWAYS** use explicit return types on public functions
- **USE** interfaces for data shapes
- **USE** `readonly` for immutable data
- **USE** discriminated unions for state machines

---

## Error Handling

### Promise Rejection

```typescript
// ✅ GOOD - Always handle rejections
async function fetchData() {
  try {
    const data = await api.get();
    return data;
  } catch (error) {
    logger.error('Fetch failed', { error });
    throw new DataFetchError('Failed to fetch data', { cause: error });
  }
}

// ❌ BAD - Unhandled rejection
async function fetchData() {
  return api.get(); // What if it fails?
}
```

### Custom Error Classes

```typescript
class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

class ValidationError extends AppError {
  constructor(message: string) {
    super(message, 'VALIDATION_ERROR', 400);
  }
}
```

---

## Async/Await Patterns

```typescript
// ✅ GOOD - Clear async flow
async function processOrder(orderId: string) {
  const order = await db.orders.find(orderId);
  if (!order) throw new NotFoundError('Order');
  
  const processed = await payment.charge(order);
  await db.orders.update(orderId, { status: 'processed' });
  
  return processed;
}

// ❌ BAD - Sequential awaits when parallel possible
async function getUserData() {
  const user = await db.users.find(userId);
  const posts = await db.posts.findByUser(userId); // Can run in parallel!
  const comments = await db.comments.findByUser(userId);
}
```

---

## Middleware Patterns

```typescript
// ✅ GOOD - Composable middleware
const auth = (required: boolean = true) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    const token = req.headers.authorization;
    
    if (!token && required) {
      throw new UnauthorizedError('Missing token');
    }
    
    if (token) {
      req.user = await verifyToken(token);
    }
    
    next();
  };
};
```

---

## Testing Rules

### Test Structure

```typescript
// ✅ GOOD - AAA pattern
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const dto = { name: 'John', email: 'john@example.com' };
      
      // Act
      const user = await service.createUser(dto);
      
      // Assert
      expect(user.id).toBeDefined();
      expect(user.email).toBe('john@example.com');
    });
  });
});
```

### Coverage Requirements

- **Services:** 90%+ coverage
- **Routes:** 80%+ coverage
- **Utils:** 100% coverage

---

## Performance Rules

### Database

```typescript
// ✅ GOOD - Explicit transactions
async function transferFunds(from: string, to: string, amount: number) {
  return db.transaction(async (trx) => {
    const fromAccount = await trx.accounts.find(from);
    if (fromAccount.balance < amount) {
      throw new InsufficientFundsError();
    }
    
    await trx.accounts.update(from, { 
      balance: fromAccount.balance - amount 
    });
    await trx.accounts.update(to, { 
      balance: (await trx.accounts.find(to)).balance + amount 
    });
  });
}

// ❌ BAD - Multiple queries without transaction
```

### N+1 Prevention

```typescript
// ✅ GOOD - Include relations
const users = await db.users.findMany({
  where: { active: true },
  include: { posts: true, comments: true }
});

// ❌ BAD - N+1 query
const users = await db.users.findMany();
for (const user of users) {
  user.posts = await db.posts.findByUser(user.id); // N+1!
}
```

---

## Security Rules

### Input Validation

```typescript
// ✅ GOOD - Validate all input
import { z } from 'zod';

const CreateUserSchema = z.object({
  name: z.string().min(1).max(100),
  email: z.string().email(),
  role: z.enum(['admin', 'user']).default('user')
});

function createUser(raw: unknown) {
  const data = CreateUserSchema.parse(raw); // Throws on invalid
  // ...
}
```

### No Secrets in Code

- Store secrets in environment variables
- Validate presence at startup
- Never log secrets

---

## Logging Rules

```typescript
// ✅ GOOD - Structured logging
logger.info('User created', {
  userId: user.id,
  email: user.email,
  duration: performance.now() - start
});

// ❌ BAD - Interpolated strings
logger.info(`User ${user.email} created`);
```

---

## Environment Configuration

```typescript
// ✅ GOOD - Validated config
import { z } from 'zod';

const configSchema = z.object({
  PORT: z.string().transform(Number).pipe(z.number().min(1)),
  DATABASE_URL: z.string().url(),
  JWT_SECRET: z.string().min(32)
});

export const config = configSchema.parse(process.env);
```
