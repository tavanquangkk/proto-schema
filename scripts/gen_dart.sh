#!/bin/bash
set -e

OUT=out/dart
rm -rf $OUT
mkdir -p $OUT

protoc \
  --dart_out=grpc:$OUT \
  proto/**/*.proto

# Tạo file index theo folder
for dir in $OUT/*; do
  if [ -d "$dir" ]; then
    name=$(basename "$dir")
    echo "// auto-generated" > $OUT/$name.dart
    for f in $dir/*.pb.dart; do
      base=$(basename "$f")
      echo "export '$name/$base';" >> $OUT/$name.dart
    done
  fi
done
