#!/usr/bin/env bash
set -euo pipefail

CRATE="${1:-hyper}"
TOOLCHAIN="${TOOLCHAIN:-dev}"

echo "Testing $CRATE +$TOOLCHAIN"

cd $CRATE

function build() {
    (cd "$CRATE" && cargo "+$TOOLCHAIN" rustc --features=full --verbose -- -Zincremental-verify-ich -Zquery-dep-graph -Zdump-dep-graph)
}

for patch in ./patches/* ; do
    echo "Running fresh build..."
    build
    
    echo "Applying $patch..."
    
    (cd "$CRATE" && git apply "../$patch")
    
    export RUST_DEP_GRAPH="../dep_graph1"
    build
    
    (cd "$CRATE" && git checkout HEAD .)
    
    echo "Reverting $patch..."
    
    export RUST_DEP_GRAPH="../dep_graph2"
    build
done