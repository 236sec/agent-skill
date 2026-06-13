---
title: Test Behavior Through Public Interfaces
impact: MEDIUM-HIGH
impactDescription: tests survive refactors
tags: testing, tdd, behavior, public-interface
---

## Test Behavior, Not Implementation

Good tests verify _what_ the user sees and _what_ the system does, not _how_ it's built internally. They survive refactors because they don't care about internal structure. See [TDD Skill](/Users/best/.pi/agent/skills/tdd/SKILL.md) for full methodology.

**Incorrect (tests implementation details — fragile):**

```tsx
// Tests that a specific hook is called with specific arguments
test('UserList calls useQuery with correct key', () => {
  const spy = vi.spyOn(tanstackQuery, 'useQuery');
  render(<UserList />);
  expect(spy).toHaveBeenCalledWith({ queryKey: ['users'], ... });
});
// Breaks if we rename the query key or switch to a different hook
```

**Correct (tests what the user sees — resilient):**

```tsx
import { render, screen, waitFor } from '@testing-library/react';

test('displays list of users', async () => {
  render(<UserList />);

  // Wait for loading to finish and users to appear
  await waitFor(() => {
    expect(screen.getByText('Alice')).toBeInTheDocument();
    expect(screen.getByText('Bob')).toBeInTheDocument();
  });

  // Test user sees the right count
  expect(screen.getByText('2 users')).toBeInTheDocument();
});
// Survives: query key rename, switching fetch library, refactoring component tree
```

**Red flags that a test is implementation-coupled:**
- Mocking or spying on internal modules/functions
- Asserting on call counts or argument shapes of internal functions
- Querying the DOM by CSS class or test ID when a text label would work
- Test name describes HOW instead of WHAT

**Good test names describe user-facing behavior:**
- ✅ "shows error message when email is invalid"
- ✅ "adds item to cart and updates total"
- ❌ "calls validateEmail with form.email.value"
- ❌ "dispatches ADD_TO_CART action"

Reference: [/Users/best/.pi/agent/skills/tdd/references/tests.md](/Users/best/.pi/agent/skills/tdd/references/tests.md)
