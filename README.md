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

### Homebrew

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
VERSION=v0.4.0
sudo apt install "./pps_${VERSION}_amd64.deb"
```

설치 및 배포 채널별 현황은 [배포 채널 안내](docs/package-managers.md)를 참고하세요. 수동 설치, 체크섬 검증과 삭제 방법은 [설치 상세 문서](docs/installation.md)에 있습니다.

## 빠른 시작

```sh
# 인증 없이 로컬 문제 패키지 생성·실행
pps create --local --name two-sum
cd two-sum
# 문제 파일을 작성한 뒤
pps run .

# PPS 원격 저장소 생성·검증·배포
pps auth
pps auth status
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

예제의 `#1`은 두 정수의 합을 출력하는 공개 문제 **a + b**입니다(1초, 128 MiB, 예제 `1 2` → `3`). 대화형 입력은 `pps auth`와 `pps create`에서만 사용합니다. 나머지 명령은 옵션과 문서화된 기본값으로 동작하므로 터미널과 자동화에서 같은 방식으로 실행됩니다. 플래그와 전체 명령은 `pps --help`, 세부 명령은 `pps <command> --help`로 확인할 수 있습니다.

문제 디렉터리 구성, `config.json`, 정답·오답 해답과 테스트 생성기 작성, 로컬/Docker 실행, 원격 검증·배포, 제출 결과 필터까지 처음부터 따라 하려면 [PPS CLI 학습 가이드](docs/commands.md)를 참고하세요.

## 인증 정보와 업데이트 상태

PPS 세션과 마지막 업데이트 확인 시각은 운영체제 사용자만 읽을 수 있는 별도 파일에 저장됩니다.

| 운영체제 | 인증 정보 | 업데이트 확인 상태 | `testlib.h` 캐시 |
| --- | --- | --- | --- |
| Linux / macOS | `~/.pps/config.json` | `~/.pps/update-check.json` | `~/.pps/PPS-ASSETS` |
| Windows | `%APPDATA%\PPS\config.json` | `%APPDATA%\PPS\update-check.json` | `%APPDATA%\PPS\PPS-ASSETS` |

`pps auth status`에서 현재 사용 중인 인증 파일 경로를 확인할 수 있습니다. 로그아웃하면 저장된 토큰과 사용자 정보가 제거됩니다. `update-check.json`에는 마지막 확인 시각만 기록되며 인증 정보는 포함되지 않습니다. 로컬 실행에 `testlib.h`가 필요하면 PPS CLI가 공개 PPS-ASSETS 저장소를 위 캐시 경로에 자동으로 내려받습니다.

## 자동 업데이트

릴리즈 빌드는 명령 실행 시 최대 하루 한 번 최신 GitHub Release를 확인합니다. 확인은 2초 안에 끝나지 않거나 네트워크 오류가 나면 조용히 건너뛰며, 실패한 시도도 기록해 24시간 동안 다시 확인하지 않습니다. 새 버전이 있으면 stderr에 다음 명령을 안내합니다.

```sh
pps update
```

`pps update`는 현재 운영체제와 CPU에 맞는 릴리즈를 내려받고 `checksums.txt`의 SHA-256을 검증한 뒤 실행 파일을 교체합니다. Windows에서는 실행 중인 파일 잠금 때문에 명령이 종료된 직후 교체가 완료됩니다. development 프로필인 `pps-dev`와 `go run .`에서는 자동 확인과 자체 업데이트가 비활성화됩니다.

`pps --version`은 네트워크 없이 현재 버전만 한 줄로 출력합니다. `pps -v`는 현재 버전, 최신 GitHub Release, 업데이트 필요 여부를 함께 확인하며 네트워크를 사용할 수 없으면 최신 버전을 `unknown`으로 표시합니다.

`v0.1.0`에는 `pps update`가 없으므로 설치 스크립트나 Homebrew로 `v0.2.0`을 한 번 설치해야 합니다. 그 이후 버전부터는 `pps update`를 사용할 수 있습니다. 자세한 내용은 [설치 상세 문서](docs/installation.md)를 참고하세요.

## 지원 및 보안

- 일반 질문과 문제 해결: [SUPPORT.md](SUPPORT.md)
- 버그 및 기능 제안: [GitHub Issues](https://github.com/PROJECT-PS/PPS-CLI/issues)
- 보안 취약점: [SECURITY.md](SECURITY.md)의 비공개 신고 절차
- 변경 사항: [CHANGELOG.md](CHANGELOG.md)

## 라이선스

배포 자료는 [MIT License](LICENSE)를 따릅니다. 포함된 의존성 고지는 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)를 참고하세요.
