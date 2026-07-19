# PPS CLI

[한국어](README.md) · [English](README.en.md)

PPS CLI는 터미널에서 PROJECT-PS 문제 저장소를 만들고, 검증·실행·배포하고, 코드를 제출할 수 있는 공식 명령줄 도구입니다.

> 이 공개 저장소는 릴리즈 바이너리, 설치 도구, 패키지 메타데이터와 사용자 문서만 제공합니다. 애플리케이션 소스 코드는 포함하지 않습니다.

## 지원 환경

| 운영체제 | x86-64 / AMD64 | ARM64 |
| --- | --- | --- |
| Windows 10/11 | 지원 | 지원 |
| macOS | Intel 지원 | Apple Silicon 지원 |
| Linux | 지원 | 지원 |

## 설치

### macOS / Linux 설치 스크립트

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | sh
```

기본 설치 위치는 `~/.local/bin/pps`입니다. 다른 위치는 `PPS_INSTALL_DIR`로 지정할 수 있습니다.

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | PPS_INSTALL_DIR=/usr/local/bin sh
```

### Homebrew (첫 릴리즈 이후)

```sh
brew tap PROJECT-PS/PPS-CLI https://github.com/PROJECT-PS/PPS-CLI.git
brew install PROJECT-PS/PPS-CLI/pps
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

기본 설치 위치는 `%LOCALAPPDATA%\Programs\PPS`이며 사용자 `PATH`에 자동으로 추가됩니다.

### Debian / Ubuntu

릴리즈 페이지에서 아키텍처에 맞는 `.deb` 파일을 받은 뒤 설치합니다.

```sh
VERSION=v0.1.0
sudo apt install "./pps_${VERSION}_amd64.deb"
```

설치 및 배포 채널별 현황은 [배포 채널 안내](docs/package-managers.md)를 참고하세요. 수동 설치, 체크섬 검증과 삭제 방법은 [설치 상세 문서](docs/installation.md)에 있습니다.

## 빠른 시작

```sh
pps auth
pps auth status

pps create --name two-sum --template stdio
pps clone 107
pps invocate
pps list invocate
pps detail invocate 456
pps deploy

pps run .
pps submit 107 solution.cpp --language cpp17
```

전체 명령은 `pps --help`, 세부 명령은 `pps <command> --help`로 확인할 수 있습니다. 자세한 사용 흐름은 [명령어 안내](docs/commands.md)를 참고하세요.

## 인증 정보와 설정 위치

PPS 세션은 운영체제 사용자만 읽을 수 있는 `config.json`에 저장됩니다.

| 운영체제 | 릴리즈 `pps` |
| --- | --- |
| Linux / macOS | `~/.pps/config.json` |
| Windows | `%APPDATA%\PPS\config.json` |

`pps auth status`에서 현재 사용 중인 정확한 경로를 확인할 수 있습니다. 로그아웃하면 저장된 토큰과 사용자 정보가 제거됩니다.

## 업데이트와 무결성

Windows와 macOS/Linux 직접 설치는 설치 스크립트를 다시 실행하고, Homebrew는 `brew upgrade`를 사용하세요. 모든 GitHub Release에는 `checksums.txt`가 포함되며 설치 스크립트는 SHA-256 체크섬을 검증합니다.

## 지원 및 보안

- 일반 질문과 문제 해결: [SUPPORT.md](SUPPORT.md)
- 버그 및 기능 제안: [GitHub Issues](https://github.com/PROJECT-PS/PPS-CLI/issues)
- 보안 취약점: [SECURITY.md](SECURITY.md)의 비공개 신고 절차
- 변경 사항: [CHANGELOG.md](CHANGELOG.md)

## 라이선스

배포 자료는 [MIT License](LICENSE)를 따릅니다. 포함된 의존성 고지는 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)를 참고하세요.
