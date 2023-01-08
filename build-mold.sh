#!/bin/bash

set -e

OUTDIR="${OUTDIR:-"$PWD/out"}"
mkdir -p "$OUTDIR"

LOG_OUTPUT="${LOG_OUTPUT:-"build-mold.log"}"
exec > >(tee "$OUTDIR/$LOG_OUTPUT")
exec 2>&1

GIT_REF="${GIT_REF:-"main"}"
SRCDIR="${SRCDIR:-"/usr/local/src"}"
OPTDIR="${PREFIX:-"/opt"}"
BUILD_SUFFIX="${BUILD_SUFFIX:+"-$BUILD_SUFFIX"}"

mkdir -p "$SRCDIR"
git clone https://github.com/rui314/mold.git "$SRCDIR/mold"
cd "$SRCDIR/mold"
git checkout "$GIT_REF"
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DMOLD_MOSTLY_STATIC=ON
cmake --build build -j "$(nproc)"
ctest --test-dir build -j "$(nproc)"
cmake --install build --prefix "$OPTDIR/mold$BUILD_SUFFIX" --strip
tar -C "$OPTDIR" -czf "$OUTDIR/mold$BUILD_SUFFIX.tar.gz" "mold$BUILD_SUFFIX"
rm -rf "$SRCDIR/mold" "$OPTDIR/mold$BUILD_SUFFIX"
