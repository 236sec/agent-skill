---
name: react-best-practices
description: React and Next.js performance optimization, state management (Redux Toolkit), data fetching (TanStack Query), form handling (React Hook Form + Zod), and test-driven development guidelines. This skill should be used when writing, reviewing, or refactoring React/Next.js code to ensure optimal performance and testability. Triggers on tasks involving React components, Next.js pages, data fetching, forms, state management, bundle optimization, or performance improvements.
license: MIT
metadata:
  author: vercel
  version: "2.0.0"
---

# React Best Practices

Comprehensive performance and architecture guide for React and Next.js applications. Contains rules across 11 categories, prioritized by impact to guide automated refactoring and code generation. Includes TanStack Query for server state, Redux Toolkit for client state, React Hook Form + Zod for forms, and test-driven development throughout.

## Core Libraries

| Concern               | Library                                                          | Why                                                                           |
| --------------------- | ---------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Server State          | [TanStack Query](https://tanstack.com/query)                     | Caching, deduplication, background refetch, mutations with optimistic updates |
| Client State          | [Redux Toolkit](https://redux-toolkit.js.org/)                   | Centralized state, predictable updates, Redux DevTools, selectors             |
| Forms                 | [React Hook Form](https://react-hook-form.com/) + [Zod](https://zod.dev/) | Performant uncontrolled inputs, schema-based validation, type-safe            |
| Testing               | [Testing Library](https://testing-library.com/) + [Vitest](https://vitest.dev/) | Behavior-driven tests through public interfaces, not implementation details   |

## TDD Philosophy

**Core principle**: Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

- **Good tests** are integration-style: exercise real code paths through public APIs, describing _what_ the system does
- **Bad tests** mock internal collaborators, test private methods, or verify through external means
- **Mock at system boundaries only**: external APIs, time/randomness — never your own modules

Follow the TDD workflow: **Plan → Tracer Bullet (one test → one impl) → Incremental Loop → Refactor**. One test at a time, only enough code to pass. Never refactor while RED. See [TDD Skill](/Users/best/.pi/agent/skills/tdd/SKILL.md) for full methodology.

## When to Apply

Reference these guidelines when:

- Writing new React components or Next.js pages
- Implementing data fetching (client or server-side) with TanStack Query
- Building forms with React Hook Form and Zod validation
- Managing state with Redux Toolkit
- Writing tests (unit and integration)
- Reviewing code for performance issues
- Refactoring existing React/Next.js code
- Optimizing bundle size or load times

## Rule Categories by Priority

| Priority | Category                  | Impact      | Prefix       |
| -------- | ------------------------- | ----------- | ------------ |
| 1        | Eliminating Waterfalls    | CRITICAL    | `async-`     |
| 2        | Bundle Size Optimization  | CRITICAL    | `bundle-`    |
| 3        | Server-Side Performance   | HIGH        | `server-`    |
| 4        | Client-Side Data Fetching | MEDIUM-HIGH | `client-`    |
| 5        | Form Management           | MEDIUM-HIGH | `forms-`     |
| 6        | State Management          | MEDIUM-HIGH | `state-`     |
| 7        | Re-render Optimization    | MEDIUM      | `rerender-`  |
| 8        | Rendering Performance     | MEDIUM      | `rendering-` |
| 9        | JavaScript Performance    | LOW-MEDIUM  | `js-`        |
| 10       | Testability               | MEDIUM-HIGH | `testing-`   |
| 11       | Advanced Patterns         | LOW         | `advanced-`  |

## Quick Reference

### 1. Eliminating Waterfalls (CRITICAL)

- `async-cheap-condition-before-await` - Check cheap sync conditions before awaiting flags or remote values
- `async-defer-await` - Move await into branches where actually used
- `async-parallel` - Use Promise.all() for independent operations
- `async-dependencies` - Use better-all for partial dependencies
- `async-api-routes` - Start promises early, await late in API routes
- `async-suspense-boundaries` - Use Suspense to stream content

### 2. Bundle Size Optimization (CRITICAL)

- `bundle-barrel-imports` - Import directly, avoid barrel files
- `bundle-analyzable-paths` - Prefer statically analyzable import and file-system paths to avoid broad bundles and traces
- `bundle-dynamic-imports` - Use next/dynamic for heavy components
- `bundle-defer-third-party` - Load analytics/logging after hydration
- `bundle-conditional` - Load modules only when feature is activated
- `bundle-preload` - Preload on hover/focus for perceived speed

### 3. Server-Side Performance (HIGH)

- `server-auth-actions` - Authenticate server actions like API routes
- `server-cache-react` - Use React.cache() for per-request deduplication
- `server-cache-lru` - Use LRU cache for cross-request caching
- `server-dedup-props` - Avoid duplicate serialization in RSC props
- `server-hoist-static-io` - Hoist static I/O (fonts, logos) to module level
- `server-no-shared-module-state` - Avoid module-level mutable request state in RSC/SSR
- `server-serialization` - Minimize data passed to client components
- `server-parallel-fetching` - Restructure components to parallelize fetches
- `server-parallel-nested-fetching` - Chain nested fetches per item in Promise.all
- `server-after-nonblocking` - Use after() for non-blocking operations

### 4. Client-Side Data Fetching (MEDIUM-HIGH)

- `client-tanstack-query` - Use TanStack Query for caching, deduplication, and mutations
- `client-tanstack-query-keys` - Structure query keys for cache invalidation
- `client-tanstack-query-optimistic` - Use optimistic updates for instant UI feedback
- `client-event-listeners` - Deduplicate global event listeners
- `client-passive-event-listeners` - Use passive listeners for scroll
- `client-localstorage-schema` - Version and minimize localStorage data

### 5. Form Management (MEDIUM-HIGH)

- `forms-react-hook-form` - Use React Hook Form for performant uncontrolled forms
- `forms-zod-validation` - Define schemas with Zod, infer types for type safety
- `forms-zod-server-action` - Validate on both client and server with shared Zod schema
- `forms-accessible-errors` - Accessible error states and ARIA attributes

### 6. State Management (MEDIUM-HIGH)

- `state-redux-toolkit` - Use Redux Toolkit createSlice for reducer logic
- `state-redux-selectors` - Memoized selectors for derived state
- `state-redux-async-thunks` - Async thunks for API interactions, hydrated into TanStack Query cache
- `state-redux-scope` - Only Redux for truly global state; use component state otherwise

### 7. Re-render Optimization (MEDIUM)

- `rerender-defer-reads` - Don't subscribe to state only used in callbacks
- `rerender-memo` - Extract expensive work into memoized components
- `rerender-memo-with-default-value` - Hoist default non-primitive props
- `rerender-dependencies` - Use primitive dependencies in effects
- `rerender-derived-state` - Subscribe to derived booleans, not raw values
- `rerender-derived-state-no-effect` - Derive state during render, not effects
- `rerender-functional-setstate` - Use functional setState for stable callbacks
- `rerender-lazy-state-init` - Pass function to useState for expensive values
- `rerender-simple-expression-in-memo` - Avoid memo for simple primitives
- `rerender-split-combined-hooks` - Split hooks with independent dependencies
- `rerender-move-effect-to-event` - Put interaction logic in event handlers
- `rerender-transitions` - Use startTransition for non-urgent updates
- `rerender-use-deferred-value` - Defer expensive renders to keep input responsive
- `rerender-use-ref-transient-values` - Use refs for transient frequent values
- `rerender-no-inline-components` - Don't define components inside components

### 8. Rendering Performance (MEDIUM)

- `rendering-animate-svg-wrapper` - Animate div wrapper, not SVG element
- `rendering-content-visibility` - Use content-visibility for long lists
- `rendering-hoist-jsx` - Extract static JSX outside components
- `rendering-svg-precision` - Reduce SVG coordinate precision
- `rendering-hydration-no-flicker` - Use inline script for client-only data
- `rendering-hydration-suppress-warning` - Suppress expected mismatches
- `rendering-activity` - Use Activity component for show/hide
- `rendering-conditional-render` - Use ternary, not && for conditionals
- `rendering-usetransition-loading` - Prefer useTransition for loading state
- `rendering-resource-hints` - Use React DOM resource hints for preloading
- `rendering-script-defer-async` - Use defer or async on script tags

### 9. JavaScript Performance (LOW-MEDIUM)

- `js-batch-dom-css` - Group CSS changes via classes or cssText
- `js-index-maps` - Build Map for repeated lookups
- `js-cache-property-access` - Cache object properties in loops
- `js-cache-function-results` - Cache function results in module-level Map
- `js-cache-storage` - Cache localStorage/sessionStorage reads
- `js-combine-iterations` - Combine multiple filter/map into one loop
- `js-length-check-first` - Check array length before expensive comparison
- `js-early-exit` - Return early from functions
- `js-hoist-regexp` - Hoist RegExp creation outside loops
- `js-min-max-loop` - Use loop for min/max instead of sort
- `js-set-map-lookups` - Use Set/Map for O(1) lookups
- `js-tosorted-immutable` - Use toSorted() for immutability
- `js-flatmap-filter` - Use flatMap to map and filter in one pass
- `js-request-idle-callback` - Defer non-critical work to browser idle time

### 10. Testability (MEDIUM-HIGH)

- `testing-behavior-over-implementation` - Test what the user sees, not internal state
- `testing-mock-boundaries` - Mock only at system boundaries (APIs, time)
- `testing-redux-connected` - Test components connected to Redux through providers
- `testing-tanstack-query` - Test components that use queries with QueryClientProvider wrapper
- `testing-forms` - Test form submission and validation via user events

### 11. Advanced Patterns (LOW)

- `advanced-effect-event-deps` - Don't put `useEffectEvent` results in effect deps
- `advanced-event-handler-refs` - Store event handlers in refs
- `advanced-init-once` - Initialize app once per app load
- `advanced-use-latest` - useLatest for stable callback refs

## How to Use

Read individual rule files for detailed explanations and code examples:

```
rules/async-parallel.md
rules/bundle-barrel-imports.md
```

Each rule file contains:

- Brief explanation of why it matters
- Incorrect code example with explanation
- Correct code example with explanation
- Additional context and references

## Full Compiled Document

For the complete guide with all rules expanded: `AGENTS.md`
