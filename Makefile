PROTO_DIR   := .
THIRD_PARTY := $(PROTO_DIR)/third_party/googleapis
OUT_DIR     := .

PACKAGES := auth

.PHONY: proto clean

proto:
	@for pkg in $(PACKAGES); do \
		protoc \
			-I $(PROTO_DIR) \
			-I $(THIRD_PARTY) \
			--go_out=$(OUT_DIR) --go_opt=paths=source_relative \
			--go-grpc_out=$(OUT_DIR) --go-grpc_opt=paths=source_relative \
			--grpc-gateway_out=$(OUT_DIR) --grpc-gateway_opt=paths=source_relative \
			$$pkg/$$pkg.proto; \
	done

clean:
	find . -name "*.pb.go" -o -name "*.pb.gw.go" | grep -v vendor | xargs rm -f
