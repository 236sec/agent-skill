---
title: Define Validation Schemas with Zod
impact: MEDIUM-HIGH
impactDescription: type-safe, single source of truth
tags: forms, zod, validation, type-inference
---

## Define Validation Schemas with Zod

Zod schemas are the single source of truth for both runtime validation and TypeScript types. Use `z.infer<typeof schema>` to derive types, eliminating duplication between validation code and type definitions.

**Incorrect (types and validation out of sync):**

```tsx
// Type defined separately from validation
interface SignupData {
  email: string;
  password: string;
  age?: number;
}

function validate(data: unknown): SignupData {
  // Manual validation — easily drifts from interface
  if (typeof data.email !== 'string') throw new Error('...');
  // ...
}
```

**Correct (schema IS the type):**

```tsx
import { z } from 'zod';

const SignupSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Must be at least 8 characters'),
  age: z.number().min(13).optional(),
});

// Type inferred from schema — always in sync
type SignupData = z.infer<typeof SignupSchema>;

// Runtime validation
function validate(data: unknown): SignupData {
  return SignupSchema.parse(data); // throws ZodError with structured messages
}

// Safe parse without throwing
const result = SignupSchema.safeParse(data);
if (!result.success) {
  console.log(result.error.flatten());
}
```

**Common Zod patterns:**
- `.refine()` for cross-field validation (e.g., password === confirmPassword)
- `.transform()` to coerce types (e.g., string → Date)
- `.default()` for optional fields with fallback values
- `.brand()` for nominal typing (e.g., `UserId` vs `string`)

Reference: [https://zod.dev](https://zod.dev)
