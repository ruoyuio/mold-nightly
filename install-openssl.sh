#!/bin/bash

set -euxo pipefail

OPENSSL_VERSION="${OPENSSL_VERSION:?}"

SRCDIR="${SRCDIR:-"/usr/local/src"}"
PREFIX="${PREFIX:-"/usr/local"}"
mkdir -p "$SRCDIR" "$PREFIX"

mkdir -p "$SRCDIR/openssl"
cd "$SRCDIR/openssl"
curl -fkLSs "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" |
  tar --strip-components=1 -xzf -
./Configure --prefix="$PREFIX" --libdir=lib
make -j "$(nproc)"
make -j "$(nproc)" install
ldconfig
rm -rf "$SRCDIR/openssl"
