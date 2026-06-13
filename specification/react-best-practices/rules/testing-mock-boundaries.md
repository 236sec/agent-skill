---
title: Mock Only at System Boundaries
impact: MEDIUM-HIGH
impactDescription: realistic tests, fewer false positives
tags: testing, mocking, boundaries, msn
---

## Mock Only at System Boundaries

Mock at the edges of your system — external APIs, browser APIs, time. Never mock your own modules or internal collaborators. This ensures tests exercise real code paths and catch real bugs.

**What to mock:**
- `fetch` / network calls (use MSW)
- `Date.now()` / `setTimeout`
- `localStorage` (if complex)
- Browser APIs not in jsdom (`matchMedia`, `IntersectionObserver`)

**What NOT to mock:**
- Your own hooks, components, utilities
- Redux store, actions, selectors
- TanStack Query hooks
- React Hook Form hooks

**Correct: Mock at the boundary with MSW:**

```tsx
import { http, HttpResponse } from 'msw';
import { setupServer } from 'msw/node';
import { render, screen } from '@testing-library/react';

const server = setupServer(
  http.get('/api/users', () => {
    return HttpResponse.json([
      { id: 1, name: 'Alice' },
      { id: 2, name: 'Bob' },
    ]);
  }),
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

test('displays users from API', async () => {
  render(<UserList />);
  expect(await screen.findByText('Alice')).toBeInTheDocument();
});
// Real component, real TanStack Query, real Redux — only fetch is mocked
```

**Anti-patterns to avoid:**

```tsx
// DON'T: mock your own module
vi.mock('../hooks/useUsers', () => ({
  useUsers: () => ({ data: [{ name: 'Alice' }], isLoading: false }),
}));
// Test passes but useUsers could be completely broken — false confidence

// DON'T: mock Redux dispatch
const mockDispatch = vi.fn();
vi.mock('react-redux', () => ({ useDispatch: () => mockDispatch }));
// Testing implementation, not behavior

// DO: wrap in real provider with real store
import { Provider } from 'react-redux';
import { store } from '@/store';
render(<Provider store={store}><MyComponent /></Provider>);
```

Reference: [/Users/best/.pi/agent/skills/tdd/references/mocking.md](/Users/best/.pi/agent/skills/tdd/references/mocking.md)
