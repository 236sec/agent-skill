---
name: "openapi"
description: "Use when creating or updating OpenAPI specifications (Swagger documentation). Enforces separate path files, common components in openapi.yaml, matching DTOs, and handler status code mappings."
---

# OpenAPI Documentation Guidelines

When creating, updating, or reviewing OpenAPI/Swagger documentation, you must adhere to the following rules:

## 1. Path Separation and Directory Structure (The "Product" Pattern)

When building OpenAPI docs, you must strictly follow the two-level referencing pattern observed in the `product` domain.

**A. Directory Structure:**
Always create a dedicated directory for the feature under `docs/paths/` (e.g., `docs/paths/product/`). All route and method-specific YAML files for that feature must reside here.

**B. Main OpenAPI Entrypoint (`docs/openapi.yaml`):**
Do not define paths or methods directly in the root `openapi.yaml`. Instead, define the URL path and reference a specific anchor in a feature-grouping file.

```yaml
paths:
  /products:
    $ref: "./paths/product/products.yaml#/products"
  /products/{id}:
    $ref: "./paths/product/products.yaml#/products_id"
```

**C. Feature Grouping File (e.g., `docs/paths/product/products.yaml`):**
Create a central file for the feature that acts as a router. Define anchors for each specific route, and within those anchors, map the HTTP methods (`get`, `post`, `patch`, `delete`) to individual method files.

```yaml
products:
  get:
    $ref: "./list-products.yaml"
  post:
    $ref: "./post-product.yaml"
products_id:
  patch:
    $ref: "./patch-product.yaml"
  delete:
    $ref: "./delete-product.yaml"
```

**D. Individual Method Files:**
Create a separate, narrowly focused YAML file for each specific HTTP method on a path.

- **Naming Convention:** Use `<action>-<feature>.yaml` (e.g., `list-products.yaml`, `post-product.yaml`, `reserve-products.yaml`).
- Inside this file, only define the immediate details of that operation (`tags`, `summary`, `responses`, `requestBody`). Do not nest it under the HTTP method key.

## 2. Common vs Path-Specific Definitions

- **Path-Specific Definitions:** If a request or response object is only used by a single specific path, define it locally within that path's file (e.g., as an inline `schema`). Do not clutter `openapi.yaml` with path-specific schemas.
- **Centralize Shared Components:** Define all common, reusable schemas (like `BaseResponse` or `ErrorResponse`), parameters, and security schemes in the main `openapi.yaml` under `components`.
- **Reference Shared Components:** Reference these common components from your individual path files (e.g., `$ref: '../openapi.yaml#/components/schemas/ErrorResponse'`).

## 3. Request/Response DTO Validation

- **Match Code:** Ensure the request body and response schemas in the OpenAPI documentation exactly match the Data Transfer Objects (DTOs) defined in the application code (e.g., `src/usecases/<feature>/<action>-<feature>.dto.go` or `src/rest/response/response.go`).
- **Review:** Always verify the fields, data types, and required properties against the corresponding Go structs found in those directories.

## 4. Handler Status Code Mapping

- **Accurate Status Codes:** Documented HTTP status codes for a path must accurately reflect the potential responses returned by the corresponding handler in the code.
- **Review:** Cross-reference the documented responses with the handler implementations located in `src/rest/handlers/` or `src/rest/response/response.go` to ensure all success and error scenarios (e.g., 200, 201, 400, 401, 500) are explicitly defined.
