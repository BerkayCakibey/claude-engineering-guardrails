# Node.js Example

This directory contains a minimal Node.js HTTP service demonstrating **node-implement** skill patterns.

## What's Included

`server.js` - A user management HTTP service with:
- Core Node.js http module (no framework dependencies)
- URL routing pattern
- Promise-based async handlers
- JSON parsing and response formatting
- Query parameter handling

## Relevant Skills

- `node-implement` - Full Node.js/TypeScript development workflow
- `repo-navigator` - Analyze Node.js project structure

## How to Run

```bash
cd examples/nodejs
node server.js
```

## Test the Endpoints

```bash
# Health check
curl http://localhost:8080/health

# List all users
curl http://localhost:8080/users

# Get specific user
curl http://localhost:8080/user?id=usr_1

# Create new user
curl -X POST http://localhost:8080/user/create \
  -H "Content-Type: application/json" \
  -d '{"email":"new@example.com","name":"New User"}'
```

## What to Analyze

Try running this command to explore the Node.js example:

```
/node-task "Review this Node.js service for best practices and issues"
```

## Common Issues to Find

This intentionally simple code has a few areas for improvement:

1. **No input validation library** - Manual validation only
2. **No authentication** - Endpoints are open
3. **In-memory storage only** - Data lost on restart
4. **No request body size limit** - Security risk
5. **No CORS handling** - Not API-ready

Run `node-implement` to get recommendations for making this production-ready.
