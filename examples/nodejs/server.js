const http = require('http');
const url = require('url');

const users = new Map();
let idCounter = 1;

const headers = { 'Content-Type': 'application/json' };

const sendJSON = (res, status, data) => {
  res.writeHead(status, headers);
  res.end(JSON.stringify(data));
};

const routes = {
  '/health': { GET: () => ({ status: 'healthy', time: new Date().toISOString() }) },
  '/users': {
    GET: () => ({ users: [...users.values()], count: users.size })
  },
  '/user': {
    GET: (req, query) => {
      const user = users.get(query.id);
      if (!user) return { error: 'user not found', status: 404 };
      return { data: user, status: 200 };
    }
  },
  '/user/create': {
    POST: async (req) => {
      return new Promise((resolve) => {
        let body = '';
        req.on('data', chunk => body += chunk);
        req.on('end', () => {
          try {
            const { email, name } = JSON.parse(body);
            if (!email || !name) {
              resolve({ error: 'email and name required', status: 400 });
              return;
            }
            const user = {
              id: `usr_${idCounter++}`,
              email,
              name,
              created_at: new Date().toISOString(),
              active: true
            };
            users.set(user.id, user);
            resolve({ data: user, status: 201 });
          } catch {
            resolve({ error: 'invalid JSON', status: 400 });
          }
        });
      });
    }
  }
};

const server = http.createServer((req, res) => {
  const parsed = url.parse(req.url, true);
  const pathname = parsed.pathname;
  const method = req.method.toUpperCase();
  const route = routes[pathname];

  if (!route || !route[method]) {
    return sendJSON(res, 404, { error: 'not found' });
  }

  const handler = route[method];
  const result = typeof handler === 'function' 
    ? (handler.length > 1 ? handler(req, parsed.query) : handler(req, parsed))
    : handler;

  Promise.resolve(result).then(output => {
    if (output.error) {
      return sendJSON(res, output.status || 400, { error: output.error });
    }
    sendJSON(res, output.status || 200, output.data || output);
  });
});

users.set('usr_1', { id: 'usr_1', email: 'alice@example.com', name: 'Alice Johnson', created_at: new Date(Date.now() - 86400000).toISOString(), active: true });
users.set('usr_2', { id: 'usr_2', email: 'bob@example.com', name: 'Bob Smith', created_at: new Date(Date.now() - 172800000).toISOString(), active: true });

const PORT = 8080;
server.listen(PORT, () => {
  console.log(`User service starting on :${PORT}`);
  console.log('Endpoints: /health, /users, /user?id=X, /user/create (POST)');
});
