# pm-proto

Shared Protobuf contract library for the `pm` microservices project. It holds the `.proto` definitions and the Go generated code (gRPC + grpc-gateway) that downstream services import.

Go module: `github.com/pav-dev98/pm-proto`

## Installation

```bash
go get github.com/pav-dev98/pm-proto
```

Import the package you need:

```go
import authpb "github.com/pav-dev98/pm-proto/auth"
```

## Packages

| Package      | Status         | Description                                         |
|--------------|----------------|-----------------------------------------------------|
| `auth/`      | Generated      | `AuthService` — `Login`, `Register`, `Refresh`      |
| `products/`  | Proto only     | Placeholder, code not yet generated                 |
| `users/`     | Placeholder    | Not yet defined                                     |

### HTTP routes

Exposed via grpc-gateway:

| Method | Path                  | RPC                       |
|--------|-----------------------|---------------------------|
| POST   | `/v1/auth/login`      | `AuthService.Login`       |
| POST   | `/v1/auth/register`   | `AuthService.Register`    |
| POST   | `/v1/auth/refresh`    | `AuthService.Refresh`     |

## Code generation

All generation is driven by `make`:

```bash
make proto    # regenerate all packages listed in PACKAGES
make clean    # remove generated *.pb.go and *.pb.gw.go files
```

Each package produces three files:

- `*.pb.go` — message types
- `*_grpc.pb.go` — gRPC client and server stubs
- `*.pb.gw.go` — grpc-gateway HTTP/JSON handlers

### Required tools

All must be on `$PATH`:

- `protoc` v6+
- `protoc-gen-go` v1.36+
- `protoc-gen-go-grpc` v1.6+
- `protoc-gen-grpc-gateway` (from `github.com/grpc-ecosystem/grpc-gateway/v2`)

## Adding a new service domain

1. Create a directory named after the domain (e.g. `orders/`).
2. Add `orders/orders.proto` with `option go_package = "github.com/pav-dev98/pm-proto/orders";`.
3. Append the package name to `PACKAGES` in the `Makefile`.
4. Run `make proto`.

## HTTP annotations

Every RPC that should be exposed over HTTP must declare a `google.api.http` option:

```protobuf
import "google/api/annotations.proto";

rpc MyMethod(MyRequest) returns (MyResponse) {
  option (google.api.http) = {
    post: "/v1/my-service/my-method"
    body: "*"
  };
}
```

The `google/api` protos required at compile time live in `third_party/googleapis/` and are passed to `protoc` via `-I`.

## Conventions

- One service per `.proto` file; name the file after the service domain.
- `option go_package` must follow the pattern `github.com/pav-dev98/pm-proto/<package>`.
- Never edit `*.pb.go`, `*_grpc.pb.go`, or `*.pb.gw.go` by hand — they are fully generated.

## Project layout

```
.
├── auth/                       # AuthService proto + generated code
├── products/                   # placeholder
├── users/                      # placeholder
├── third_party/googleapis/     # google/api protos for protoc -I
├── Makefile                    # proto generation entry point
└── go.mod
```

## Development

```bash
go mod tidy     # sync dependencies
go build ./...  # verify generated code compiles
```
