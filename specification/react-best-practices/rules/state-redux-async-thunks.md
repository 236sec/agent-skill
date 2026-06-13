---
title: Async Thunks for API Interactions
impact: MEDIUM-HIGH
impactDescription: structured async, loading states
tags: state, redux, createAsyncThunk, async
---

## Async Thunks for API Interactions

`createAsyncThunk` generates `pending/fulfilled/rejected` action types automatically. For server data that needs caching/deduplication, prefer TanStack Query. Use thunks for actions that _change_ server state and update Redux accordingly.

**Incorrect (manual async in component):**

```tsx
function CheckoutButton() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const checkout = async () => {
    setLoading(true);
    try {
      await fetch('/api/checkout', { method: 'POST' });
      // Now manually update UI somehow...
    } catch (e) {
      setError(e);
    } finally {
      setLoading(false);
    }
  };
}
```

**Correct (createAsyncThunk with Redux):**

```ts
import { createAsyncThunk, createSlice } from '@reduxjs/toolkit';

export const checkout = createAsyncThunk(
  'cart/checkout',
  async (_, { rejectWithValue }) => {
    const res = await fetch('/api/checkout', { method: 'POST' });
    if (!res.ok) return rejectWithValue(await res.json());
    return res.json();
  }
);

const cartSlice = createSlice({
  name: 'cart',
  initialState: { items: [], status: 'idle' as 'idle' | 'loading' | 'succeeded' | 'failed' },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(checkout.pending, (state) => { state.status = 'loading'; })
      .addCase(checkout.fulfilled, (state) => { state.items = []; state.status = 'succeeded'; })
      .addCase(checkout.rejected, (state) => { state.status = 'failed'; });
  },
});
```

**When to use thunks vs TanStack Query:**
- **TanStack Query**: fetching, caching, refetching server data (users, posts, products)
- **Redux thunks**: actions that primarily change client state after an API call (checkout, login, logout)
- **Both together**: thunk dispatches → API call succeeds → `queryClient.invalidateQueries()` to refresh TanStack Query cache

Reference: [https://redux-toolkit.js.org/api/createAsyncThunk](https://redux-toolkit.js.org/api/createAsyncThunk)
