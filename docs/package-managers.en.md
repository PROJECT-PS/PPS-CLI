# Package manager status and official registration

[한국어](package-managers.md)

## Current coverage

| Channel | Generated here | Remaining official-registration work |
| --- | --- | --- |
| Homebrew tap | `Formula/pps.rb` | None; provide this repository's Git URL on the first tap |
| Homebrew Core | Not applicable | Binary-only projects without public source do not meet Core policy |
| WinGet | Versioned YAML manifests | Submit and pass review in `microsoft/winget-pkgs` |
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

## WinGet

Each release generates AMD64 and ARM64 manifests under `packaging/winget`. Validate them with `winget validate`, test them in Windows Sandbox, and submit a PR to `microsoft/winget-pkgs` using Microsoft's [official submission process](https://learn.microsoft.com/windows/package-manager/package/repository). [WinGetCreate](https://learn.microsoft.com/windows/package-manager/package/manifest) can automate manifest generation and PR submission.

## APT, Debian, and Ubuntu

Release `.deb` files support `apt install ./pps_<version>_<arch>.deb`. A plain `apt install pps` requires a signed package index.

- Self-hosted: generate signed metadata with [reprepro](https://wiki.debian.org/DebianRepository/SetupWithReprepro) and publish it over HTTPS.
- Ubuntu PPA: [Launchpad PPAs](https://documentation.ubuntu.com/launchpad/user/reference/packaging/ppas/ppa/) require Debian source-package uploads rather than prebuilt binaries, which conflicts with the current private-source policy.
- Debian archive: requires policy-compliant source packages and Debian maintainer or sponsor review.

## Code signing

SHA-256 checksums are automatic, but trusted platform signing requires separate credentials. Use Apple Developer ID and Apple's [notarization workflow](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution) for macOS, and a trusted certificate plus Windows SDK [SignTool](https://learn.microsoft.com/windows/win32/seccrypto/signtool) for Windows. APT repository metadata must be signed with a protected GPG key.
