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
  PPS_VERSION=v0.3.1 PPS_INSTALL_DIR="$HOME/bin" sh
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

로컬 파일로 받은 경우 `./install.ps1 -Version v0.3.1 -InstallDir C:\Tools\PPS`처럼 실행할 수 있습니다.

Windows는 이 PowerShell 설치 스크립트와 GitHub Release ZIP으로 독립 배포합니다.

## 업데이트

`v0.2.0` 이상에서는 운영체제와 설치 방식에 관계없이 다음 명령으로 최신 릴리즈를 설치할 수 있습니다.

```sh
pps update
```

PPS는 명령 실행 시 하루 한 번만 최신 버전을 확인합니다. 네트워크 요청은 최대 2초이며 타임아웃이나 오류가 발생해도 명령 실행에는 영향을 주지 않습니다. 실패한 확인도 `update-check.json`에 시각을 기록해 24시간 동안 다시 시도하지 않습니다.

업데이트 파일은 GitHub Release의 `checksums.txt`로 SHA-256을 확인합니다. Linux와 macOS는 검증된 실행 파일을 원자적으로 교체합니다. Windows는 실행 중인 `pps.exe`가 잠길 수 있으므로 새 파일을 검증한 뒤 백그라운드 작업이 명령 종료를 기다렸다가 교체합니다.

설치 위치가 시스템 관리자만 쓸 수 있는 경로라면 권한 오류가 날 수 있습니다. 이 경우 설치 스크립트를 권한이 있는 경로에 다시 실행하거나 해당 설치 방식의 패키지 관리자 업데이트를 사용하세요. `v0.1.0` 사용자는 자체 업데이트 명령이 없으므로 위 자동 설치 방식으로 `v0.2.0`을 한 번 설치해야 합니다.

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

- macOS/Linux 설치 스크립트: 설치된 `pps` 파일을 삭제합니다.
- Windows: 기본 설치 경로 `%LOCALAPPDATA%\Programs\PPS`를 삭제하고, 사용자 `PATH`에서 같은 경로를 제거합니다. 별도 `-InstallDir`을 사용했다면 해당 경로를 삭제합니다.
- Homebrew: `brew uninstall PROJECT-PS/PPS-CLI/pps` 후 필요하면 `brew untap PROJECT-PS/PPS-CLI`
- Debian/Ubuntu: `sudo apt remove pps`

인증 정보까지 삭제하려면 Linux/macOS에서 `~/.pps`, Windows에서 `%APPDATA%\PPS`를 별도로 삭제하세요. 이 작업은 로그아웃 정보와 세션을 복구할 수 없게 삭제합니다.
