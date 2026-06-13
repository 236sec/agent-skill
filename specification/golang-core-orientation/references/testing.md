# Golang Test Writing

Use this skill when writing tests for Go usecases and domain behavior in this codebase.

## Goal

Produce tests that are clear, table-driven, and focused on behavior. Match the style used in the existing usecase and domain tests:

- table-driven cases
- explicit branch coverage
- `gomock` for repository dependencies
- `testify/assert` for readable expectations
- narrow arrange/act/assert flow

## Workflow

1. Identify the unit under test.
2. Decide whether it is a usecase test or a domain test.
3. List the observable branches.
4. Turn each branch into a table case.
5. Keep each case narrow and behavior-focused.
6. Check that the test proves the branch without unnecessary setup.

## Usecase Test Pattern

Use this pattern when the target orchestrates repositories, services, or other dependencies.

### Structure

- Define a case struct with fields like:
  - `name`
  - `request`
  - `mockSetup`
  - `expectedError`
  - `expectedResult`
- Create the controller with `gomock.NewController(t)`.
- Build the mock dependency from the controller.
- Register expectations inside `mockSetup`.
- Instantiate the usecase with the mock.
- Call `Apply` or the method under test with `context.Background()` unless the context matters.
- Assert the error and result.

### Branching Rules

- If a lookup fails unexpectedly, expect the usecase to stop early and skip later dependency calls.
- If a record is not found, assert the create or fallback path is taken.
- If the dependency returns a hard error, assert the usecase maps it to the correct application error.
- If the happy path creates or updates data, assert the returned response reflects the created or updated model.

### Assertion Rules

- Use `assert.ErrorIs` for wrapped or mapped errors.
- Use `assert.Equal` for response objects and scalar outputs.
- Verify important call counts with `Times(1)` or `Times(0)` when control flow matters.
- Avoid mocking branches that the case does not need.

### Example Shape

- query failure -> returns internal error, no create call
- not found -> create call happens once, response contains created ID

## Domain Test Pattern

Use this pattern when testing pure domain behavior without external dependencies.

### Structure

- Use a table of cases with fields like:
  - `name`
  - input fields
  - `expected`
- Construct the domain struct directly.
- Call the method under test.
- Assert only the visible output.

### Branching Rules

- Test each branch of boolean methods separately.
- For string formatting methods, cover normal and empty-input variants.
- Prefer direct field setup over fixtures unless many tests share the same setup.

### Assertion Rules

- Use `assert.Equal` for strings and booleans.
- Keep the test focused on the returned value.
- Do not add mocks or repository setup in domain tests.

## Quality Checklist

Before finishing a test, check that it:

- reads like behavior, not implementation noise
- has one clear reason for each table case
- covers both happy path and failure or edge branches when they exist
- uses the smallest possible mock setup
- avoids duplicated arrange code where a helper would improve clarity
- matches the repository's naming and style

## Completion Check

A good test produced by this skill should answer these questions:

- What behavior is being verified?
- Which branch is expected in each case?
- What dependency calls must happen, and which must not happen?
- What is the smallest assertion that proves the behavior?

## Before Run Testing

- Run the mock generation with `make gen-mock` to generate the necessary mock files ex. repo mocks.
