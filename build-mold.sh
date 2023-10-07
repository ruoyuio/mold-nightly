#!/bin/bash

set -euxo pipefail

BUILD_SUFFIX="${BUILD_SUFFIX:-""}"

cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=gcc-10 \
  -DCMAKE_CXX_COMPILER=g++-10 \
  -DMOLD_LTO=ON \
  -DMOLD_MOSTLY_STATIC=ON
cmake --build build -j "$(nproc)"
ctest --test-dir build -j "$(nproc)" --output-on-failure || true
cmake --install build --prefix "mold$BUILD_SUFFIX" --strip
tar -czf "mold$BUILD_SUFFIX.tar.gz" "mold$BUILD_SUFFIX"
rm -rf build "mold$BUILD_SUFFIX"
