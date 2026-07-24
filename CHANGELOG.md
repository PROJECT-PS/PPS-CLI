# 변경 기록

이 문서는 사용자에게 영향을 주는 PPS CLI 변경 사항을 기록합니다. 버전은 [Semantic Versioning](https://semver.org/lang/ko/)을 따릅니다.

## [v0.8.0] - 2026-07-25

### 추가

- `pps --json run`이 native와 Docker 모드 모두에서 원격 invocate와 동일한 솔루션×테스트 케이스 상세 스키마를 제공합니다. 입력, 정답 출력, 사용자 출력, checker 출력, 판정, 실행 시간, 메모리를 포함합니다.

### 변경

- 로컬 실행이 실패해도 생성된 상세 결과와 오류를 JSON으로 출력하여 PPS Code 같은 클라이언트에서 실패 케이스를 확인할 수 있습니다.

## [v0.7.0] - 2026-07-24

### 추가

- 현재 로컬 작업과 GitHub 원격을 `clean`, `server_ahead`, `local_ahead`, `diverged`, `conflicted`로 분류하고 변경 파일·ahead 수·충돌 경로를 JSON으로 제공하는 `pps repo status`
- `.pps/repository.json`의 연결 캐시를 조회·재탐색하는 `pps repo info`
- Papyrus의 저장소 설명, GitHub 공개/비공개, 배포 후 공개 제출 허용 여부를 조회·변경하는 `pps repo settings`

### 변경

- `pps clone`과 `pps remote`가 연결 정보를 `.pps/repository.json`에 기록하고, 기존 `.git/pps.json`은 자동 이전
- 캐시가 없거나 오래된 경우 Git remote에서 원본 PPS 저장소를 안전하게 탐색하며, `.pps`와 `.pps-code`는 로컬 Git 제외 목록에 자동 등록
- `pps sync`가 로컬 변경을 먼저 커밋한 뒤 pull하여 표준 3-way 충돌 정보를 만들고, 해결 후 push하도록 순서 개선
- Papyrus 원본 문제 형식 `twostep`을 그대로 허용하면서 기존 `two_step` 패키지와의 실행 호환성 유지

### 수정

- 앞에 공백이 있는 Git porcelain 상태를 잘못 잘라 `config.json`을 `onfig.json`으로 보고하던 동기화 파일 분석 오류 수정

## [v0.6.0] - 2026-07-21

### 추가

- `pps clone`과 동일한 문제 ID 또는 `nickname/repository` 형식으로 기존 Git 저장소를 PPS 문제에 연결하는 `pps remote`
- HTTPS/SSH URL 선택, remote 이름 지정, 충돌 시 명시적 `--force`, JSON 결과와 `.git/pps.json` 자동 기록

### 변경

- macOS/Linux 직접 설치는 PATH의 표준 위치인 `/usr/local/bin`을 기본으로 사용하고 필요할 때 `sudo` 요청
- Windows 설치 직후 현재 PowerShell 세션에서도 `pps`를 바로 찾도록 PATH 즉시 반영

## [v0.5.0] - 2026-07-20

### 추가

- Polygon 디렉터리 또는 ZIP을 인증 없이 PPS 패키지로 변환하는 `pps polygon <source> <destination>`
- 수식, 구역, 예제, 중첩 목록, 코드, 링크, 이미지, 표, 인용과 `defs.toml` 사용자 명령을 처리하는 Polygon TeX→Markdown 변환기
- UTF-8/UTF-16과 Windows·동아시아 legacy 인코딩 정규화, ZIP 경로 탈출·특수 파일·압축 폭탄 방어
- Polygon 변환 준비부터 `pps run` 검증까지 설명하는 한국어·영어 가이드

### 변경

- 기존 대상은 y/n 확인 뒤 전체 교체하며 `n`은 원본을 보존; 자동화에는 명시적 `--force` 제공
- manual 테스트를 원본 바이트 그대로 출력하는 분할 가능한 Python 생성기로 변환
- 임시 경로에서 변환과 PPS 정적 검증을 끝낸 뒤 대상을 교체하고 실패 시 기존 데이터 복원

## [v0.4.0] - 2026-07-20

### 추가

- 인증 없이 빈 초기 커밋이 있는 로컬 Git 패키지를 만드는 `pps create --local`
- 문제 작성부터 로컬 테스트, 원격 검증·배포, 제출까지 다루는 PPS CLI 학습 가이드

### 변경

- `pps auth`와 `pps create` 외 명령은 선택 메뉴 없이 옵션과 기본값으로만 실행
- 제출 목록의 `--result`는 내부 숫자 대신 `all`, `ac`, `wa`, `tle` 같은 문자열 필터 사용
- 명령별 도움말에 비대화형 기본 동작, 옵션 의미, 복사 가능한 예제 보강
- `pps run`과 `pps create --local`이 인증 없이 동작함을 명시하고 테스트

## [v0.3.1] - 2026-07-20

### 추가

- 로컬 실행에 필요한 `testlib.h`가 없을 때 프로필별 설정 폴더에 PPS-ASSETS 자동 캐시
- PPS CLI runner Docker 이미지의 Linux AMD64 및 ARM64 지원

## [v0.3.0] - 2026-07-20

### 추가

- 웹과 같은 생성·제출·결과 필터 및 동적 교육/대회 문제 선택 메뉴
- `pps -v`의 현재 버전·최신 릴리즈·업데이트 상태 확인

### 변경

- 사용자 예제를 공개 문제 `#1` **a + b** 기준으로 통일
- `pps --version`은 네트워크 없는 한 줄 버전 출력으로 유지

## [v0.2.0] - 2026-07-19

### 추가

- 명령 실행 시 24시간에 한 번 최신 릴리즈 확인 및 업데이트 안내
- `pps update`를 통한 플랫폼별 SHA-256 검증 자체 업데이트
- Windows 실행 파일 잠금을 고려한 명령 종료 후 교체

### 변경

- 네트워크 오류와 타임아웃을 사용자 명령에 영향을 주지 않고 무시
- 실패한 확인도 기록해 24시간 동안 재확인 방지
- development 프로필에서 업데이트 확인과 자체 업데이트 비활성화
- 설치·배포·보안 지원 문서를 실제 릴리즈 상태에 맞게 갱신

## [v0.1.0] - 2026-07-19

### 추가

- Windows, macOS, Linux의 AMD64 및 ARM64 릴리즈 기반 구성
- 문제 저장소 생성, 검증, 실행, 배포 및 제출 명령
- 운영체제별 안전한 인증 설정 저장
- 직접 설치 스크립트와 패키지 관리자 메타데이터
