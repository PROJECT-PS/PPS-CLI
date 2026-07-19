# Detailed installation guide

[한국어](installation.md)

## Automated installers

On macOS and Linux, the installer detects the operating system and CPU, downloads the latest release plus `checksums.txt`, and verifies SHA-256:

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | sh
```

Set `PPS_VERSION=v0.1.0` or `PPS_INSTALL_DIR="$HOME/bin"` to override the version or destination.

On Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

For a downloaded script, use parameters such as `./install.ps1 -Version v0.1.0 -InstallDir C:\Tools\PPS`.

Windows is distributed independently through this PowerShell installer and GitHub Release ZIP files. Run the same command again to replace the installed `pps.exe` with the latest version.

## Manual installation

Download the matching archive and `checksums.txt` from [GitHub Releases](https://github.com/PROJECT-PS/PPS-CLI/releases), verify SHA-256, extract `pps` or `pps.exe` into a directory on `PATH`, and run `pps --version`.

Archive names follow `pps_<version>_<os>_<arch>`, with `.tar.gz` on Linux/macOS and `.zip` on Windows. Debian packages are published as `pps_<version>_amd64.deb` and `pps_<version>_arm64.deb` and can be installed using `sudo apt install ./<file>.deb`.

## Removal

- macOS/Linux direct installer: remove the installed `pps` executable.
- Windows: delete the default `%LOCALAPPDATA%\Programs\PPS` directory and remove that entry from the user `PATH`. If you used `-InstallDir`, remove that directory instead.
- Homebrew: `brew uninstall PROJECT-PS/PPS-CLI/pps`, then optionally `brew untap PROJECT-PS/PPS-CLI`
- Debian/Ubuntu: `sudo apt remove pps`

Authentication data remains until `~/.pps` on Linux/macOS or `%APPDATA%\PPS` on Windows is removed.
