#!/bin/bash

PROTO_DIR="./proto"
OUT_DIR="./frontend/lib/generated"

mkdir -p $OUT_DIR

protoc --plugin=protoc-gen-dart=$HOME/.pub-cache/bin/protoc-gen-dart \
  --dart_out=grpc:$OUT_DIR \
  -I $PROTO_DIR \
  google/protobuf/empty.proto $PROTO_DIR/werwolf.proto

echo "gRPC-Files successfully created at $OUT_DIR"