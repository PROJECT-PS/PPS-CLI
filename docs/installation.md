# 설치 상세 안내

[English](installation.en.md)

## 자동 설치

macOS와 Linux에서는 다음 명령이 운영체제와 CPU 아키텍처를 감지하고, 최신 릴리즈 및 `checksums.txt`를 내려받아 SHA-256을 확인합니다.

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | sh
```

특정 버전이나 설치 위치를 지정할 수 있습니다.

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | \
  PPS_VERSION=0.1.0 PPS_INSTALL_DIR="$HOME/bin" sh
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

로컬 파일로 받은 경우 `./install.ps1 -Version 0.1.0 -InstallDir C:\Tools\PPS`처럼 실행할 수 있습니다.

## 수동 설치

1. [GitHub Releases](https://github.com/PROJECT-PS/PPS-CLI/releases)에서 운영체제와 아키텍처에 맞는 압축 파일과 `checksums.txt`를 받습니다.
2. SHA-256 체크섬을 확인합니다.
3. 압축을 풀고 `pps` 또는 `pps.exe`를 `PATH`에 포함된 디렉터리로 옮깁니다.
4. `pps --version`을 실행합니다.

릴리즈 파일 이름은 다음 형식입니다.

- `pps_<version>_linux_amd64.tar.gz`
- `pps_<version>_linux_arm64.tar.gz`
- `pps_<version>_darwin_amd64.tar.gz`
- `pps_<version>_darwin_arm64.tar.gz`
- `pps_<version>_windows_amd64.zip`
- `pps_<version>_windows_arm64.zip`

Debian/Ubuntu는 릴리즈의 `pps_<version>_amd64.deb` 또는 `pps_<version>_arm64.deb`를 `sudo apt install ./파일명.deb`로 설치할 수 있습니다.

## 삭제

- 설치 스크립트: 설치된 `pps` 파일을 삭제합니다.
- Homebrew: `brew uninstall PROJECT-PS/PPS-CLI/pps` 후 필요하면 `brew untap PROJECT-PS/PPS-CLI`
- WinGet: `winget uninstall --id PROJECT-PS.PPS`
- Debian/Ubuntu: `sudo apt remove pps`

인증 정보까지 삭제하려면 Linux/macOS에서 `~/.pps`, Windows에서 `%APPDATA%\PPS`를 별도로 삭제하세요. 이 작업은 로그아웃 정보와 세션을 복구할 수 없게 삭제합니다.
