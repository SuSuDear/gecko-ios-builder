#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"
FIREFOX_DIR="$ROOT_DIR/engine/firefox"
PATCH_DIR="$ROOT_DIR/patches"

if [ ! -d "$FIREFOX_DIR/.git" ]; then
  echo "Missing Firefox source at $FIREFOX_DIR. Run tools/development/fetch-firefox.sh first."
  exit 1
fi

if [ ! -d "$PATCH_DIR" ]; then
  echo "Missing patches directory: $PATCH_DIR"
  exit 1
fi

if ! git -C "$FIREFOX_DIR" diff --quiet --ignore-submodules --; then
  echo "$FIREFOX_DIR has tracked changes. Refusing to apply patches twice."
  exit 1
fi

find "$PATCH_DIR" -type f -name '*.patch' | sort | while IFS= read -r patch_file; do
  rel_path="${patch_file#$PATCH_DIR/}"
  echo "Applying $rel_path..."
  git -C "$FIREFOX_DIR" apply --3way --whitespace=nowarn "$patch_file"
done

echo "Finished applying patches."
