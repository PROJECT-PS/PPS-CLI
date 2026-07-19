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

### Homebrew (after the first release)

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
VERSION=v0.1.0
sudo apt install "./pps_${VERSION}_amd64.deb"
```

See [distribution channel status](docs/package-managers.en.md) and the [detailed installation guide](docs/installation.en.md) for manual installation, verification, and removal.

## Quick start

```sh
pps auth
pps create --name two-sum --template stdio
pps clone 107
pps invocate
pps list invocate
pps detail invocate 456
pps deploy
pps run .
pps submit 107 solution.cpp --language cpp17
```

Run `pps --help` or `pps <command> --help` for contextual help. See the [command guide](docs/commands.en.md) for complete workflows.

## Authentication data

The PPS session is stored in a user-only `config.json` file.

| Operating system | Release `pps` |
| --- | --- |
| Linux / macOS | `~/.pps/config.json` |
| Windows | `%APPDATA%\PPS\config.json` |

`pps auth status` prints the exact active location. Logging out removes the stored token and user identity.

## Updates and integrity

For direct Windows and macOS/Linux installations, run the installer again. Use `brew upgrade` for Homebrew. Every GitHub Release contains `checksums.txt`, and the installers verify SHA-256 before installing.

## Support and security

- Help and troubleshooting: [SUPPORT.md](SUPPORT.md)
- Bugs and feature requests: [GitHub Issues](https://github.com/PROJECT-PS/PPS-CLI/issues)
- Security reports: follow the private process in [SECURITY.md](SECURITY.md)
- Release history: [CHANGELOG.en.md](CHANGELOG.en.md)

## License

Distribution materials are available under the [MIT License](LICENSE). See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for bundled dependencies.
