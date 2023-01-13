#!/bin/bash

set -euxo pipefail

CMAKE_VERSION="${CMAKE_VERSION:?}"

SRCDIR="${SRCDIR:-"/usr/local/src"}"
PREFIX="${PREFIX:-"/usr/local"}"
mkdir -p "$SRCDIR" "$PREFIX"

mkdir -p "$SRCDIR/cmake"
cd "$SRCDIR/cmake"
curl -fkLSs "https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz" |
  tar --strip-components=1 -xzf -
./bootstrap --prefix="$PREFIX" --parallel="$(nproc)"
make -j "$(nproc)"
make -j "$(nproc)" install
rm -rf "$SRCDIR/cmake"
