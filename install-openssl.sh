#!/bin/bash

set -ex

OPENSSL_VERSION="${OPENSSL_VERSION:?}"

SRCDIR="${SRCDIR:-"/usr/local/src"}"
PREFIX="${PREFIX:-"/usr/local"}"
OUTDIR="${OUTDIR:-"$PWD/out"}"
LOGDIR="${LOGDIR:-"$OUTDIR/logs"}"
mkdir -p "$SRCDIR" "$PREFIX" "$OUTDIR" "$LOGDIR"

LOG_OUTPUT="${LOG_OUTPUT:-"install-openssl.log"}"
exec > >(tee "$LOGDIR/$LOG_OUTPUT")
exec 2>&1

mkdir -p "$SRCDIR/openssl"
cd "$SRCDIR/openssl"
curl -fkLSs "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" |
  tar --strip-components=1 -xzf -
./Configure --prefix="$PREFIX" --libdir=lib
make -j "$(nproc)"
make -j "$(nproc)" install
ldconfig
rm -rf "$SRCDIR/openssl"
