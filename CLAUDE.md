# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`pm-proto` is the shared Protobuf contract library for a microservices project. It holds `.proto` definitions and the Go generated code that downstream services import. The Go module is `github.com/pav-dev98/pm-proto`.

Services import the generated packages directly, e.g.:

```go
import authpb "github.com/pav-dev98/pm-proto/auth"
```

## Code generation

All generation is driven by `make proto`. Each package in `PACKAGES` inside the `Makefile` gets three output files: `*.pb.go`, `*_grpc.pb.go`, and `*.pb.gw.go` (grpc-gateway HTTP handler).

```bash
make proto   # regenerate all packages
```

To add a new service domain: create the directory and `.proto` file, then add the package name to `PACKAGES` in the `Makefile`.

**Tools required** (all must be on `$PATH`):
- `protoc` v6+
- `protoc-gen-go` v1.36+
- `protoc-gen-go-grpc` v1.6+
- `protoc-gen-grpc-gateway` (from `github.com/grpc-ecosystem/grpc-gateway/v2`)

## HTTP annotations

`google/api/annotations.proto` and `http.proto` live in `third_party/googleapis/` and are passed to `protoc` via `-I`. Every RPC that should be exposed over HTTP must declare a `google.api.http` option:

```protobuf
import "google/api/annotations.proto";

rpc MyMethod(MyRequest) returns (MyResponse) {
  option (google.api.http) = {
    post: "/v1/my-service/my-method"
    body: "*"
  };
}
```

Current HTTP routes:
- `POST /v1/auth/login` → `AuthService.Login`
- `POST /v1/auth/register` → `AuthService.Register`

## Structure

Each service domain gets its own directory and Go package:

- `auth/` — `AuthService` (Login, Register); full generated code present
- `products/` — placeholder, not yet generated
- `users/` — placeholder, not yet generated
- `third_party/googleapis/` — `google/api` protos needed at compile time (not imported by Go code)

## Go module

```bash
go mod tidy    # sync dependencies
go build ./... # verify generated code compiles
```

## Conventions

- `option go_package` in every `.proto` must follow the pattern `github.com/pav-dev98/pm-proto/<package>`.
- Never edit `*.pb.go`, `*_grpc.pb.go`, or `*.pb.gw.go` manually — they are fully generated.
- Keep one service per `.proto` file; name the file after the service domain.
