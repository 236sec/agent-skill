---
name: golang-core-orientation
description: "Use when you need to quickly understand a Go codebase, its essential architecture, and the current clean-architecture flow."
---

# Go Core Orientation

Use this skill when the goal is to understand the essential shape of a Go repository fast, not to document everything.

- The request flow: transport or handler -> use case -> repository -> database or external service.
- The core boundaries: domain, usecases, repositories, handlers, models, config, shared pkg helpers.
- The current infrastructure wiring: dependency injection, database, cache, telemetry, validation, middleware, routes.
- For implementation details, see the [Go Core Implementation](references/implementation.md) skill.

## 📂 Directory Structure

Familiarize yourself with the customary Go project structure, which often includes directories like `cmd/`, `pkg/`, `internal/`, `configs/`, and `docs/`. Each of these serves a specific purpose in organizing the codebase effectively.

```text
cmd/                    # Application entrypoints (e.g., server, CLI)
config/                 # Configuration files and environment variable management
docs/                   # Documentation and design notes
├── openapi.yaml         # OpenAPI specification for our API
├── paths/                # API path documentation
src/
├── di/                  # Dependency Injection setup
├── domain/               # Core Business Logic
├── migrations/           # Database migration files
├── models/               # Data models and schema definitions
├── repo/                 # Repository interfaces and implementations
│   ├── mocks/            # Mock implementations for testing that generate by `make gen-mock`
├── pkg/                  # Shared packages and utilities
│   ├── database/         # Database connection and helpers
│   ├── utils/            # General utility functions
├── usecases/             # Application Use Cases
│   ├── [action]-[entity].dto.go  # DTOs for use cases
│   ├── [action]-[entity].go      # Use case implementations
│   ├── errors.go              # Use case specific errors use for error wrapping and mapping to handler responses
├── rest/                 # REST API Handlers
│   ├── handlers/          # HTTP handlers for each endpoint
│   │ ├── [entity]/            # Handlers grouped by entity
│   │ │   ├── [action]-[entity].handler.go   # Handler for a specific action (e.g., create, update)
│   │ └── validator.common.go  # Common validation logic for handlers
│   ├── response/         # Response struct definitions
│   ├── middleware.go        # HTTP middleware (e.g., auth, logging)
│   └── routes.go          # Route definitions and wiring
├── Makefile                # Build and utility commands (e.g., gen-mock, run, test, lint, migrate)
```

## Guardrails

- Follow test-driven development you can see [testing](references/testing.md) for how to write tests.
- Do not invent layers that are not in the code.
- Do not able to read or edit mocks files in `src/repo/mocks/` since they are generated and not the source of truth with `make gen-mock`.
- Do not produce a full codebase audit unless explicitly asked.
- Always treat the current workspace as the source of truth.
