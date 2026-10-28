# Go Example

This directory contains a minimal Go microservice demonstrating **golang-pro** skill patterns.

## What's Included

`main.go` - A user management HTTP service with:
- RESTful endpoint patterns
- JSON request/response handling
- Basic error handling
- Structure definitions with tags
- Handler pattern (similar to standard library patterns)

## Relevant Skills

- `golang-pro` - Full Go development workflow
- `repo-navigator` - Analyze Go project structure

## How to Run

```bash
cd examples/go
go run main.go
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

Try running this command to explore the Go example:

```
/go-task "Review this Go service for best practices and issues"
```

## Common Issues to Find

This intentionally simple code has a few areas for improvement:

1. **No graceful shutdown** - Server doesn't handle signals properly
2. **In-memory storage only** - Data lost on restart
3. **No authentication** - Endpoints are open
4. **No input sanitization** - Basic validation only

Run `golang-pro` to get recommendations for making this production-ready.
