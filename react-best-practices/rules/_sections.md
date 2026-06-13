# Sections

This file defines all sections, their ordering, impact levels, and descriptions.
The section ID (in parentheses) is the filename prefix used to group rules.

---

## 1. Eliminating Waterfalls (async)

**Impact:** CRITICAL  
**Description:** Waterfalls are the #1 performance killer. Each sequential await adds full network latency. Eliminating them yields the largest gains.

## 2. Bundle Size Optimization (bundle)

**Impact:** CRITICAL  
**Description:** Reducing initial bundle size improves Time to Interactive and Largest Contentful Paint.

## 3. Server-Side Performance (server)

**Impact:** HIGH  
**Description:** Optimizing server-side rendering and data fetching eliminates server-side waterfalls and reduces response times.

## 4. Client-Side Data Fetching (client)

**Impact:** MEDIUM-HIGH  
**Description:** TanStack Query provides caching, deduplication, background refetching, and optimistic mutations. Replaces manual fetch/useEffect patterns.

## 5. Form Management (forms)

**Impact:** MEDIUM-HIGH  
**Description:** React Hook Form delivers performant uncontrolled forms. Zod provides type-safe schema validation on both client and server, with inferred TypeScript types eliminating duplication.

## 6. State Management (state)

**Impact:** MEDIUM-HIGH  
**Description:** Redux Toolkit for truly global state (auth, theme, feature flags). Use component state or TanStack Query for everything else. Memoized selectors prevent wasted re-renders.

## 7. Re-render Optimization (rerender)

**Impact:** MEDIUM  
**Description:** Reducing unnecessary re-renders minimizes wasted computation and improves UI responsiveness.

## 8. Rendering Performance (rendering)

**Impact:** MEDIUM  
**Description:** Optimizing the rendering process reduces the work the browser needs to do.

## 9. JavaScript Performance (js)

**Impact:** LOW-MEDIUM  
**Description:** Micro-optimizations for hot paths can add up to meaningful improvements.

## 10. Testability (testing)

**Impact:** MEDIUM-HIGH  
**Description:** Behavior-driven tests through public interfaces ensure tests survive refactors. Mock only at system boundaries. Test components wrapped in providers (Redux Provider, QueryClientProvider) using Testing Library.

## 11. Advanced Patterns (advanced)

**Impact:** LOW  
**Description:** Advanced patterns for specific cases that require careful implementation.
