# PPS CLI 학습 가이드

[English](commands.en.md)

이 문서는 PPS CLI를 처음 설치한 사람이 로컬 문제 패키지를 만들고, 문제 파일을 작성하고, 테스트한 뒤, 원격 저장소에서 검증·배포하고, 풀이를 제출하는 데까지 필요한 흐름을 한 번에 설명합니다.

명령 형식이 바뀔 수 있으므로 실제 설치된 버전의 `pps <명령> --help`가 최종 기준입니다. 잘못된 인자나 옵션을 전달하면 PPS CLI가 오류와 해당 명령의 도움말을 함께 표시합니다.

## 1. 먼저 알아둘 실행 원칙

PPS CLI에서 설정 질문을 사용할 수 있는 명령은 `pps auth`와 `pps create`입니다. `pps polygon`은 데이터가 있는 대상 경로를 교체하기 직전에만 y/n을 확인하며, 자동화에서는 `--force`로 승인 사실을 명시합니다. 그 밖의 명령은 질문을 띄우지 않고 위치 인자, 옵션, 문서화된 기본값만 사용합니다.

```sh
pps --help
pps create --help
pps run --help
pps list submit --help
```

공통 옵션 `--json`은 지원되는 조회·API 명령과 `create --local`의 결과를 기계가 읽기 쉬운 JSON으로 출력합니다. 자동화에서는 표 형식 출력을 파싱하지 말고 `--json`을 사용하세요.

이 문서에서 사용하는 표기법은 다음과 같습니다.

- `problem-id`, `course-id`, `lecture-id`, `contest-id`는 PPS 화면이나 목록 명령에서 확인한 숫자 ID입니다.
- `code-path`는 제출할 소스 파일 경로입니다.
- `problem-index`는 대회 안에서 A번이 `0`, B번이 `1`인 0부터 시작하는 인덱스입니다.
- `[repository-path]`처럼 대괄호로 표시된 위치 인자는 생략할 수 있습니다. 대괄호 자체는 입력하지 않습니다.

## 2. 설치와 상태 확인

설치 방법은 [설치 상세 문서](installation.md)를 참고하세요. 설치 후 다음 세 명령으로 실행 파일과 업데이트 상태를 확인합니다.

```sh
pps --version
pps -v
pps update
```

- `pps --version`: 네트워크 없이 현재 버전만 출력합니다.
- `pps -v`: 현재 버전, 최신 GitHub Release, 업데이트 필요 여부를 확인합니다.
- `pps update`: 플랫폼에 맞는 릴리즈를 내려받고 체크섬을 검증한 뒤 현재 실행 파일을 교체합니다.

릴리즈 빌드는 실제 명령을 실행할 때 최대 24시간에 한 번 새 버전을 확인합니다. 확인은 2초 후 중단되며 실패해도 원래 명령에는 영향을 주지 않습니다. 알림은 stderr로 출력되므로 `--json` stdout을 오염시키지 않습니다.

셸 자동 완성이 필요하면 사용하는 셸에 맞는 스크립트를 생성할 수 있습니다.

```sh
pps completion bash
pps completion zsh
pps completion fish
pps completion powershell
```

설치 방법은 `pps completion <shell> --help`의 안내를 따르세요.

## 3. 인증: 언제 필요하고 어떻게 관리하나

로컬 패키지 생성과 로컬 실행에는 PPS 인증이 필요하지 않습니다. 원격 저장소 생성, 원격 검증·배포, 코드 제출, 교육·대회의 계정별 데이터 조회에는 인증이 필요합니다. 공개 문제 조회나 공개 저장소 clone은 로그인 없이 가능한 경우가 있지만, 비공개 자원은 인증과 권한이 필요합니다.

```sh
pps auth
pps auth --username alice
pps auth status
pps auth status --json
pps auth logout
```

`pps auth`는 사용자 이름과 비밀번호를 안전하게 입력받습니다. `--username`을 주면 사용자 이름 질문만 생략하고 비밀번호는 항상 터미널에서 읽습니다. 로그인 토큰을 명령행 옵션이나 셸 기록에 남기는 방식은 지원하지 않습니다.

인증 파일은 운영체제 사용자만 읽을 수 있도록 저장됩니다.

| 운영체제 | 기본 경로 |
| --- | --- |
| Linux / macOS | `~/.pps/config.json` |
| Windows | `%APPDATA%\PPS\config.json` |

세션이 만료되면 `pps auth`를 다시 실행하세요. `pps auth logout`은 저장된 토큰과 사용자 정보를 제거합니다.

## 4. 가장 빠른 시작: 인증 없이 로컬 패키지 만들기

먼저 연습용 작업 디렉터리에서 로컬 패키지를 만듭니다.

```sh
mkdir pps-workbook
cd pps-workbook
pps create --local --name two-sum
cd two-sum
git log --oneline --decorate -1
```

`create --local`은 다음 작업만 수행합니다.

1. 현재 디렉터리 아래에 `<name>` 디렉터리를 만듭니다.
2. 그 안에 로컬 `.git` 저장소를 초기화합니다.
3. `main` 브랜치에 빈 초기 커밋 하나를 남깁니다.

PPS API나 GitHub에 문제 저장소를 만들지 않으며 인증도 확인하지 않습니다. `--description`, `--template`, `--account-id`, `--private`, `--public-solvable`은 원격 생성 전용이므로 `--local`과 함께 사용할 수 없습니다.

생성 직후에는 `.git`만 있습니다. 이제 직접 문제 파일을 추가하거나 이미 가진 문제 템플릿을 복사하면 됩니다. 나중에 일반 Git 원격을 연결하려면 다음처럼 실행합니다.

```sh
git remote add origin <git-url>
git push -u origin main
```

일반 Git 원격을 연결하는 것만으로 PPS 문제 ID가 자동 발급되지는 않습니다. PPS의 원격 검증·배포를 사용하려면 PPS에서 저장소를 등록하거나 생성하고, 필요하면 원격 명령에 `--problem-id`를 명시해야 합니다.

## 5. 원격 PPS 문제 저장소 만들기

원격 생성에는 PPS 인증과 연결된 GitHub 계정이 필요합니다.

```sh
pps auth
pps create --name two-sum --template stdio
```

터미널에서 옵션을 생략하면 `pps create`가 이름, 설명, 템플릿, 소유자, GitHub 공개 범위, 배포 후 문제 공개 범위를 물을 수 있습니다. 모든 값을 고정해 자동화하려면 옵션을 명시합니다.

```sh
pps create \
  --name two-sum \
  --description "Add two integers" \
  --template stdio \
  --account-id 123 \
  --private \
  --public-solvable=false
```

| 옵션 | 의미 |
| --- | --- |
| `--name`, `-n` | 영문자, 숫자, `_`, `-`로 이루어진 1~60자 저장소 이름 |
| `--description`, `-d` | 최대 200자의 원격 저장소 설명 |
| `--template`, `-t` | `none`, `stdio`, `subtask` 중 하나 |
| `--account-id` | 개인 또는 팀 소유자 계정 ID |
| `--private` | GitHub 저장소를 비공개로 생성 |
| `--public-solvable=false` | 배포 후 허용된 사용자만 제출 가능하게 설정 |
| `--local` | 원격 대신 로컬 Git 패키지만 생성 |

생성이 끝나면 출력된 문제 ID로 clone합니다. clone 방식은 질문하지 않으며 HTTPS가 기본입니다.

```sh
pps clone 123
pps clone alice/two-sum --ssh
pps clone 123 --gh --directory two-sum
```

- 기본: Git HTTPS URL로 clone
- `--ssh`, `-s`: SSH URL 사용
- `--gh`, `-g`: GitHub CLI의 `gh repo clone` 사용
- `--directory`, `-d`: clone할 로컬 디렉터리 이름 지정

PPS로 clone한 저장소에는 `.git/pps.json`이 기록됩니다. 이 메타데이터 덕분에 저장소 안에서는 `invocate`, `deploy`, 작업 목록, 상세 조회에서 문제 ID를 생략할 수 있습니다.

## 6. Polygon 패키지를 PPS로 변환하기

인증 없이 압축을 푼 Polygon 패키지나 ZIP을 바로 가져올 수 있습니다.

```sh
pps polygon ./polygon-package ./two-sum
pps polygon ./polygon-package.zip ./two-sum
```

CLI는 `problem.xml`을 읽어 PPS `config.json`을 만들고, TeX 지문을 UTF-8 Markdown으로 바꾸며, checker·validator·interactor·생성기·해답을 표준 디렉터리로 복사합니다. manual 테스트는 원본 바이트를 출력하는 Python 생성기로 바뀝니다. 이 명령은 PPS 인증을 확인하지 않습니다.

대상에 데이터가 있으면 전체 교체 전에 `[y/n]`을 묻습니다. `n`은 대상에 손대지 않고 종료합니다. 자동화에서 교체를 승인했다면 `--force`를 붙입니다.

```sh
pps polygon package.zip ./two-sum --force
pps --json polygon package.zip ./two-sum --force
```

변환은 임시 경로에서 완료되고 PPS 정적 검증을 통과한 다음 대상과 교체되므로, 변환 오류가 기존 대상을 반쯤 지우지 않습니다. 수식, 목록, 코드, 링크, 이미지, 표, 예제, `defs.toml` 사용자 명령, Windows 계열 인코딩과 ZIP 안전 제한까지 포함한 상세 동작은 [Polygon 변환 가이드](polygon.md)를 참고하세요.

## 7. 문제 패키지의 기본 구조

표준 입출력 문제는 보통 다음 구조를 사용합니다.

```text
two-sum/
├── config.json
├── statement/
│   ├── statement.md
│   └── statement_en.md
├── solution/
│   ├── solution.py
│   └── solution_wa.py
├── generator/
│   └── generator.py
├── checker/
│   └── checker.cc
├── validator/       # 선택 사항
│   └── validator.cc
└── interactor/      # interactive/two_step 문제에서 사용
    └── interactor.cc
```

각 디렉터리의 역할은 다음과 같습니다.

| 경로 | 역할 |
| --- | --- |
| `config.json` | 제한, 언어, 파일 이름, 생성 스크립트, 정답/오답 기대 결과를 연결하는 중심 설정 |
| `statement/` | Markdown 문제 지문. 여러 언어를 각각 등록할 수 있음 |
| `solution/` | 정답 코드와 의도적으로 틀리거나 느린 검증용 코드 |
| `generator/` | 테스트 입력을 stdout으로 생성하는 프로그램 |
| `checker/` | 참가자 출력과 기준 출력을 비교하는 프로그램 |
| `validator/` | 생성된 입력이 제약 조건을 만족하는지 검사하는 선택 프로그램 |
| `interactor/` | 상호작용 또는 2단계 문제의 실행 프로토콜 담당 |

### `config.json`에서 꼭 이해할 항목

아래 예시는 구조를 설명하기 위한 축약 예시입니다. 파일 이름은 실제 디렉터리의 파일과 정확히 일치해야 합니다.

```json
{
  "problem_title": "A + B",
  "problem_type": "stdio",
  "checker": "checker.cc",
  "checker_language": "cpp17",
  "validator": "",
  "validator_language": "",
  "interactor": "",
  "interactor_language": "",
  "subtask": false,
  "limits": {
    "time": 1000,
    "memory": 268435456,
    "factor": {}
  },
  "enable_language": ["cpp17", "py3"],
  "statements": [
    {"name": "statement.md", "label": "한국어"}
  ],
  "solutions": [
    {"name": "solution.py", "language": "py3", "type": "MCS"},
    {"name": "solution_wa.py", "language": "py3", "type": "WA"}
  ],
  "generators": [
    {"name": "generator.py", "language": "py3", "alias": "gen"}
  ],
  "subtask_group": [],
  "genscript": [
    {
      "script": "gen 1 2",
      "subtask_group": "",
      "is_example": true,
      "only_deploy": false
    },
    {
      "script": "gen -5 8",
      "subtask_group": "",
      "is_example": false,
      "only_deploy": false
    }
  ],
  "manual_example": []
}
```

핵심 규칙은 다음과 같습니다.

- `problem_type`: `stdio`, `interactive`, `two_step` 중 하나입니다.
- `limits.time`: 밀리초 단위이며 100~10000 범위입니다.
- `limits.memory`: 바이트 단위이며 4 MiB~1024 MiB 범위입니다.
- `statements`: 1~10개가 필요하며 각 `name` 파일이 `statement/`에 있어야 합니다.
- `solutions`: 실행 가능한 해답이 1~30개 필요하고, 기준 출력을 만드는 `MCS`가 정확히 하나 있어야 합니다.
- 해답 `type`: `MCS`, `AC`, `WA`, `TLE`, `MLE`, `FAIL`을 사용합니다. 여러 결과를 허용하려면 `AC/WA`처럼 `/`로 연결할 수 있지만 `MCS`는 다른 값과 결합할 수 없습니다.
- `generators`: 실행 가능한 생성기가 1~30개 필요합니다. `alias`는 `genscript[].script`의 첫 단어로 사용합니다.
- `genscript`: 1~200개의 테스트를 정의합니다. `script`의 첫 단어는 생성기 alias, 나머지는 생성기에 전달할 인자입니다.
- 예제는 `genscript[].is_example`과 `manual_example`을 합쳐 1~20개가 필요합니다.
- 서브태스크를 켜면 각 그룹의 점수, 의존성, 테스트 소속을 모두 정의해야 하며 의존성 순환은 허용되지 않습니다.

지원 언어 코드는 `c99`, `c11`, `cpp11`, `cpp17`, `cpp20`, `py3`, `pypy3`, `java8`입니다.

## 8. 문제를 만드는 실전 순서

처음 문제를 만들 때는 다음 순서가 디버깅하기 쉽습니다.

1. `statement/statement.md`에 입력, 출력, 제한, 예제를 작성합니다.
2. `solution/`에 검증된 정답을 만들고 `type: MCS`로 등록합니다.
3. `generator/`에 작은 고정 예제부터 출력하는 생성기를 만들고 alias를 등록합니다.
4. `checker/`에 출력 비교기를 둡니다. C++ checker가 `testlib.h`를 사용하면 CLI가 공개 PPS-ASSETS를 자동으로 준비할 수 있습니다.
5. `config.json`의 파일 이름, 언어, 제한, `genscript`를 연결합니다.
6. 의도적으로 틀린 `WA`, 느린 `TLE` 등의 해답을 추가해 테스트가 실제로 잡아내는지 확인합니다.
7. `pps run .`이 통과한 뒤 원격 `invocate`를 요청합니다.

예를 들어 Python 생성기는 전달받은 두 값을 그대로 테스트 입력으로 만들 수 있습니다.

```python
import sys

print(sys.argv[1], sys.argv[2])
```

정답과 오답을 함께 등록하면 CLI는 각 테스트에서 관측한 결과가 `solutions[].type`의 기대 결과와 맞는지 검사합니다. 정답만 실행해 보는 것보다, 테스트 데이터가 대표 오답을 실제로 깨뜨리는지까지 확인하는 편이 훨씬 안전합니다.

## 9. 로컬 검증과 실행

로컬 실행은 인증 상태를 확인하지 않습니다.

```sh
pps run .
pps run ./two-sum
pps run ./two-sum --docker
```

기본은 현재 컴퓨터에서 직접 실행하는 native 모드입니다. 실행 모드를 묻지 않으므로 Docker를 원하면 반드시 `--docker`를 붙입니다.

| 옵션 | 의미 |
| --- | --- |
| `--docker` | 네트워크가 차단된 PPS CLI runner 컨테이너에서 실행 |
| `--docker-image <image>` | `--docker`에서 사용할 이미지 변경 |
| `--testlib-dir <path>` | 자동 탐색·캐시 대신 지정한 `testlib.h` 디렉터리 사용 |
| `--keep-work` | 생성 입력, 기준 출력, 빌드 결과가 있는 임시 작업 디렉터리를 보존 |

native 모드는 저장소의 생성기, 해답, checker, validator, interactor를 현재 사용자 권한으로 직접 실행하며 보안 샌드박스가 없습니다. 신뢰할 수 없는 저장소에는 사용하지 마세요. Docker 모드는 `--network=none`과 권한 제한을 사용하며, runner 이미지에 `testlib.h`가 포함되어 있습니다.

native 모드에서 C++ 도구가 필요하면 시스템에 `gcc`/`g++`가 있어야 하고, Python이나 Java 파일을 등록했다면 해당 런타임도 필요합니다. `testlib.h`가 없으면 PPS CLI가 공개 PPS-ASSETS를 다음 기본 캐시에 clone합니다.

| 운영체제 | 기본 PPS-ASSETS 캐시 |
| --- | --- |
| Linux / macOS | `~/.pps/PPS-ASSETS` |
| Windows | `%APPDATA%\PPS\PPS-ASSETS` |

환경 변수 `PPS_TESTLIB_DIR` 또는 `--testlib-dir`로 다른 위치를 지정할 수 있습니다.

`pps run`은 대략 다음 순서로 동작합니다.

1. `config.json` 형식과 파일 구성을 검증합니다.
2. checker, validator, interactor, 생성기, 해답을 빌드합니다.
3. `genscript`의 각 입력을 생성하고 validator를 실행합니다.
4. 유일한 MCS로 기준 출력을 만듭니다.
5. 모든 등록 해답을 실행하고 checker로 결과를 판정합니다.
6. 실제 결과가 각 해답의 기대 `type`과 맞는지 확인합니다.

실패를 조사할 때는 `--keep-work`를 붙여 생성된 입력과 출력을 직접 확인하세요.

## 10. Git 작업과 동기화

PPS CLI는 자주 쓰는 Git 명령을 그대로 전달합니다.

```sh
pps pull --rebase
pps commit -m "add overflow cases"
pps push --set-upstream origin main
```

`pull`, `commit`, `push` 뒤의 인자는 각각 `git pull`, `git commit`, `git push`로 전달됩니다. `pps pull --help`처럼 도움말만 요청하면 PPS용 짧은 설명과 예제를 보여줍니다.

한 번에 동기화하려면 다음 명령을 사용합니다.

```sh
pps sync --message "add boundary cases"
pps sync --remote origin --branch main
pps sync --no-add --message "commit staged files only"
```

`pps sync`는 pull → stage → commit → push 순서로 실행합니다. 변경이 없으면 commit만 건너뜁니다.

- `--message`, `-m`: 커밋 메시지. 생략하면 CLI가 시각을 포함한 메시지를 만듭니다.
- `--remote`: pull/push할 Git remote입니다.
- `--branch`: remote와 함께 사용할 branch입니다. `--remote` 없이 단독 사용할 수 없습니다.
- `--no-add`: `git add -A`를 건너뛰고 이미 stage된 변경만 commit합니다.

`create --local` 직후처럼 remote가 없는 저장소에서는 `pps sync`가 실패합니다. 먼저 remote를 연결하거나 일반 `pps commit`으로 로컬 기록만 남기세요.

## 11. 원격 검증과 배포

로컬 실행이 통과했다면 원격 PPS 환경에서 다시 검증합니다.

```sh
pps invocate
pps list invocate
pps detail invocate 456
pps deploy
pps list deploy
```

`invocate`와 `deploy`는 기본적으로 먼저 `pps sync`를 실행합니다. 즉, 로컬 변경을 원격 Git 저장소에 반영한 뒤 원격의 `config.json`과 파일 트리를 검증하고 비동기 작업을 큐에 넣습니다.

```sh
pps invocate --message "test larger random cases"
pps invocate --problem-id 123 --no-sync
pps deploy 123 --no-sync
```

- 위치 인자 또는 `--problem-id`: 대상 문제 ID. PPS clone 안에서는 생략할 수 있습니다.
- `--message`, `-m`: 자동 sync의 커밋 메시지입니다.
- `--no-sync`: 원하는 커밋이 이미 원격에 있을 때만 사용합니다.

작업 목록은 0부터 시작하는 페이지를 사용합니다.

```sh
pps list invocate 123 --page 0
pps list deploy --problem-id 123 --page 1
```

`pps detail invocate <job-id>`는 invocation 상세 결과를 JSON으로 출력합니다. 현재 deploy 상세 API는 없으므로 `detail deploy`는 지원하지 않습니다.

원격 검증 성공 후에만 배포를 진행하세요. 배포는 실제 사용자가 볼 문제와 채점 데이터를 갱신하는 단계입니다.

## 12. 문제 찾기와 읽기

```sh
pps list problem
pps list problem --search "two sum" --owner alice --verified
pps list problem --page 2 --json
pps search two sum
pps search geometry --owner alice --verified --page 1
```

목록과 검색 명령은 필터 메뉴를 띄우지 않습니다.

- `--search`, `-q`: 저장소 이름 또는 문제 제목 검색
- `--owner`, `-o`: 소유자 nickname 정확히 일치
- `--verified`: PPS 검증 완료 문제만 표시
- `--page`, `-p`: 0부터 시작하는 페이지

배포된 문제를 터미널에서 읽을 수 있습니다.

```sh
pps problem 123
pps problem 123 --statement English
pps problem 123 --json
```

`--statement`를 생략하면 사용 가능한 지문을 모두 출력합니다. 특정 지문만 필요하면 표시된 label과 정확히 같은 문자열을 전달하세요. 지문 선택 질문은 나타나지 않습니다.

## 13. 풀이 제출

### 일반 문제

```sh
pps submit 123 solution.cpp
pps submit 123 solution --language cpp20
```

확장자가 `.c`, `.cc`/`.cpp`/`.cxx`, `.py`, `.java`이면 언어를 각각 추론합니다. 확장자가 없거나 기본 추론과 다른 언어를 쓰려면 `--language`, `-l`에 언어 코드를 지정합니다. 제출 언어 선택 질문은 나타나지 않습니다.

### PPS Education

```sh
pps edu_submit 10 solution.py --lecture-id 3 --problem-id 123
```

`course-id`와 `code-path`는 위치 인자이고 `--lecture-id`, `--problem-id`는 필수 옵션입니다. 강좌 문제 선택 메뉴는 나타나지 않습니다.

### PPS Contest

```sh
pps contest_submit 20 solution.cpp --problem-index 0
```

`contest-id`와 `code-path`는 위치 인자이고 `--problem-index`는 필수 옵션입니다. 문제 A는 `0`, B는 `1`입니다. 대회 문제 선택 메뉴는 나타나지 않습니다.

## 14. 제출 결과 목록과 문자열 필터

```sh
pps list submit 123
pps list submit 123 --result ac --nickname alice
pps list edu_submit 10 --lecture-id 3 --problem-id 123 --result wa
pps list contest_submit 20 --problem-index 0 --result tle
```

`--result`는 내부 채점 숫자가 아니라 다음 문자열을 받습니다. 대소문자를 구분하지 않습니다.

| 값 | 의미 |
| --- | --- |
| `all` | 모든 결과 |
| `ac` | 정답 |
| `wrong` | 정답이 아닌 모든 결과 |
| `wa` | 오답 |
| `partial` | 부분 점수 |
| `tle` | 시간 초과 |
| `mle` | 메모리 초과 |
| `re` | 런타임 오류 |
| `segfault` | 세그멘테이션 오류 |
| `ce` | 컴파일 오류 |
| `ole` | 출력 제한 초과 |

PPS CLI는 이 문자열을 API가 요구하는 내부 값으로 변환합니다. 내부 숫자는 사용자 옵션이나 도움말에 노출하지 않으며 숫자를 `--result`에 직접 입력할 수 없습니다.

목록별 추가 옵션은 다음과 같습니다.

- 일반 목록: `--nickname`으로 사용자 nickname, `--id`로 페이지 이동 기준 제출 ID를 지정합니다.
- Education 목록: `--lecture-id`, `--problem-id`를 생략하면 강좌 전체를 조회합니다.
- Contest 목록: `--problem-index`를 생략하면 대회 전체 문제를 조회합니다.
- `--json`: 상태 배열과 이전/다음 탐색 ID를 JSON으로 출력합니다.

## 15. 인증 없는 로컬 학습 코스

다음 체크리스트를 순서대로 수행하면 서버 계정 없이도 문제 제작의 핵심을 연습할 수 있습니다.

- [ ] `pps create --local --name two-sum`으로 로컬 Git 패키지를 만든다.
- [ ] `statement/`, `solution/`, `generator/`, `checker/`와 `config.json`을 작성한다.
- [ ] MCS 정답 하나와 WA 오답 하나를 등록한다.
- [ ] 작은 예제와 경계값을 `genscript`에 추가한다.
- [ ] `pps run .`으로 정답은 통과하고 오답은 WA가 되는지 확인한다.
- [ ] `pps run . --docker`로 격리 실행에서도 같은 결과인지 확인한다.
- [ ] `pps run . --keep-work`로 실제 생성 입력과 기준 출력을 살펴본다.
- [ ] `pps commit -m "build first PPS problem"`으로 변경을 기록한다.

스스로 확인할 질문도 함께 사용해 보세요.

1. MCS 해답을 제거하면 검증이 어떤 오류로 중단되는가?
2. `genscript`의 alias를 존재하지 않는 값으로 바꾸면 어느 단계에서 발견되는가?
3. WA 해답이 모든 테스트에서 AC가 된다면 어떤 경계값이 빠졌는가?
4. `--keep-work`에 남은 입력과 출력 중 예상과 다른 첫 테스트는 무엇인가?
5. native와 Docker 실행 결과가 다르다면 어떤 컴파일러·런타임 차이가 있는가?

## 16. 전체 명령 빠른 참조

| 목적 | 명령 |
| --- | --- |
| 로그인/상태/로그아웃 | `pps auth`, `pps auth status`, `pps auth logout` |
| 로컬 Git 패키지 생성 | `pps create --local --name <name>` |
| Polygon 디렉터리/ZIP 변환 | `pps polygon <source> <destination>` |
| 원격 PPS 저장소 생성 | `pps create [options]` |
| 문제 저장소 clone | `pps clone <problem-id 또는 owner/name>` |
| Git 래퍼 | `pps pull`, `pps commit`, `pps push`, `pps sync` |
| 로컬 문제 실행 | `pps run [repository-path]` |
| 원격 검증/배포 | `pps invocate`, `pps deploy` |
| 문제 목록/검색/읽기 | `pps list problem`, `pps search`, `pps problem` |
| 비동기 작업 목록/상세 | `pps list invocate`, `pps list deploy`, `pps detail invocate` |
| 일반 제출/목록 | `pps submit`, `pps list submit` |
| Education 제출/목록 | `pps edu_submit`, `pps list edu_submit` |
| Contest 제출/목록 | `pps contest_submit`, `pps list contest_submit` |
| 버전/업데이트 | `pps --version`, `pps -v`, `pps update` |
| 셸 자동 완성 | `pps completion <shell>` |

## 17. 자주 만나는 문제

### `not authenticated` 또는 세션 만료

```sh
pps auth status
pps auth
```

`create --local`과 `run`은 이 오류 없이 동작해야 합니다. 이 두 명령에서 인증 오류가 보인다면 설치 버전을 확인하고 업데이트하세요.

### GitHub 계정 연결 필요

원격 `pps create`, `invocate`, `deploy`는 PPS 설정에서 연결한 GitHub 계정이 필요합니다. CLI가 출력한 설정 URL에서 연결한 뒤 다시 실행하세요.

### 문제 ID를 추론할 수 없음

PPS clone이 아니거나 `.git/pps.json`이 없는 저장소에서는 ID를 명시합니다.

```sh
pps invocate --problem-id 123
pps list invocate --problem-id 123
pps detail invocate 456 --problem-id 123
```

### `testlib.h`를 찾을 수 없음

Git과 네트워크를 사용할 수 있으면 CLI가 자동 캐시를 만듭니다. 오프라인이거나 별도 사본을 쓰려면 다음처럼 지정합니다.

```sh
pps run . --testlib-dir /path/to/PPS-ASSETS
PPS_TESTLIB_DIR=/path/to/PPS-ASSETS pps run .
```

### 로컬 실행이 위험하다는 경고

native 모드는 문제 코드를 직접 실행합니다. 저장소를 신뢰할 수 없다면 `pps run . --docker`를 사용하세요.

### 자동화가 안정적으로 동작해야 함

`auth`와 `create`를 제외한 일반 명령은 입력 메뉴를 띄우지 않습니다. `polygon`의 기존 대상 교체는 안전을 위해 y/n을 확인하므로 자동화에서는 검증된 경로와 `--force`를 함께 사용합니다. 필요한 ID와 필터를 옵션으로 명시하고, 구조화된 결과에는 `--json`을 사용하세요.
