---
title: Use Optimistic Updates for Instant Feedback
impact: MEDIUM-HIGH
impactDescription: perceived performance
tags: client, tanstack-query, optimistic-updates, mutations
---

## Use Optimistic Updates for Instant Feedback

Optimistic updates show the expected result immediately before the server confirms, eliminating perceived latency. Use `onMutate` to snapshot and update the cache, and `onError` to roll back.

**Incorrect (waits for server response before UI updates):**

```tsx
const mutation = useMutation({
  mutationFn: (updatedTodo) =>
    fetch(`/api/todos/${updatedTodo.id}`, {
      method: 'PATCH',
      body: JSON.stringify(updatedTodo),
    }).then(r => r.json()),
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['todos'] });
  },
});
// UI shows old state until server responds
```

**Correct (instantly shows expected state, rolls back on error):**

```tsx
const mutation = useMutation({
  mutationFn: (updatedTodo) =>
    fetch(`/api/todos/${updatedTodo.id}`, {
      method: 'PATCH',
      body: JSON.stringify(updatedTodo),
    }).then(r => r.json()),
  onMutate: async (updatedTodo) => {
    await queryClient.cancelQueries({ queryKey: ['todos'] });
    const previousTodos = queryClient.getQueryData(['todos']);
    queryClient.setQueryData(['todos'], (old) =>
      old.map(todo => todo.id === updatedTodo.id ? updatedTodo : todo)
    );
    return { previousTodos };
  },
  onError: (_err, _todo, context) => {
    queryClient.setQueryData(['todos'], context.previousTodos);
  },
  onSettled: () => {
    queryClient.invalidateQueries({ queryKey: ['todos'] });
  },
});
```

**When to use optimistic updates:**
- Toggle actions (like, bookmark, pin)
- Drag-and-drop reordering
- Inline edits where stale data is noticeable
- **NOT** for destructive actions (delete, payment) — wait for server confirm

Reference: [https://tanstack.com/query/latest/docs/framework/react/guides/optimistic-updates](https://tanstack.com/query/latest/docs/framework/react/guides/optimistic-updates)
