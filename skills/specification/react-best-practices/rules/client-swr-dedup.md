---
title: Use TanStack Query for Server State (formerly SWR)
impact: MEDIUM-HIGH
impactDescription: caching, deduplication, background refetch
tags: client, tanstack-query, caching, data-fetching
---

## Use TanStack Query for Server State

> **Note:** This rule previously recommended SWR. TanStack Query is now preferred — see `client-tanstack-query.md` for full examples.

TanStack Query (and its predecessor SWR) enables request deduplication, caching, and revalidation across component instances. Always use a server-state library instead of raw `useEffect` + `fetch`.

**Incorrect (no deduplication, each instance fetches):**

```tsx
function UserList() {
  const [users, setUsers] = useState([])
  useEffect(() => {
    fetch('/api/users')
      .then(r => r.json())
      .then(setUsers)
  }, [])
}
```

**Correct (multiple instances share one request):**

```tsx
import { useQuery } from '@tanstack/react-query'

function UserList() {
  const { data: users } = useQuery({
    queryKey: ['users'],
    queryFn: () => fetch('/api/users').then(r => r.json()),
  })
}
```

**For mutations:**

```tsx
import { useMutation, useQueryClient } from '@tanstack/react-query'

function UpdateButton() {
  const queryClient = useQueryClient()
  const { mutate } = useMutation({
    mutationFn: (data) => fetch('/api/user', { method: 'PUT', body: JSON.stringify(data) }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['users'] }),
  })
  return <button onClick={() => mutate({ name: 'Alice' })}>Update</button>
}
```

Reference: [https://tanstack.com/query](https://tanstack.com/query)
