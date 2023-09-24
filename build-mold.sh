#!/bin/bash

set -euxo pipefail

MOLD_GIT_REF="${MOLD_GIT_REF:-"main"}"
BUILD_SUFFIX="${BUILD_SUFFIX:-""}"

SRCDIR="${SRCDIR:-"/usr/local/src"}"
OPTDIR="${OPTDIR:-"/opt"}"
OUTDIR="${OUTDIR:-"$PWD"}"
mkdir -p "$SRCDIR" "$OPTDIR" "$OUTDIR"

mkdir -p "$SRCDIR/mold"
cd "$SRCDIR/mold"
wget -O - "https://github.com/rui314/mold/archive/$MOLD_GIT_REF.tar.gz" |
  tar -xz --strip-components=1
cmake -S . -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=gcc-10 \
  -DCMAKE_CXX_COMPILER=g++-10 \
  -DMOLD_MOSTLY_STATIC=ON
cmake --build build -j "$(nproc)"
ctest --test-dir build -j "$(nproc)" --output-on-failure
cmake --install build --prefix "$OPTDIR/mold$BUILD_SUFFIX" --strip
tar -C "$OPTDIR" -czf "$OUTDIR/mold$BUILD_SUFFIX.tar.gz" "mold$BUILD_SUFFIX"
rm -rf "$SRCDIR/mold"
