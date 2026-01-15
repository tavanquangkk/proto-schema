#!/bin/bash
set -e

OUT=out/dart
rm -rf $OUT
mkdir -p $OUT

echo "--- Generating Dart code from Protos ---"

# Chạy lệnh protoc
# Đảm bảo các thư mục proto/master và proto/slip tồn tại
protoc \
  -I proto \
  --dart_out=grpc:$OUT \
  proto/master/*.proto \
  proto/slip/*.proto

echo "--- Creating Barrel files (exports) ---"

# Tạo các file export để import dễ dàng hơn
for dir in $OUT/*; do
  if [ -d "$dir" ]; then
    name=$(basename "$dir")
    export_file="$OUT/$name.dart"
    
    echo "// auto-generated" > "$export_file"
    for f in "$dir"/*.pb.dart; do
      if [ -f "$f" ]; then
        filename=$(basename "$f")
        echo "export '$name/$filename';" >> "$export_file"
      fi
    done
    echo "Created $export_file"
  fi
done

echo "--- Done ---"