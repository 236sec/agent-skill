---
title: Scope Redux to Truly Global State
impact: MEDIUM-HIGH
impactDescription: reduces boilerplate, simplifies architecture
tags: state, redux, scope, architecture
---

## Scope Redux to Truly Global State

Not everything belongs in Redux. Use the right tool for each state category:

| State Type           | Tool                   | Examples                              |
| -------------------- | ---------------------- | ------------------------------------- |
| Server state         | TanStack Query         | Users, posts, products                |
| Global client state  | Redux Toolkit          | Auth session, theme, feature flags    |
| Form state           | React Hook Form        | Field values, validation errors       |
| Local UI state       | `useState`/`useReducer`| Modal open, dropdown open, tab index  |
| URL state            | Next.js router         | Search params, filters, current page  |

**Red flags that state shouldn't be in Redux:**
- Only one component reads it → `useState`
- It's derived from other state → selector or `useMemo`
- It resets on navigation → component state or URL
- It's form field values → React Hook Form

**Correct architecture:**

```tsx
// Redux: only things every part of the app might need
// store/index.ts
configureStore({
  reducer: {
    auth: authReducer,       // current user, token
    theme: themeReducer,     // dark/light mode
    featureFlags: flagsReducer, // beta features
  },
});

// TanStack Query: anything from the server
function useUsers() {
  return useQuery({ queryKey: ['users'], queryFn: fetchUsers });
}

// React Hook Form: form fields
const { register } = useForm();

// useState: local UI
const [isOpen, setIsOpen] = useState(false);
```

**Anti-pattern to avoid:**

```tsx
// DON'T put form input value in Redux
dispatch(setEmailField(e.target.value)); // WRONG
// DO use React Hook Form
<input {...register('email')} />; // RIGHT
```

Reference: [https://redux.js.org/usage/structuring-reducers/basic-reducer-structure](https://redux.js.org/usage/structuring-reducers/basic-reducer-structure)
