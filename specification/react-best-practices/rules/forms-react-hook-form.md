---
title: Use React Hook Form for Performant Uncontrolled Forms
impact: MEDIUM-HIGH
impactDescription: avoids re-renders per keystroke
tags: forms, react-hook-form, uncontrolled, performance
---

## Use React Hook Form for Performant Forms

React Hook Form uses uncontrolled inputs with refs, avoiding re-renders on every keystroke. Paired with Zod for validation, it provides a type-safe, performant form experience.

**Incorrect (controlled inputs re-render on every keystroke):**

```tsx
function SignupForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState({});

  const handleSubmit = (e) => {
    e.preventDefault();
    // Manual validation...
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={email} onChange={e => setEmail(e.target.value)} />
      <input value={password} onChange={e => setPassword(e.target.value)} />
    </form>
  );
}
```

**Correct (uncontrolled, no per-keystroke re-renders):**

```tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
});

type FormData = z.infer<typeof schema>;

function SignupForm() {
  const { register, handleSubmit, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
  });

  const onSubmit = (data: FormData) => {
    // data is fully typed and validated
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}

      <input type="password" {...register('password')} />
      {errors.password && <span>{errors.password.message}</span>}

      <button type="submit">Sign Up</button>
    </form>
  );
}
```

**Key patterns:**
- `register()` spreads ref/onChange/onBlur onto native inputs — no useState needed
- `formState.errors` auto-populates from Zod schema validation
- `handleSubmit` only fires if validation passes
- `watch()` for fields you need to subscribe to (use sparingly)

Reference: [https://react-hook-form.com](https://react-hook-form.com)
