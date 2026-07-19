# 명령어 안내

[English](commands.en.md)

모든 명령은 입력이 잘못되면 해당 명령의 도움말을 함께 표시합니다. `--json`은 API 중심 명령의 출력을 자동화에 적합한 JSON으로 바꿉니다.

## 버전 확인과 업데이트

```sh
pps --version
pps update
```

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
pps create --name two-sum --template stdio
pps clone 107
pps clone nickname/two-sum
pps list problem
pps search two sum
```

`clone`으로 받은 저장소는 문제 ID를 `.git/pps.json`에 기록하므로 이후 명령에서 ID를 생략할 수 있습니다.

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

기본 로컬 실행에는 보안 샌드박스가 없으므로 신뢰하는 문제 저장소만 실행하세요. `--docker`는 네트워크가 차단된 PPS 도구 체인 컨테이너를 사용합니다.

## 제출

```sh
pps submit 107 solution.cpp --language cpp17
pps edu_submit 10 3 107 solution.py --language py3
pps contest_submit 20 0 Main.java --language java8

pps list submit 107
pps list edu_submit 10 --lecture-id 3 --problem-id 107
pps list contest_submit 20 --problem-index 0
```

지원 플래그와 최신 형식은 언제나 `pps <command> --help`를 기준으로 확인하세요.
