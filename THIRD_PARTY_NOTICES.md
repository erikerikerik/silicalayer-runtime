# Third-party notices

The release archive is an aggregate. Each component keeps its own copyright and licence; the repository's MIT licence applies only to the build recipe and metadata authored here.

## ComfyUI

- Version: 0.43.0
- Commit: `426f5eea52a7ece1dd599fff4cb6cd1f352ddd24`
- Source: <https://github.com/Comfy-Org/ComfyUI/tree/426f5eea52a7ece1dd599fff4cb6cd1f352ddd24>
- Licence: GNU GPL version 3
- Licence in the runtime: `ComfyUI/LICENSE`

The corresponding unmodified source archive is attached to the same GitHub release as the binary runtime archive.

## Python standalone distribution

- CPython: 3.12.14
- Build: Astral `python-build-standalone` release `20260901`, `aarch64-apple-darwin-install_only`
- Project: <https://github.com/astral-sh/python-build-standalone>
- Release: <https://github.com/astral-sh/python-build-standalone/releases/tag/20260901>

Python and the libraries incorporated by that distribution carry multiple licences. Their upstream licence texts are retained inside `python/lib/python3.12/LICENSE.txt` and the distribution. Astral documents the distribution's licensing metadata and included licence texts in its project documentation.

## Python packages

Exact package versions and wheel hashes are recorded in `requirements-macos-arm64.lock`. Package licence metadata and licence files remain in each installed `.dist-info` directory. Notable licences outside SilicaLayer's normal source-dependency allowlist include GPL-3.0, MPL-2.0, and PSF-2.0. This runtime distribution has an explicit project-owner exception; it does not broaden the allowlist for application source dependencies.

## Model weights

No model weight is included in this runtime repository or runtime archive.
