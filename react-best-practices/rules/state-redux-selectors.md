---
title: Use Memoized Selectors for Derived State
impact: MEDIUM-HIGH
impactDescription: prevents wasted re-renders
tags: state, redux, selectors, reselect, memoization
---

## Use Memoized Selectors for Derived State

`createSelector` from Redux Toolkit memoizes derived state computations. Components only re-render when the derived result actually changes, not when unrelated parts of the store update.

**Incorrect (derived state computed in component / every render):**

```tsx
function TodoStats() {
  const todos = useSelector((state: RootState) => state.todos);
  const completedCount = todos.filter(t => t.done).length;
  const totalCount = todos.length;

  return <div>{completedCount}/{totalCount} completed</div>;
}
// Recomputes filter on EVERY store change, even unrelated state
```

**Correct (memoized selector):**

```ts
// todosSelectors.ts
import { createSelector } from '@reduxjs/toolkit';
import type { RootState } from './store';

const selectTodos = (state: RootState) => state.todos;

export const selectCompletedCount = createSelector(
  selectTodos,
  (todos) => todos.filter(t => t.done).length
);

export const selectTotalCount = createSelector(
  selectTodos,
  (todos) => todos.length
);

export const selectCompletionRatio = createSelector(
  selectCompletedCount,
  selectTotalCount,
  (completed, total) => total === 0 ? 0 : completed / total
);
```

```tsx
function TodoStats() {
  const completedCount = useSelector(selectCompletedCount);
  const totalCount = useSelector(selectTotalCount);

  return <div>{completedCount}/{totalCount} completed</div>;
}
// Only re-renders when completedCount or totalCount changes
```

**Patterns to follow:**
- Put selectors in `*Selectors.ts` files, not in components
- Compose selectors: `createSelector(a, b, (a, b) => ...)`
- Use `createSelector` even for simple lookups — it's free and future-proof
- Never create selectors inside render (defeats memoization)

Reference: [https://redux-toolkit.js.org/api/createSelector](https://redux-toolkit.js.org/api/createSelector)
