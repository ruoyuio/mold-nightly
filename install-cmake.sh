#!/bin/bash

set -ex

OUTDIR="${OUTDIR:-"$PWD/out"}"
LOGDIR="${LOGDIR:-"$OUTDIR/logs"}"
mkdir -p "$OUTDIR" "$LOGDIR"

LOG_OUTPUT="${LOG_OUTPUT:-"install-cmake.log"}"
exec > >(tee "$LOGDIR/$LOG_OUTPUT")
exec 2>&1

CMAKE_VERSION="${CMAKE_VERSION:?}"
SRCDIR="${SRCDIR:-"/usr/local/src"}"
PREFIX="${PREFIX:-"/usr/local"}"

mkdir -p "$SRCDIR/cmake"
cd "$SRCDIR/cmake"
curl -fkLSs "https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz" |
  tar --strip-components=1 -xzf -
./bootstrap --prefix="$PREFIX" --parallel="$(nproc)"
make -j "$(nproc)"
make -j "$(nproc)" install
rm -rf "$SRCDIR/cmake"
