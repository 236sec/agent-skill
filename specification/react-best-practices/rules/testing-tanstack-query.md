---
title: Test TanStack Query Components with QueryClientProvider
impact: MEDIUM-HIGH
impactDescription: real cache and query lifecycle
tags: testing, tanstack-query, QueryClientProvider, msw
---

## Test TanStack Query Components

Wrap components in `<QueryClientProvider>` with a configured `QueryClient` (retries disabled, no refetch on focus). Mock network at the boundary using MSW, not by mocking `useQuery`.

**Incorrect (mocks useQuery — no cache, no mutations, no invalidation):**

```tsx
vi.mock('@tanstack/react-query', () => ({
  useQuery: () => ({ data: [{ name: 'Alice' }], isLoading: false }),
  useMutation: () => ({ mutate: vi.fn() }),
}));
// Test passes even if query keys, cache, or invalidation logic is broken
```

**Correct (real TanStack Query, MSW for network):**

```tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { http, HttpResponse } from 'msw';
import { setupServer } from 'msw/node';

const server = setupServer(
  http.get('/api/users', () => HttpResponse.json([{ id: 1, name: 'Alice' }])),
  http.post('/api/users', async ({ request }) => {
    const body = await request.json();
    return HttpResponse.json({ id: 2, ...body }, { status: 201 });
  }),
);

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

function renderWithQueryClient(ui: React.ReactElement) {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },      // don't retry in tests
      mutations: { retry: false },
    },
  });
  return render(
    <QueryClientProvider client={queryClient}>{ui}</QueryClientProvider>
  );
}

test('creates user and shows it in list', async () => {
  renderWithQueryClient(<UserManager />);

  // Fill form and submit
  await userEvent.type(screen.getByLabelText(/name/i), 'Bob');
  await userEvent.click(screen.getByRole('button', { name: /add user/i }));

  // New user appears (TanStack Query refetched)
  await waitFor(() => {
    expect(screen.getByText('Bob')).toBeInTheDocument();
  });
});

test('shows error when API fails', async () => {
  server.use(
    http.get('/api/users', () => HttpResponse.json({ error: 'Down' }, { status: 500 }))
  );
  renderWithQueryClient(<UserList />);
  expect(await screen.findByText(/error/i)).toBeInTheDocument();
});
```

**Combined wrapper (Redux + TanStack Query):**

```tsx
// test-utils.tsx
export function renderWithProviders(ui: React.ReactElement, options = {}) {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false } },
  });
  const store = configureStore({ reducer: rootReducer, ...options });

  function Wrapper({ children }: { children: React.ReactNode }) {
    return (
      <Provider store={store}>
        <QueryClientProvider client={queryClient}>
          {children}
        </QueryClientProvider>
      </Provider>
    );
  }
  return { store, queryClient, ...render(ui, { wrapper: Wrapper }) };
}
```

Reference: [https://tanstack.com/query/latest/docs/framework/react/guides/testing](https://tanstack.com/query/latest/docs/framework/react/guides/testing)
