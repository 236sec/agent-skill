# Go Implementation

## Prerequisites

- Required skills tdd for understanding how to write tests first and implement the code to make them pass.
- Handler → UseCase → Repository → Database
- `src/models/`, `src/repo/`, `src/usecases/`, `src/rest/handlers/`, `src/di/`, `src/rest/routes.go` for only the relevant entity and layer that you want to implement.
- `database.IDatabase` with `Create/Find/First/Update`
- `make gen-mock` for mock regeneration

## Implementation Flow

### Phase 1: Understand the Contract

- HTTP method + path
- Request/response fields
- Error cases (404, 400, 500)
- Special behavior (partial updates, sorting, toggles)

### Phase 2: Infer Patterns from One Existing Slice

Read **one** complete existing slice end-to-end. Recommended files:

| Layer      | File to read                                               | Infer                                           |
| ---------- | ---------------------------------------------------------- | ----------------------------------------------- |
| Model      | `src/models/{entity}.model.go`                             | DB schema, JSON tags                            |
| Repository | `src/repo/{entity}.repo.go`                                | Interface, method signatures, `database.Filter` |
| Database   | `src/pkg/database/interface.go`                            | Available primitives                            |
| Use Case   | `src/usecases/{entity}/{action}-{entity}.use-case.go`      | Tracer, error wrapping, repo call pattern       |
| Test       | `src/usecases/{entity}/{action}-{entity}.use-case_test.go` | `gomock` setup, table-driven cases              |
| Handler    | `src/rest/handlers/{entity}/{action}-{entity}.handler.go`  | `ValidateStruct`, response mapping              |
| Routes     | `src/rest/routes.go`                                       | Registration pattern                            |
| DI         | `src/di/usecase.di.go`                                     | `sync.OnceValue` wiring                         |
| Shared     | `src/usecases/error.go` + `src/rest/response/response.go`  | Reusable errors/responses                       |

> Rule: Read only files that are relevant to your task that you need to implement.

### Phase 3: Extend Infrastructure (only if needed)

Does the feature need a DB operation **not in `database.IDatabase`**?

- **Yes** → Add to `interface.go`, implement in `gorm.go` + `mongodb.go`, then `make gen-mock`.
- **No** → Skip.

### Phase 4: Write Use-Case Test First (TDD)

Create `src/usecases/{entity}/{action}-{entity}.use-case_test.go`.
Copy an existing test file. Change only:

- Request/response structs
- Mock method names
- Expected data

**Mandatory test cases:**

1. Not found → mapped error (e.g., `ErrTaskNotFound`)
2. Repo error → mapped error (e.g., `ErrInternalServerError`)
3. Happy path → correct data

Run `go test ./src/usecases/{entity}/...` → expect **FAIL** (red).

### Phase 5: Implement Use Case + DTOs

Create:

- `src/usecases/{entity}/{action}-{entity}.dto.go`
- `src/usecases/{entity}/{action}-{entity}.use-case.go`

Follow existing slice exactly:

- `otel.Tracer(...)` if used
- Wrap errors with constants from `src/usecases/error.go`
- Return empty response struct on error

Run tests → expect **PASS** (green).

### Phase 6: Implement Handler

Create `src/rest/handlers/{entity}/{action}-{entity}.handler.go`.
Copy existing handler. Change only:

- Request/response types
- Use case interface
- Error → response mapping

For create/update, set status code explicitly (e.g., `res.HttpStatus = 201`).

### Phase 7: Wire DI and Routes

1. `src/di/usecase.di.go` → Add `Get{Action}{Entity}UseCase` via `sync.OnceValue`.
2. `src/rest/routes.go` → Register new handler on path.

### Phase 8: Add OpenAPI Docs (if docs exist)

1. Add new schemas to `docs/openapi.yaml` only if shape is new.
2. Create `docs/paths/{entity}/{action}-{entity}.yaml`.
3. Reference it in the paths aggregator (e.g., `docs/paths/{entity}/tasks.yaml`).

### Phase 9: Verify

```bash
make test        # all pass
make build       # compiles cleanly
```

## Guardrails

- Do not `ls` every directory. Read the 8 representative files above.
- Do not read or edit mock files directly. Use `make gen-mock`.
- Do not invent new error types. Reuse from `src/usecases/error.go`.
- Do not invent new response shapes. Reuse from `src/rest/response/response.go`.
- Check `Makefile` before writing new CLI commands.
- Always treat the current workspace as the source of truth.
