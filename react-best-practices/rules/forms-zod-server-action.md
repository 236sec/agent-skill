---
title: Validate on Both Client and Server with Shared Zod Schema
impact: MEDIUM-HIGH
impactDescription: security, UX, no duplication
tags: forms, zod, server-actions, validation, security
---

## Validate on Both Client and Server

Client-side validation is a UX convenience; server-side validation is a security requirement. Share a single Zod schema between client and server to prevent drift and ensure consistent error messages.

**Incorrect (separate validations, drifting):**

```tsx
// client: react-hook-form with inline rules
// server: manual if-else checks
// These WILL diverge over time — security holes or false rejections
```

**Correct (shared Zod schema, used everywhere):**

```tsx
// lib/validations.ts — single source of truth
import { z } from 'zod';

export const CreatePostSchema = z.object({
  title: z.string().min(3).max(100),
  content: z.string().min(10),
  published: z.boolean().default(false),
});

export type CreatePostData = z.infer<typeof CreatePostSchema>;
```

```tsx
// client — React Hook Form uses the schema
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { CreatePostSchema, type CreatePostData } from '@/lib/validations';

function PostForm() {
  const form = useForm<CreatePostData>({
    resolver: zodResolver(CreatePostSchema),
  });
  // ...
}
```

```tsx
// server — Server Action validates with same schema
'use server'

import { CreatePostSchema } from '@/lib/validations';

export async function createPost(formData: FormData) {
  const data = CreatePostSchema.parse({
    title: formData.get('title'),
    content: formData.get('content'),
    published: formData.get('published') === 'true',
  });

  // data is fully typed and validated — no surprises
  await db.post.create({ data });
}
```

**Benefits:**
- One schema to maintain, one set of error messages
- Server catches anything that bypassed client validation (curl, malicious clients)
- TypeScript types flow from schema to handler automatically

Reference: [https://zod.dev/?id=server-side](https://zod.dev/?id=server-side)
