# PPS CLI

[English](README.en.md) · [명령어 가이드](docs/commands.md) · [Polygon 변환 가이드](docs/polygon.md)

PPS에서 문제를 만들고, 테스트하고, 동기화하고, 풀이를 제출하는 공식 명령줄 도구입니다. Windows, macOS, Linux의 AMD64/ARM64 환경을 지원합니다.

## 설치

macOS와 Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.sh | sh
```

기본적으로 PATH에 포함된 `/usr/local/bin`에 설치하며, 필요한 경우 설치 중 `sudo` 권한을 요청합니다. 설치가 끝나면 같은 터미널에서 바로 `pps`를 실행할 수 있습니다.

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

사용자 PATH와 현재 PowerShell 세션에 자동으로 등록되므로 새 창을 열지 않고 바로 실행할 수 있습니다.

설치를 확인합니다.

```sh
pps --version
```

Homebrew, Debian 패키지, 수동 설치가 필요하다면 [설치 가이드](docs/installation.md)를 참고하세요.

## 빠른 시작

### 0. 로그인

```sh
pps auth
# 로그인 후 PPS 웹 설정에서 GitHub 계정을 연동해야 create 등을 사용할 수 있습니다.
```

### 1. 문제 생성, 편집, 테스트, 동기화

```sh
pps create
pps clone <problem-id>
cd <cloned-directory>

# statement, solution, generator, checker, config.json 등을 편집합니다.
pps run .
# PPS Code 같은 도구에서 사용할 구조화된 상세 결과
pps --json run .
pps repo status
pps sync -m "update problem"
```

`pps create`가 출력한 문제 ID를 `pps clone`에 사용하세요. 이미 가진 로컬 Git 저장소를 연결하려면 저장소 안에서 `pps remote <problem-id>`를 실행하면 됩니다. `pps run`은 로컬 테스트이므로 로그인하지 않은 상태에서도 실행할 수 있습니다. `pps repo status`는 로컬 작업과 GitHub 서버를 비교해 동기화 상태와 충돌 가능성을 보여줍니다.

### 2. Polygon 패키지 변환과 동기화

```sh
pps polygon ./polygon-package.zip ./converted-problem
cd ./converted-problem

# 기존 PPS 문제에 연결하고 원격 브랜치 이력을 확인한 뒤 동기화합니다.
git init -b main
pps remote <problem-id>
pps sync --remote origin --branch main -m "import Polygon package"
```

압축 파일과 압축 해제된 디렉터리를 모두 입력으로 사용할 수 있습니다. 변환 규칙과 Git 저장소 준비 방법은 [Polygon 변환 가이드](docs/polygon.md)를 확인하세요.

### 3. 원격 검증과 풀이 제출

```sh
cd <problem-directory>
pps invocate

# 검증과 배포가 끝난 문제에 풀이 파일을 제출합니다.
pps submit <problem-id> solution.cpp
```

## 주요 명령

| 명령 | 용도 |
| --- | --- |
| `pps auth` | 로그인, 로그아웃, 인증 상태 확인 |
| `pps create`, `pps clone`, `pps remote` | 문제 생성, 복제, 기존 Git 저장소 연결 |
| `pps repo info`, `pps repo status`, `pps repo settings` | 저장소 연결·동기화 상태·공개 범위 관리 |
| `pps run` | 로컬 솔루션 빌드와 테스트 |
| `pps polygon` | Polygon 패키지를 PPS 형식으로 변환 |
| `pps sync` | Git 변경 사항 커밋, 가져오기, 푸시 |
| `pps invocate`, `pps deploy` | 원격 검증과 문제 배포 |
| `pps submit`, `pps list` | 풀이 제출과 제출 결과 조회 |
| `pps update` | CLI 업데이트 |

각 명령의 모든 옵션은 도움말에서 확인할 수 있습니다.

```sh
pps --help
pps <command> --help
```

전체 작업 흐름과 예제는 [명령어 가이드](docs/commands.md)에 정리되어 있습니다.

## 지원

- 버그와 기능 제안: [GitHub Issues](https://github.com/PROJECT-PS/PPS-CLI/issues)
- 사용 중 문제 해결: [SUPPORT.md](SUPPORT.md)
- 버전별 변경 사항: [CHANGELOG.md](CHANGELOG.md)
- 보안 문제 제보: [SECURITY.md](SECURITY.md)
- 라이선스: [MIT License](LICENSE)
