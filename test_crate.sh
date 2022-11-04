#!/usr/bin/env bash
set -euo pipefail

CRATE="${1:-hyper}"
TOOLCHAIN="${TOOLCHAIN:-dev}"

echo "Testing $CRATE +$TOOLCHAIN"

cd $CRATE

function build() {
    (cd "$CRATE" && RUSTFLAGS='-Zincremental-verify-ich' cargo "+$TOOLCHAIN" build --features=full)
}

build

for patch in ./patches/* ; do
    echo "Applying $patch..."
    
    (cd "$CRATE" && git apply "../$patch")
    
    build
    
    (cd "$CRATE" && git checkout HEAD .)
    
    build
done