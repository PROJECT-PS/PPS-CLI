# Detailed installation guide

[한국어](installation.md)

## Automated installers

On macOS and Linux, the installer detects the operating system and CPU, downloads the latest release plus `checksums.txt`, and verifies SHA-256:

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | sh
```

The default destination is `/usr/local/bin`, which is already on PATH in standard shells. The installer requests `sudo` when the current user cannot write there. After it finishes, run `pps --version` immediately in the same terminal.

Set `PPS_VERSION=v0.5.0` to install a specific version. To change the destination, set `PPS_INSTALL_DIR` to a directory already on PATH.

On Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

The default destination is `%LOCALAPPDATA%\Programs\PPS`. The installer permanently adds it to the user PATH and also updates the current PowerShell session immediately.

For a downloaded script, use parameters such as `./install.ps1 -Version v0.5.0 -InstallDir C:\Tools\PPS`.

Windows is distributed independently through this PowerShell installer and GitHub Release ZIP files.

## Updates

Starting with `v0.2.0`, install the latest release on every supported platform with:

```sh
pps update
```

PPS checks for a new release at most once per day when a command runs. The network request is limited to two seconds. Timeouts and other errors do not affect the requested command, but the attempted check is still recorded in `update-check.json` so it is not repeated for 24 hours.

The updater verifies the downloaded archive against the release's `checksums.txt`. Linux and macOS atomically replace the verified executable. On Windows, a background process waits for the running `pps.exe` to exit before replacing it.

Self-update can fail when the executable is in an administrator-owned directory. In that case, rerun the installer with access to the destination or use the original package manager. Version `v0.1.0` did not have the update command, so install `v0.2.0` once using an installer before relying on self-update.

## Manual installation

Download the matching archive and `checksums.txt` from [GitHub Releases](https://github.com/PROJECT-PS/PPS-CLI/releases), verify SHA-256, extract `pps` or `pps.exe` into a directory on `PATH`, and run `pps --version`.

Archive names follow `pps_<version>_<os>_<arch>`, with `.tar.gz` on Linux/macOS and `.zip` on Windows. Debian packages are published as `pps_<version>_amd64.deb` and `pps_<version>_arm64.deb` and can be installed using `sudo apt install ./<file>.deb`.

## Removal

- macOS/Linux direct installer: run `sudo rm /usr/local/bin/pps` for the default installation. If you set `PPS_INSTALL_DIR`, remove `pps` from that directory instead.
- Windows: delete the default `%LOCALAPPDATA%\Programs\PPS` directory and remove that entry from the user `PATH`. If you used `-InstallDir`, remove that directory instead.
- Homebrew: `brew uninstall PROJECT-PS/PPS-CLI/pps`, then optionally `brew untap PROJECT-PS/PPS-CLI`
- Debian/Ubuntu: `sudo apt remove pps`

Authentication data remains until `~/.pps` on Linux/macOS or `%APPDATA%\PPS` on Windows is removed.
