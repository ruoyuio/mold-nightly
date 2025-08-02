#!/bin/bash

set -euxo pipefail

BUILD_PREFIX="${BUILD_PREFIX:-"mold"}"
TIMESTAMP="${TIMESTAMP:-"$(date +%s)"}"

export SOURCE_DATE_EPOCH="$TIMESTAMP"

cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DMOLD_MOSTLY_STATIC=ON \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++
cmake --build build -j "$(nproc)"
cmake --install build

cmake -S . -B build -DMOLD_USE_MOLD=ON
cmake --build build -j "$(nproc)"
cmake --install build --prefix "$BUILD_PREFIX" --strip

find "$BUILD_PREFIX" -exec \
  touch --no-dereference --date="@$TIMESTAMP" {} +
find "$BUILD_PREFIX" -print |
  sort |
  tar -cf - --no-recursion --files-from=- |
  gzip -9nc >"$BUILD_PREFIX.tar.gz"
rm -rf build "$BUILD_PREFIX"
