# SilicaLayer macOS Runtime

Build recipe, dependency lock, provenance, and release artifacts for SilicaLayer's private managed ComfyUI runtime on Apple Silicon.

This repository contains no model weights. SilicaLayer downloads model files separately from their original hosts after showing their source, size, checksum, and licence.

## Qualified release

`comfyui-0.43.0-macos-arm64-r1` contains:

- CPython 3.12.14 from Astral's `python-build-standalone` release `20260901`;
- ComfyUI 0.43.0 at commit `426f5eea52a7ece1dd599fff4cb6cd1f352ddd24`;
- PyTorch 2.12.1, torchvision 0.27.1, and torchaudio 2.11.0;
- 85 fully pinned Python wheels, each checked by SHA-256 during installation.

The runtime archive has no symbolic links. SilicaLayer restores executable permission only to `python/bin/python3` after secure extraction. The archive was qualified on an M4 Mac mini with 24 GB unified memory: ComfyUI started on MPS and generated a 1008 x 1008 Z-Image Turbo image.

## Build

Requirements: Apple Silicon macOS, `curl`, `tar`, Rust/Cargo, and enough free space for a roughly 2 GB staging tree.

```sh
sh scripts/build-macos-arm64.sh
```

The script verifies every downloaded input and wheel. Output is written to the path printed at completion. The release's exact observed artifact metadata is in `release.json`.

## Licensing

The build scripts in this repository are MIT licensed. The produced runtime is an aggregate of separately licensed components and is not relicensed as MIT. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), the licence files inside the runtime, and each installed distribution's `.dist-info` metadata.

No SilicaLayer application release is published from this repository.
