---
title: Use TanStack Query for Server State
impact: MEDIUM-HIGH
impactDescription: caching, deduplication, background refetch
tags: client, tanstack-query, caching, data-fetching
---

## Use TanStack Query for Server State

TanStack Query manages server state with automatic caching, request deduplication, background refetching, and mutation invalidation. It replaces manual `useEffect` + `fetch` patterns.

**Incorrect (manual fetch, no caching, no deduplication):**

```tsx
function UserList() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('/api/users')
      .then(r => r.json())
      .then(setUsers)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <Spinner />;
  return users.map(u => <UserCard key={u.id} user={u} />);
}
```

**Correct (cached, deduplicated, auto-refetching):**

```tsx
import { useQuery } from '@tanstack/react-query';

function UserList() {
  const { data: users, isLoading } = useQuery({
    queryKey: ['users'],
    queryFn: () => fetch('/api/users').then(r => r.json()),
  });

  if (isLoading) return <Spinner />;
  return users.map(u => <UserCard key={u.id} user={u} />);
}
```

**For mutations with cache invalidation:**

```tsx
import { useMutation, useQueryClient } from '@tanstack/react-query';

function CreateUserButton() {
  const queryClient = useQueryClient();

  const mutation = useMutation({
    mutationFn: (newUser) => fetch('/api/users', {
      method: 'POST',
      body: JSON.stringify(newUser),
    }).then(r => r.json()),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });

  return (
    <button onClick={() => mutation.mutate({ name: 'Alice' })}>
      Create User
    </button>
  );
}
```

**Key benefits over raw fetch:**
- Multiple components calling `useQuery({ queryKey: ['users'] })` share one request
- Cache persists across navigation; stale data shown instantly while refetching
- Automatic retry, window focus refetch, and error boundaries

Reference: [https://tanstack.com/query](https://tanstack.com/query)
