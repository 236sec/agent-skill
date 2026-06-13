---
title: Structure Query Keys for Cache Invalidation
impact: MEDIUM-HIGH
impactDescription: precise cache control
tags: client, tanstack-query, cache-keys, invalidation
---

## Structure Query Keys for Cache Invalidation

Design query keys as hierarchical arrays so that `invalidateQueries` can target broad or narrow slices of the cache. This enables surgical invalidation after mutations.

**Incorrect (flat string keys, no hierarchy):**

```ts
// Hard to invalidate all user-related queries at once
useQuery({ queryKey: ['users'], ... })
useQuery({ queryKey: ['user-detail'], ... })
useQuery({ queryKey: ['user-posts'], ... })

// Must list every key to invalidate
queryClient.invalidateQueries({ queryKey: ['users'] })
queryClient.invalidateQueries({ queryKey: ['user-detail'] })
queryClient.invalidateQueries({ queryKey: ['user-posts'] })
```

**Correct (hierarchical keys, partial matching):**

```ts
// Hierarchical: entity type → entity id → resource
useQuery({ queryKey: ['users'], queryFn: fetchUsers })
useQuery({ queryKey: ['users', userId], queryFn: () => fetchUser(userId) })
useQuery({ queryKey: ['users', userId, 'posts'], queryFn: () => fetchUserPosts(userId) })

// Invalidate all user queries with one call
queryClient.invalidateQueries({ queryKey: ['users'] })
// Or just one user's posts
queryClient.invalidateQueries({ queryKey: ['users', userId, 'posts'] })
```

**Key conventions:**
- Start with the entity/resource name (`['users']`, `['posts']`)
- Add identifiers as subsequent elements (`['users', id]`)
- Add sub-resources at deeper levels (`['users', id, 'comments']`)
- Use string literals, not variables, for the root key for type safety

Reference: [https://tanstack.com/query/latest/docs/framework/react/guides/query-keys](https://tanstack.com/query/latest/docs/framework/react/guides/query-keys)
