#!/bin/bash

INPUT_DIR="lib/Core/Native/Definitions"

for file in "$INPUT_DIR"/*.dart; do
  echo "Pigeon çalışıyor: $file"
  dart run pigeon --input "$file"
done