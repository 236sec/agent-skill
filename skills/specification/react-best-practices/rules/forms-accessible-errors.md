---
title: Accessible Error States and ARIA Attributes
impact: MEDIUM-HIGH
impactDescription: screen reader compatibility
tags: forms, accessibility, aria, error-states
---

## Accessible Error States

Form errors must be announced to screen readers and associated with their inputs via ARIA attributes. React Hook Form integrates with these attributes automatically.

**Incorrect (errors visually shown but invisible to screen readers):**

```tsx
<input {...register('email')} />
{errors.email && <span className="error">{errors.email.message}</span>}
// Screen reader cannot associate error with input
```

**Correct (ARIA-linked errors with live region):**

```tsx
<input
  {...register('email')}
  aria-invalid={errors.email ? 'true' : 'false'}
  aria-describedby={errors.email ? 'email-error' : undefined}
/>
{errors.email && (
  <span id="email-error" role="alert">
    {errors.email.message}
  </span>
)}
```

**Full accessible form pattern with React Hook Form:**

```tsx
function AccessibleForm() {
  const { register, handleSubmit, formState: { errors } } = useForm();

  return (
    <form onSubmit={handleSubmit(onSubmit)} noValidate>
      <div>
        <label htmlFor="email">Email</label>
        <input
          id="email"
          type="email"
          {...register('email', { required: 'Email is required' })}
          aria-invalid={errors.email ? 'true' : 'false'}
          aria-describedby={errors.email ? 'email-error' : undefined}
        />
        {errors.email && (
          <span id="email-error" role="alert" className="error">
            {errors.email.message}
          </span>
        )}
      </div>
      <button type="submit">Submit</button>
    </form>
  );
}
```

**Key accessibility attributes:**
- `aria-invalid` — tells screen readers the field is in error state
- `aria-describedby` — links error message to the input
- `role="alert"` — announces error immediately without moving focus
- `<label htmlFor>` — associates label with input (click on label focuses input)
- `noValidate` on `<form>` — disables browser's built-in validation popups

Reference: [https://www.w3.org/WAI/tutorials/forms/notifications/](https://www.w3.org/WAI/tutorials/forms/notifications/)
