---
title: Test Form Submission and Validation via User Events
impact: MEDIUM-HIGH
impactDescription: real validation flow
tags: testing, forms, react-hook-form, user-event
---

## Test Forms via User Events

Test forms by simulating real user interactions: type into fields, click submit, observe error messages or success outcomes. Don't call form methods directly or assert on internal form state.

**Incorrect (bypasses the real form flow):**

```tsx
test('shows error for invalid email', () => {
  const { result } = renderHook(() => useForm());
  // Trigger validation programmatically — not how users interact
  act(() => {
    result.current.setError('email', { message: 'Invalid email' });
  });
  // ...
});
```

**Correct (simulates real user behavior):**

```tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

test('shows error when email is invalid', async () => {
  render(<SignupForm />);

  // User types an invalid email
  await userEvent.type(screen.getByLabelText(/email/i), 'not-an-email');

  // User submits
  await userEvent.click(screen.getByRole('button', { name: /sign up/i }));

  // User sees validation error
  expect(screen.getByText(/invalid email/i)).toBeInTheDocument();
});

test('submits form with valid data', async () => {
  const onSubmit = vi.fn();
  render(<SignupForm onSubmit={onSubmit} />);

  // User fills form correctly
  await userEvent.type(screen.getByLabelText(/email/i), 'alice@example.com');
  await userEvent.type(screen.getByLabelText(/password/i), 'password123');

  // User submits
  await userEvent.click(screen.getByRole('button', { name: /sign up/i }));

  // Form submitted with correct data
  await waitFor(() => {
    expect(onSubmit).toHaveBeenCalledWith({
      email: 'alice@example.com',
      password: 'password123',
    });
  });
});

test('shows server error on duplicate email', async () => {
  // MSW returns 409 conflict
  server.use(
    http.post('/api/signup', () =>
      HttpResponse.json({ error: 'Email already taken' }, { status: 409 })
    )
  );

  render(<SignupForm />);
  await userEvent.type(screen.getByLabelText(/email/i), 'taken@example.com');
  await userEvent.type(screen.getByLabelText(/password/i), 'password123');
  await userEvent.click(screen.getByRole('button', { name: /sign up/i }));

  expect(await screen.findByText(/email already taken/i)).toBeInTheDocument();
});
```

**Testing form accessibility:**

```tsx
test('error messages have correct ARIA attributes', async () => {
  render(<SignupForm />);
  await userEvent.click(screen.getByRole('button', { name: /sign up/i }));

  const emailInput = screen.getByLabelText(/email/i);
  expect(emailInput).toHaveAttribute('aria-invalid', 'true');

  const errorMessage = screen.getByRole('alert');
  expect(emailInput).toHaveAttribute('aria-describedby', errorMessage.id);
});
```

Reference: [https://testing-library.com/docs/user-event/intro](https://testing-library.com/docs/user-event/intro)
