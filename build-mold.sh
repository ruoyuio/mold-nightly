#!/bin/bash

set -ex

MOLD_GIT_REF="${MOLD_GIT_REF:-"main"}"
BUILD_SUFFIX="${BUILD_SUFFIX:-""}"

SRCDIR="${SRCDIR:-"/usr/local/src"}"
OPTDIR="${OPTDIR:-"/opt"}"
OUTDIR="${OUTDIR:-"$PWD/out"}"
LOGDIR="${LOGDIR:-"$OUTDIR/logs"}"
mkdir -p "$SRCDIR" "$OPTDIR" "$OUTDIR" "$LOGDIR"

LOG_OUTPUT="${LOG_OUTPUT:-"build-mold.log"}"
exec > >(tee "$LOGDIR/$LOG_OUTPUT")
exec 2>&1

mkdir -p "$SRCDIR/mold"
cd "$SRCDIR/mold"
git clone https://github.com/rui314/mold.git --branch "$MOLD_GIT_REF" --depth 1 .
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DMOLD_MOSTLY_STATIC=ON
cmake --build build -j "$(nproc)"
ctest --test-dir build -j "$(nproc)"
cmake --install build --prefix "$OPTDIR/mold$BUILD_SUFFIX" --strip
tar -C "$OPTDIR" -czf "$OUTDIR/mold$BUILD_SUFFIX.tar.gz" "mold$BUILD_SUFFIX"
rm -rf "$SRCDIR/mold" "$OPTDIR/mold$BUILD_SUFFIX"
