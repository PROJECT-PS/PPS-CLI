# PPS CLI

[한국어](README.md) · [Command guide](docs/commands.en.md) · [Polygon conversion guide](docs/polygon.en.md)

The official command-line tool for creating, testing, synchronizing, and solving problems on PPS. It supports AMD64 and ARM64 on Windows, macOS, and Linux.

## Installation

macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | sh
```

The installer uses `/usr/local/bin`, which is normally already on PATH, and requests `sudo` only when needed. You can run `pps` immediately in the same terminal.

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

The installer updates both the user PATH and the current PowerShell session, so `pps` is available without opening a new terminal.

Verify the installation:

```sh
pps --version
```

See the [installation guide](docs/installation.en.md) for Homebrew, Debian packages, and manual installation.

## Quick start

### 0. Sign in

```sh
pps auth
# After signing in, connect your GitHub account in PPS web settings before using create and related commands.
```

### 1. Create, edit, test, and synchronize a problem

```sh
pps create
pps clone <problem-id>
cd <cloned-directory>

# Edit statement, solution, generator, checker, config.json, and other problem files.
pps run .
pps sync -m "update problem"
```

Use the problem ID printed by `pps create` with `pps clone`. To connect an existing local Git repository, run `pps remote <problem-id>` inside it. `pps run` performs local testing and works without signing in.

### 2. Convert and synchronize a Polygon package

```sh
pps polygon ./polygon-package.zip ./converted-problem
cd ./converted-problem

# Connect an existing PPS problem, review the remote branch history, and synchronize it.
git init -b main
pps remote <problem-id>
pps sync --remote origin --branch main -m "import Polygon package"
```

Both ZIP archives and extracted directories are accepted. See the [Polygon conversion guide](docs/polygon.en.md) for conversion rules and Git repository setup.

### 3. Run remote validation and submit a solution

```sh
cd <problem-directory>
pps invocate

# Submit a solution file after the problem has been validated and deployed.
pps submit <problem-id> solution.cpp
```

## Main commands

| Command | Purpose |
| --- | --- |
| `pps auth` | Sign in, sign out, and inspect authentication status |
| `pps create`, `pps clone`, `pps remote` | Create, clone, or connect a problem repository |
| `pps run` | Build and test solutions locally |
| `pps polygon` | Convert a Polygon package to PPS format |
| `pps sync` | Pull, commit, and push Git changes |
| `pps invocate`, `pps deploy` | Run remote validation and deploy a problem |
| `pps submit`, `pps list` | Submit solutions and inspect submissions |
| `pps update` | Update the CLI |

See every option in the built-in help:

```sh
pps --help
pps <command> --help
```

The [command guide](docs/commands.en.md) covers complete workflows and more examples.

## Support

- Bugs and feature requests: [GitHub Issues](https://github.com/PROJECT-PS/PPS-CLI/issues)
- Troubleshooting: [SUPPORT.md](SUPPORT.md)
- Release history: [CHANGELOG.en.md](CHANGELOG.en.md)
- Security reports: [SECURITY.md](SECURITY.md)
- License: [MIT License](LICENSE)
