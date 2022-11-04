CRATE="${1:-hyper}"
TOOLCHAIN="${TOOLCHAIN:-dev}"

echo "Testing $CRATE +$TOOLCHAIN"

cd "$CRATE" && cargo "+$TOOLCHAIN" build --features=full