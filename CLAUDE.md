# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`pm-proto` is the shared Protobuf contract library for a microservices project. It holds `.proto` definitions and the Go generated code that downstream services import. The Go module is `github.com/pav-dev98/pm-proto`.

## Code generation

Generated files (`*.pb.go`, `*_grpc.pb.go`) live alongside each `.proto` file in the same package directory. Regenerate after editing a `.proto`:

```bash
protoc --go_out=. --go_opt=paths=source_relative \
       --go-grpc_out=. --go-grpc_opt=paths=source_relative \
       <package>/<file>.proto
```

Tools required: `protoc` (v6+), `protoc-gen-go` (v1.36+), `protoc-gen-go-grpc` (v1.6+).

## Structure

Each service domain gets its own directory and Go package:

- `auth/` — `AuthService` (Login, Register); generated Go code already present
- `products/` — placeholder, not yet generated
- `users/` — placeholder, not yet generated

## Go module

```bash
go mod tidy   # sync dependencies
go build ./... # verify generated code compiles
```

## Conventions

- `option go_package` in every `.proto` must follow the pattern `github.com/pav-dev98/pm-proto/<package>`.
- Never edit `*.pb.go` or `*_grpc.pb.go` manually — they are fully generated from the `.proto` source.
- Keep one service per `.proto` file; name the file after the service domain.
