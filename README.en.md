# PPS CLI

[한국어](README.md) · [English](README.en.md)

PPS CLI is the official command-line tool for creating, validating, invoking, deploying, and solving PROJECT-PS problem repositories from a terminal.

> This public repository contains release binaries, installers, package metadata, and user documentation. It does not contain the application source code.

## Supported platforms

| Operating system | x86-64 / AMD64 | ARM64 |
| --- | --- | --- |
| Windows 10/11 | Supported | Supported |
| macOS | Intel supported | Apple Silicon supported |
| Linux | Supported | Supported |

## Installation

### macOS / Linux installer

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | sh
```

The default destination is `~/.local/bin/pps`. Set `PPS_INSTALL_DIR` to choose another directory.

### Homebrew

```sh
brew tap PROJECT-PS/PPS-CLI https://github.com/PROJECT-PS/PPS-CLI.git
brew install PROJECT-PS/PPS-CLI/pps
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

The installer uses `%LOCALAPPDATA%\Programs\PPS` and adds it to the user `PATH`.

### Debian / Ubuntu

Download the `.deb` matching your architecture from the release page:

```sh
VERSION=v0.4.0
sudo apt install "./pps_${VERSION}_amd64.deb"
```

See [distribution channel status](docs/package-managers.en.md) and the [detailed installation guide](docs/installation.en.md) for manual installation, verification, and removal.

## Quick start

```sh
# Create and test a local package without authentication
pps create --local --name two-sum
cd two-sum
# Add problem files, then run them locally
pps run .

# Create, validate, and deploy a remote PPS repository
pps auth
pps create --name two-sum --template stdio
pps clone 1
pps invocate
pps list invocate
pps detail invocate 456
pps deploy
pps problem 1
pps submit 1 solution.cpp
pps -v
pps update
```

Problem `#1` in these examples is the public **a + b** problem: print the sum of two integers (1 second, 128 MiB, sample `1 2` → `3`). Only `pps auth` and `pps create` may prompt. Every other command uses options and documented defaults, so terminal and automated invocations behave the same way. Run `pps --help` or `pps <command> --help` for flags and copyable examples. See the [command guide](docs/commands.en.md) and the more detailed [Korean workbook](docs/commands.md) for complete workflows.

## Authentication and update state

The PPS session and last update-check time are stored in separate user-only files.

| Operating system | Authentication | Update-check state | `testlib.h` cache |
| --- | --- | --- | --- |
| Linux / macOS | `~/.pps/config.json` | `~/.pps/update-check.json` | `~/.pps/PPS-ASSETS` |
| Windows | `%APPDATA%\PPS\config.json` | `%APPDATA%\PPS\update-check.json` | `%APPDATA%\PPS\PPS-ASSETS` |

`pps auth status` prints the active authentication path. Logging out removes the stored token and user identity. `update-check.json` stores only the last check time and contains no credentials. When native execution needs `testlib.h`, PPS CLI automatically downloads the public PPS-ASSETS repository into the cache path above.

## Automatic updates

Release builds check the latest GitHub Release at most once every 24 hours when a command runs. A timeout or network failure is silently ignored after two seconds and still suppresses another check for 24 hours. When a newer release exists, PPS prints a reminder to stderr:

```sh
pps update
```

`pps update` downloads the archive for the current platform, verifies it against `checksums.txt`, and replaces the executable. Windows finishes replacement after the command exits because a running executable may be locked. Automatic checks and self-update are disabled for the `pps-dev` and `go run .` development profiles.

`pps --version` prints only the installed version without network access. `pps -v` also checks the latest GitHub Release and reports whether an update is available; the latest version is shown as `unknown` when it cannot be checked.

Version `v0.1.0` did not include `pps update`; install `v0.2.0` once through the installer or Homebrew. Later releases can be installed with `pps update`. See the [detailed installation guide](docs/installation.en.md).

## Support and security

- Help and troubleshooting: [SUPPORT.md](SUPPORT.md)
- Bugs and feature requests: [GitHub Issues](https://github.com/PROJECT-PS/PPS-CLI/issues)
- Security reports: follow the private process in [SECURITY.md](SECURITY.md)
- Release history: [CHANGELOG.en.md](CHANGELOG.en.md)

## License

Distribution materials are available under the [MIT License](LICENSE). See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for bundled dependencies.
