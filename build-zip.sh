#!/usr/bin/env bash
# Build a versioned, installable zip of the plugin:
#   dist/kdna-ecommerce-suite-<version>.zip
# The version is read from the "Version:" line of the plugin header.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SLUG="kdna-ecommerce-suite"
MAIN="$ROOT/$SLUG/$SLUG.php"

if [ ! -f "$MAIN" ]; then
    echo "Plugin file not found: $MAIN" >&2
    exit 1
fi

VERSION="$(sed -n 's/^[[:space:]*]*Version:[[:space:]]*\([^[:space:]]*\).*/\1/p' "$MAIN" | head -n 1)"
if [ -z "$VERSION" ]; then
    echo "Could not read Version: from $MAIN" >&2
    exit 1
fi

mkdir -p "$ROOT/dist"
ZIP="$ROOT/dist/$SLUG-$VERSION.zip"
rm -f "$ZIP"

cd "$ROOT"
zip -rq "$ZIP" "$SLUG" \
    -x "*/.git/*" "*/.DS_Store" "*/node_modules/*" "*/.gitignore"

echo "Built $ZIP"
