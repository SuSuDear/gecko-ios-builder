# gecko-ios-builder

Builds a patched iOS Gecko `dist` bundle for Reynard Browser and publishes it as a GitHub Release asset.

This repository intentionally does **not** vendor Firefox source. The workflow clones:

- `https://github.com/mozilla-firefox/firefox`
- release/tag from `engine/release.txt`

Then it applies `patches/`, builds Gecko for `aarch64-apple-ios`, and packages:

```text
engine/firefox/obj-aarch64-apple-ios/dist
```

as:

```text
gecko-ios-aarch64-dist.tar.zst
```

The Reynard app repository can download this asset and extract it to:

```text
engine/firefox/obj-aarch64-apple-ios/dist
```
