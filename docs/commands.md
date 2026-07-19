# 명령어 안내

[English](commands.en.md)

모든 명령은 입력이 잘못되면 해당 명령의 도움말을 함께 표시합니다. `--json`은 API 중심 명령의 출력을 자동화에 적합한 JSON으로 바꿉니다.

## 버전 확인과 업데이트

```sh
pps --version
pps -v
pps --json -v
pps update
```

`pps --version`은 자동화에 적합하도록 네트워크 요청 없이 현재 버전만 한 줄로 출력합니다. `pps -v`는 현재 버전과 최신 GitHub Release, 업데이트 필요 여부를 출력합니다. 명시적인 최신 버전 확인은 최대 2초 동안 네트워크를 사용하며, 확인할 수 없으면 최신 버전과 상태를 `unknown`으로 표시하되 현재 버전 확인은 성공합니다.

릴리즈 빌드는 실제 명령을 실행할 때 최대 24시간에 한 번 새 릴리즈를 확인하고, 새 버전이 있으면 `pps update`를 안내합니다. 확인 요청은 2초 후 중단되며 성공·실패와 관계없이 다음 확인까지 24시간을 기다립니다. 알림은 stderr에 출력되므로 `--json`의 stdout을 변경하지 않습니다.

`pps update`는 플랫폼별 압축 파일과 `checksums.txt`를 받아 SHA-256 검증 후 현재 실행 파일을 교체합니다. development 프로필에서는 확인과 업데이트가 모두 비활성화됩니다.

## 인증

```sh
pps auth
pps auth status
pps auth logout
```

## 문제 저장소

```sh
pps create
pps problem 1
pps clone 1
pps clone nickname/two-sum
pps list problem
pps search two sum
```

`pps create`는 템플릿, 소유자, GitHub 저장소 공개 범위, 배포 후 문제 공개 범위를 번호 메뉴로 묻습니다. `--name`, `--template`, `--account-id`, `--private`, `--public-solvable` 플래그를 지정하면 해당 질문을 건너뛸 수 있습니다.

예제의 `#1`은 두 정수의 합을 출력하는 공개 문제 **a + b**입니다(1초, 128 MiB, 예제 `1 2` → `3`). `pps problem 1`은 지문 언어가 여러 개이면 표시할 지문을 선택합니다. `clone`은 HTTPS, SSH, GitHub CLI 중 하나를 선택하며, 받은 저장소에 문제 ID를 `.git/pps.json`으로 기록하므로 이후 명령에서 ID를 생략할 수 있습니다.

## Git 동기화

```sh
pps pull
pps commit -m "add edge cases"
pps push
pps sync -m "refresh tests"
```

`sync`는 pull, stage, commit, push를 순서대로 실행합니다.

## 검증과 배포

```sh
pps invocate
pps deploy
pps list invocate
pps list deploy
pps detail invocate 456
```

원격 검증과 배포는 기본적으로 먼저 `pps sync`를 수행합니다. `--no-sync`로 건너뛸 수 있습니다. 배포 상세 API가 없으므로 `detail deploy`는 제공하지 않습니다.

## 로컬 실행

```sh
pps run .
pps run --docker
```

기본 로컬 실행에는 보안 샌드박스가 없으므로 신뢰하는 문제 저장소만 실행하세요. `--docker`는 네트워크가 차단된 PPS CLI runner 컨테이너를 사용합니다.

터미널에서는 로컬 직접 실행과 Docker 중 하나를 선택합니다. `--docker` 또는 `--docker=false`를 명시하면 선택 질문을 건너뜁니다.

## 제출

```sh
pps submit 1 solution.cpp
pps edu_submit 10 solution.py
pps contest_submit 20 Main.java

pps list submit 1
pps list edu_submit 10 --lecture-id 3 --problem-id 1
pps list contest_submit 20 --problem-index 0
```

일반 제출은 8개 지원 언어를 선택합니다. 파일 확장자로 추론한 언어가 기본 선택되며 `--language cpp17`처럼 명시하면 질문을 건너뜁니다. 교육 제출은 강의 ID와 문제 ID를 생략하면 강좌의 공개 문제를, 대회 제출은 문제 인덱스를 생략하면 진행 중인 대회 문제를 번호 메뉴로 선택합니다. 자동화에서는 기존처럼 모든 ID와 `--language`를 명시할 수 있습니다.

세 제출 목록은 웹과 같은 11개 결과 필터를 제공합니다. 교육·대회 제출 목록은 문제 필터도 함께 선택하며, 관련 플래그를 명시하면 메뉴 없이 실행됩니다.

지원 플래그와 최신 형식은 언제나 `pps <command> --help`를 기준으로 확인하세요.
