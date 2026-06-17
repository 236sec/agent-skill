---
name: rust-axum-tdd
description: "Use when building or refactoring Rust Axum backends with a test-driven workflow, ports and adapters, layered architecture, domain-first design, handler validation, or repository-scoped backend best practices."
argument-hint: "Rust Axum backend task"
user-invocable: true
---

# Rust Axum TDD

## When to Use

- Building or refactoring Rust HTTP APIs with Axum
- Designing domain-first backends with use cases, traits, and adapters
- Working test-first on handlers, services, repositories, or external clients
- Keeping domain logic independent from Axum, SQL, or network concerns

## Core Principles

- Start with the smallest failing test that proves the desired behavior.
- Keep domain entities pure and free of Axum, database, and transport concerns.
- Put orchestration in application use cases and side effects in infrastructure adapters.
- Use Axum handlers only as thin request/response translators.
- Prefer explicit traits and `Arc<dyn Trait>` for dependency injection at runtime.
- Avoid `unwrap()` and `expect()` in production code; propagate errors and map them into `IntoResponse` types.
- Treat CPU-bound work as blocking work and move it off the Tokio runtime with `spawn_blocking`.

## Workflow

1. Restate the behavior in one sentence and identify the layer that should own it.
2. Write or update a failing test first.
3. If the behavior is pure business logic, test the domain module directly.
4. If the behavior coordinates collaborators, test the use case with mock trait implementations.
5. If the behavior is HTTP-facing, add a focused Axum handler test for status codes, payloads, and error mapping.
6. Implement the smallest code change that makes the test pass.
7. Refactor only after the passing test proves the slice works.
8. Run the narrowest useful validation first, then widen to formatting and linting.

## Layering Rules

### Domain Layer

- Model business entities as plain Rust structs and enums.
- Keep calculations and invariants inside methods on the domain type.
- Do not import Axum, SQLx, reqwest, or serde-heavy transport types into core business logic unless the type is truly part of the domain.

### Application Layer

- Define use cases as orchestration units.
- Define ports as traits for repositories, external APIs, queues, clocks, or other dependencies.
- Keep use cases deterministic except for their injected ports.
- Use mock implementations in tests to prove orchestration without real I/O.

### Infrastructure Layer

- Implement ports with concrete adapters for database, HTTP, storage, and messaging.
- Translate external data and failures at the boundary.
- Keep adapter-specific parsing, retries, and protocol details out of the use case.

### Presentation Layer

- Keep Axum handlers thin and explicit.
- Extract state with `State`, route params with `Path`, and request bodies with `Json`.
- Validate input at the boundary and return precise HTTP responses.
- Use a custom application error type that implements `IntoResponse`.

## Test-Driven Development Loop

1. Write the smallest failing test that captures the next behavior.
2. Make the test pass with the least invasive implementation.
3. Clean up the code while keeping the test green.
4. Add the next test only after the current slice is complete.

## What to Test First

- Pure calculations and business rules in the domain layer
- Use case orchestration with mocked ports
- Error mapping and response shapes in handlers
- Adapter translation logic at the boundary, not the remote service itself

## Completion Checks

- The new behavior is covered by at least one focused test.
- The domain layer still compiles without Axum or infrastructure imports.
- The handler returns the expected status code and JSON shape.
- `cargo fmt` passes.
- `cargo clippy -- -D warnings` passes.
- `cargo test` passes for the touched slice.

## Reference Architecture

- Domain: pure business objects and rules
- Application: use cases plus port traits
- Infrastructure: database, HTTP, and storage adapters
- Presentation: Axum routes and handlers

## Good Prompts For This Skill

- "Add a new Axum endpoint using TDD"
- "Refactor this Rust handler into domain, use case, and adapter layers"
- "Write tests first for a repository trait and use case"
- "Map this application error into an Axum response"

## Guardrails

- Do not let Axum types leak into the domain layer.
- Do not couple use cases to concrete infrastructure implementations.
- Do not add broad integration tests before the narrow unit test that defines the behavior.
- Do not expand the scope until the first slice is green.
