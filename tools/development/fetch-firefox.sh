#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"
FIREFOX_DIR="$ROOT_DIR/engine/firefox"
FIREFOX_URL="https://github.com/mozilla-firefox/firefox"
RELEASE_FILE="$ROOT_DIR/engine/release.txt"

if [ ! -f "$RELEASE_FILE" ]; then
  echo "Missing $RELEASE_FILE"
  exit 1
fi

RELEASE_TAG="$(tr -d '\000\r' < "$RELEASE_FILE" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
if [ -z "$RELEASE_TAG" ]; then
  echo "engine/release.txt is empty"
  exit 1
fi

mkdir -p "$ROOT_DIR/engine"
if [ ! -d "$FIREFOX_DIR/.git" ]; then
  rm -rf "$FIREFOX_DIR"
  git clone --depth 1 --branch "$RELEASE_TAG" "$FIREFOX_URL" "$FIREFOX_DIR"
else
  git -C "$FIREFOX_DIR" fetch --depth 1 origin tag "$RELEASE_TAG"
  git -C "$FIREFOX_DIR" checkout --detach "refs/tags/$RELEASE_TAG^{commit}"
fi

echo "Firefox checked out at: $(git -C "$FIREFOX_DIR" rev-parse HEAD)"
