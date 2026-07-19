# Installation and distribution channels

[한국어](package-managers.md)

## Current coverage

| Channel | Coverage | Operation |
| --- | --- | --- |
| Homebrew tap | `Formula/pps.rb` | Provide this repository's Git URL on the first tap |
| Homebrew Core | Not applicable | Binary-only projects without public source do not meet Core policy |
| Direct Windows install | AMD64 and ARM64 ZIP files plus `install.ps1` | Distributed independently through GitHub Releases |
| Debian/Ubuntu `.deb` | AMD64 and ARM64 packages | Direct install from each release |
| `apt install pps` repository | Not hosted yet | Signed APT repository, PPA, or distribution packaging required |

## Homebrew

This repository can serve as a tap without central review. Because its name does not start with `homebrew-`, the first tap command must include the Git URL:

```sh
brew tap PROJECT-PS/PPS-CLI https://github.com/PROJECT-PS/PPS-CLI.git
brew install PROJECT-PS/PPS-CLI/pps
```

The release process updates `Formula/pps.rb` with immutable URLs and SHA-256 values according to Homebrew's [official tap guide](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap). If a prefix-free short tap command becomes important, create a separate conventional repository such as `PROJECT-PS/homebrew-tap`.

Homebrew's [Core acceptance policy](https://docs.brew.sh/Acceptable-Formulae) requires open-source software that can be built from source and rejects binary-only formulae. The project should therefore keep its own tap while its source remains private. A macOS-only submission to `homebrew/cask`, which permits upstream binaries, can be evaluated separately but would not replace this tap's Linux support.

## Windows

Windows is managed separately without package-manager registration. Each release publishes AMD64 and ARM64 ZIP files to GitHub Releases. `install.ps1` detects the native architecture, downloads the archive, verifies SHA-256, installs `pps.exe`, and updates the user `PATH`.

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

After the first install, use `pps update` for later releases or rerun the installer. See the [detailed installation guide](installation.en.md) for manual installation and removal.

## APT, Debian, and Ubuntu

Release `.deb` files support `apt install ./pps_<version>_<arch>.deb`. A plain `apt install pps` requires a signed package index.

Executables installed from a `.deb` are normally owned by root, so `pps update` may not have permission to replace them. Download the next `.deb` and run `sudo apt install ./<file>.deb` in that case.

- Self-hosted: generate signed metadata with [reprepro](https://wiki.debian.org/DebianRepository/SetupWithReprepro) and publish it over HTTPS.
- Ubuntu PPA: [Launchpad PPAs](https://documentation.ubuntu.com/launchpad/user/reference/packaging/ppas/ppa/) require Debian source-package uploads rather than prebuilt binaries, which conflicts with the current private-source policy.
- Debian archive: requires policy-compliant source packages and Debian maintainer or sponsor review.

## Code signing

SHA-256 checksums are automatic, but trusted platform signing requires separate credentials. Use Apple Developer ID and Apple's [notarization workflow](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution) for macOS, and a trusted certificate plus Windows SDK [SignTool](https://learn.microsoft.com/windows/win32/seccrypto/signtool) for Windows. APT repository metadata must be signed with a protected GPG key.
