---
title: Use Redux Toolkit createSlice for Reducer Logic
impact: MEDIUM-HIGH
impactDescription: predictable state, DevTools, concise reducers
tags: state, redux, createSlice, immer
---

## Use Redux Toolkit createSlice

Redux Toolkit's `createSlice` uses Immer internally, allowing "mutating" syntax that produces immutable updates. It auto-generates action creators and reducer cases from one definition.

**Incorrect (hand-written Redux with immutable spreads):**

```ts
// action types
const ADD_TODO = 'ADD_TODO';
const TOGGLE_TODO = 'TOGGLE_TODO';

// action creators
function addTodo(text) { return { type: ADD_TODO, payload: text }; }
function toggleTodo(id) { return { type: TOGGLE_TODO, payload: id }; }

// reducer (verbose immutable updates)
function todosReducer(state = [], action) {
  switch (action.type) {
    case ADD_TODO:
      return [...state, { id: Date.now(), text: action.payload, done: false }];
    case TOGGLE_TODO:
      return state.map(todo =>
        todo.id === action.payload ? { ...todo, done: !todo.done } : todo
      );
    default:
      return state;
  }
}
```

**Correct (createSlice with Immer):**

```ts
import { createSlice, type PayloadAction } from '@reduxjs/toolkit';

interface Todo { id: number; text: string; done: boolean; }

const todosSlice = createSlice({
  name: 'todos',
  initialState: [] as Todo[],
  reducers: {
    addTodo(state, action: PayloadAction<string>) {
      state.push({ id: Date.now(), text: action.payload, done: false });
    },
    toggleTodo(state, action: PayloadAction<number>) {
      const todo = state.find(t => t.id === action.payload);
      if (todo) todo.done = !todo.done;
    },
  },
});

export const { addTodo, toggleTodo } = todosSlice.actions;
export default todosSlice.reducer;
```

**Store setup:**

```ts
import { configureStore } from '@reduxjs/toolkit';
import todosReducer from './todosSlice';

export const store = configureStore({
  reducer: {
    todos: todosReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
```

Reference: [https://redux-toolkit.js.org/api/createSlice](https://redux-toolkit.js.org/api/createSlice)
