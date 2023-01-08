#!/bin/bash

set -e

OUTDIR="${OUTDIR:-"$PWD/out"}"
mkdir -p "$OUTDIR"

LOG_OUTPUT="${LOG_OUTPUT:-"install-openssl.log"}"
exec > >(tee "$OUTDIR/$LOG_OUTPUT")
exec 2>&1

OPENSSL_VERSION="${OPENSSL_VERSION:?}"
SRCDIR="${SRCDIR:-"/usr/local/src"}"
PREFIX="${PREFIX:-"/usr/local"}"

mkdir -p "$SRCDIR/openssl"
cd "$SRCDIR/openssl"
curl -fkLSs "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" |
  tar --strip-components=1 -xzf -
./Configure --prefix="$PREFIX" --libdir=lib
make -j "$(nproc)"
make -j "$(nproc)" install
ldconfig
rm -rf "$SRCDIR/openssl"
