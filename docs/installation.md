# 설치 상세 안내

[English](installation.en.md)

## 자동 설치

macOS와 Linux에서는 다음 명령이 운영체제와 CPU 아키텍처를 감지하고, 최신 릴리즈 및 `checksums.txt`를 내려받아 SHA-256을 확인합니다.

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | sh
```

기본 설치 경로는 대부분의 셸에서 PATH에 포함된 `/usr/local/bin`입니다. 현재 사용자가 이 경로에 쓸 수 없으면 설치기가 `sudo` 권한을 요청합니다. 설치 명령이 끝나면 같은 터미널에서 `pps --version`을 바로 실행할 수 있습니다.

특정 버전을 지정할 수 있습니다.

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | \
  PPS_VERSION=v0.7.0 sh
```

설치 위치를 바꾸려면 `PPS_INSTALL_DIR`에 현재 PATH에 포함된 디렉터리를 지정하세요.

기본 설치에서 `/usr/local/bin`에 관리자 권한이 필요하면 실제 바이너리는 `~/.local/share/pps/bin/pps`에 두고 `/usr/local/bin/pps`를 링크합니다. 초기 링크 설치 뒤 자동 업데이트에는 sudo가 필요하지 않습니다. 직접 지정한 시스템 경로나 `.deb` 설치는 기존 권한 정책을 따릅니다.

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

기본 경로는 `%LOCALAPPDATA%\Programs\PPS`입니다. 설치기는 사용자 PATH에 이 경로를 영구 등록하고 현재 PowerShell 세션에도 즉시 반영합니다.

로컬 파일로 받은 경우 `./install.ps1 -Version v0.7.0 -InstallDir C:\Tools\PPS`처럼 실행할 수 있습니다.

Windows는 이 PowerShell 설치 스크립트와 GitHub Release ZIP으로 독립 배포합니다.

## 업데이트

`v0.2.0` 이상에서는 운영체제와 설치 방식에 관계없이 다음 명령으로 최신 릴리즈를 설치할 수 있습니다.

```sh
pps update
```

PPS v0.9.0부터 명령 실행 시 하루 한 번 최신 버전을 확인하고, 새 릴리즈가 있으면 체크섬 검증 후 자동 설치합니다. 버전 확인은 최대 2초, 자동 다운로드·설치는 최대 30초입니다. 오류나 권한 부족은 stderr에 안내하며 원래 명령을 계속 실행합니다. 실패한 확인도 24시간 동안 재시도하지 않으며 `pps update`로 즉시 재시도할 수 있습니다. `pps config set auto_update false`로 끄고 `pps config unset auto_update`로 기본값을 복구합니다. `PPS_NO_UPDATE=1`은 해당 실행의 자동 확인과 설치를 모두 끕니다. 도움말·설정·`--version`은 자동 업데이트하지 않습니다.

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

- macOS/Linux 설치 스크립트: 기본 설치에서는 `sudo rm /usr/local/bin/pps`로 실행 파일 또는 링크를 삭제합니다. 사용자 관리 바이너리를 사용했다면 `~/.local/share/pps/bin/pps`도 삭제합니다. `PPS_INSTALL_DIR`을 사용했다면 해당 경로의 `pps`를 삭제합니다.
- Windows: 기본 설치 경로 `%LOCALAPPDATA%\Programs\PPS`를 삭제하고, 사용자 `PATH`에서 같은 경로를 제거합니다. 별도 `-InstallDir`을 사용했다면 해당 경로를 삭제합니다.
- Homebrew: `brew uninstall PROJECT-PS/PPS-CLI/pps` 후 필요하면 `brew untap PROJECT-PS/PPS-CLI`
- Debian/Ubuntu: `sudo apt remove pps`

인증 정보까지 삭제하려면 Linux/macOS에서 `~/.pps`, Windows에서 `%APPDATA%\PPS`를 별도로 삭제하세요. 이 작업은 로그아웃 정보와 세션을 복구할 수 없게 삭제합니다.

Windows v0.8.1 이하의 자체 업데이트는 파일 교체 helper가 실행되지 않아 버전이 그대로 남을 수 있습니다. 이 경우 위 PowerShell 설치 명령을 한 번 다시 실행하세요. v0.9.0부터는 수정된 자동 업데이트가 동작합니다.
