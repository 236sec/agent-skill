---
name: fastapi
description: "Use when implementing a FastAPI codebase, to understand the essential architecture."
---

# FastAPI

## Project Structure

```text
├── app                  # "app" is a Python package
│   ├── __init__.py      # this file makes "app" a "Python package"
│   ├── main.py          # "main" module, e.g. import app.main
│   ├── dependencies.py  # "dependencies" module, e.g. import app.dependencies
│   └── routers          # "routers" is a "Python subpackage"
│   │   ├── __init__.py  # makes "routers" a "Python subpackage"
│   │   ├── items.py     # "items" submodule, e.g. import app.routers.items
│   │   └── users.py     # "users" submodule, e.g. import app.routers.users
│   └── internal         # "internal" is a "Python subpackage"
│       ├── __init__.py  # makes "internal" a "Python subpackage"
│       └── admin.py     # "admin" submodule, e.g. import app.internal.admin
```

## References

- [main.py](references/main.md)
- [dependencies.py](references/dependencies.md)

## Dependency Injection

- FastAPI uses "dependency injection" to manage dependencies between components.
- Dependencies are defined as "callable" functions that can be injected into route handlers or other dependencies.

## Essential

- You must write a code that is testable and maintainable, so you should follow the best practices of FastAPI and Python development.
- You should use "dependency injection" to manage dependencies between components, and you should define dependencies as "callable" functions that can be injected into route handlers or other dependencies.
- You should follow the project structure and organization as shown in the references, and you should not deviate from it unless there is a good reason to do so.

## Guardrails

- Follow practice test-driven development you can see [testing](../tdd/SKILL.md) for how to write tests.
