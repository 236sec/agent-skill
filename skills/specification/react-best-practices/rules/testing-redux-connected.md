---
title: Test Redux-Connected Components with Real Providers
impact: MEDIUM-HIGH
impactDescription: tests real selectors and dispatch flow
tags: testing, redux, provider, integration
---

## Test Redux-Connected Components

Wrap components in real `<Provider>` with a real (or configured) Redux store. This tests the full integration: component → selector → dispatch → reducer → re-render. Don't mock `useSelector` or `useDispatch`.

**Incorrect (mocks Redux hooks, tests nothing real):**

```tsx
import * as redux from 'react-redux';

vi.mock('react-redux', () => ({
  useSelector: vi.fn(),
  useDispatch: () => vi.fn(),
}));

test('shows user name', () => {
  vi.mocked(redux.useSelector).mockReturnValue({ name: 'Alice' });
  render(<UserProfile />);
  expect(screen.getByText('Alice')).toBeInTheDocument();
});
// All Redux logic is bypassed — selectors, reducers never tested
```

**Correct (real store, real selectors, real dispatch):**

```tsx
import { configureStore } from '@reduxjs/toolkit';
import { Provider } from 'react-redux';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import userReducer, { login } from '@/store/userSlice';

function renderWithStore(ui: React.ReactElement, preloadedState?: object) {
  const store = configureStore({
    reducer: { user: userReducer },
    preloadedState,
  });
  return { store, ...render(<Provider store={store}>{ui}</Provider>) };
}

test('shows user name after login', async () => {
  renderWithStore(<UserProfile />, {
    user: { name: 'Alice', isLoggedIn: true },
  });

  expect(screen.getByText('Welcome, Alice')).toBeInTheDocument();
});

test('dispatches logout on button click', async () => {
  const { store } = renderWithStore(<LogoutButton />, {
    user: { name: 'Alice', isLoggedIn: true },
  });

  await userEvent.click(screen.getByRole('button', { name: /logout/i }));

  expect(store.getState().user.isLoggedIn).toBe(false);
  // NOTE: prefer testing UI outcome over store state — see testing-behavior-over-implementation
});
```

**Helper pattern — reusable render wrapper:**

```tsx
// test-utils.tsx
import { configureStore } from '@reduxjs/toolkit';
import { Provider } from 'react-redux';
import { render, type RenderOptions } from '@testing-library/react';
import { rootReducer, type RootState } from '@/store';

export function renderWithProviders(
  ui: React.ReactElement,
  {
    preloadedState,
    store = configureStore({ reducer: rootReducer, preloadedState }),
    ...renderOptions
  }: { preloadedState?: Partial<RootState>; store?: ReturnType<typeof configureStore> } & RenderOptions = {}
) {
  function Wrapper({ children }: { children: React.ReactNode }) {
    return <Provider store={store}>{children}</Provider>;
  }
  return { store, ...render(ui, { wrapper: Wrapper, ...renderOptions }) };
}
```

Reference: [https://redux.js.org/usage/writing-tests](https://redux.js.org/usage/writing-tests)
