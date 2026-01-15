#!/bin/bash
set -e

OUT=out/dart
rm -rf $OUT
mkdir -p $OUT

protoc \
  -I proto \
  --dart_out=grpc:$OUT \
  proto/master/*.proto \
  proto/slip/*.proto

for dir in $OUT/*; do
  [ -d "$dir" ] || continue
  name=$(basename "$dir")
  echo "// auto-generated" > $OUT/$name.dart
  for f in $dir/*.pb.dart; do
    echo "export '$name/$(basename "$f")';" >> $OUT/$name.dart
  done
done
