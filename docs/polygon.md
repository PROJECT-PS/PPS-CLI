# Polygon 패키지를 PPS로 옮기기

[English](polygon.en.md)

`pps polygon`은 Polygon 문제 패키지를 로컬 PPS 문제 패키지로 변환합니다. PPS 로그인이나 네트워크 연결은 필요하지 않으며, 압축을 푼 디렉터리와 `.zip` 파일을 모두 입력으로 받을 수 있습니다.

```sh
pps polygon <Polygon 원본> <PPS 대상>
```

가장 흔한 사용 예시는 다음과 같습니다.

```sh
# 압축을 푼 패키지
pps polygon ./polygon-package ./two-sum

# Polygon에서 받은 ZIP을 바로 변환
pps polygon ./polygon-package.zip ./two-sum
```

변환이 끝나면 `./two-sum`에 `config.json`, 지문, 해답, 생성기, checker 등이 생성됩니다. 원본 Polygon 패키지는 수정하지 않습니다.

## 1. 준비할 Polygon 패키지

입력에는 최소한 다음 자료가 있어야 합니다.

- 패키지 설명 파일 `problem.xml`
- `problem.xml`이 가리키는 TeX 지문
- checker와 기준 해답
- 생성 테스트에 사용하는 executable 원본
- manual 테스트가 있다면 해당 입력 파일
- validator나 interactor를 사용한다면 그 원본

가능하면 Polygon의 Linux/full package처럼 원본과 manual 테스트를 모두 포함한 패키지를 사용하세요. ZIP 최상위에 폴더가 한 겹 더 있어도 CLI가 내부의 단일 `problem.xml`을 찾습니다. `problem.xml`이 없거나 둘 이상이면 어느 문제를 변환해야 하는지 확정할 수 없으므로 중단합니다.

## 2. 대상 경로 덮어쓰기

대상 경로가 없거나 빈 디렉터리라면 바로 변환합니다. 파일이 있거나 디렉터리에 하나라도 항목이 있으면 다음 확인을 요청합니다.

```text
Destination ... already contains data. Delete all existing data and continue? [y/n]
```

- `y` 또는 `yes`: 기존 대상 전체를 새 PPS 패키지로 교체
- `n`, `no` 또는 빈 입력: 아무것도 바꾸지 않고 종료
- 그 밖의 입력: 오입력을 막기 위해 오류로 종료

변환은 별도 임시 디렉터리에서 먼저 완료되고 PPS 형식 검증까지 통과한 뒤 대상과 교체됩니다. 변환에 실패하면 기존 대상은 그대로 남고, 최종 교체가 실패해도 기존 대상을 복원합니다.

자동화에서 이미 삭제를 승인했다면 `--force`를 사용합니다.

```sh
pps polygon package.zip ./two-sum --force
pps --json polygon package.zip ./two-sum --force
```

`--json`으로 기존 대상을 교체할 때는 대화형 입력 대신 반드시 `--force`를 명시해야 합니다. `--force`는 대상의 모든 파일과 `.git`까지 교체하므로 경로를 확인한 뒤 사용하세요.

## 3. 변환되는 파일

| Polygon 자료 | PPS 결과 |
| --- | --- |
| `problem.xml`의 이름·형식·제한 | `config.json`의 문제 정보와 제한 |
| `application/x-tex` 지문 | `statement/*.md` UTF-8 Markdown |
| checker | `checker/` |
| 첫 validator | `config.json`에 연결하고 모든 validator 원본은 `validator/`에 복사 |
| interactor | `interactor/`, 문제 형식은 `interactive` 또는 Papyrus 원본 문자열 `twostep` |
| main solution | 유일한 `MCS` 해답 |
| accepted/rejected solution 태그 | `AC`, `WA`, `TLE`, `MLE`, `FAIL` 조합 |
| test executable | `generator/`와 `genscript` alias |
| manual test | 바이트를 그대로 출력하는 Python 생성기 |
| Polygon group와 dependency | PPS subtask group, 점수, 의존성 |

PPS에서 지원하는 언어로 매핑할 수 없는 checker, validator, interactor, 필수 generator 또는 기준 해답은 실행할 수 없으므로 명확한 오류로 중단합니다. 참고용 해답은 원본을 보존하되 언어가 비어 있을 수 있으며 `pps run`에서는 건너뜁니다.

Polygon의 main 해답이 없으면 첫 accepted 해답을 `MCS`로 선택하고 경고합니다. PPS 제한 범위를 벗어난 시간·메모리·서브태스크 점수는 허용 범위로 조정하고 경고에 원래 값을 표시합니다. 경고가 있으면 배포 전에 반드시 의도를 확인하세요.

Polygon 예제가 없으면 첫 테스트를 PPS 예제로 표시합니다. 예제가 PPS 상한인 20개보다 많으면 앞의 20개만 예제로 표시하되, 나머지도 일반 `genscript` 테스트로 그대로 유지합니다.

서브태스크 문제에서 group이 비어 있는 예제나 테스트가 있으면 PPS의 필수 group 규칙을 만족시키기 위해 이름순 첫 서브태스크에 배정하고 경고합니다. 의도한 채점 그룹이 다르면 `config.json`에서 해당 `subtask_group`을 수정하세요.

## 4. manual 테스트 처리

PPS는 Polygon의 manual generation method를 직접 표현하지 않습니다. CLI는 각 manual 입력을 Python `bytes` 데이터로 넣은 `__pps_manual.py` 생성기를 만듭니다.

이 방식은 다음을 보장합니다.

- CRLF와 LF를 임의로 바꾸지 않음
- UTF-8이 아닌 테스트 입력도 바이트 단위로 보존
- 셸 인용이나 운영체제 기본 인코딩에 의존하지 않음
- 생성기 원본이 너무 커지면 여러 파일로 자동 분할

따라서 Windows에서 만든 패키지의 manual 입력도 변환 과정에서 글자가 바뀌지 않습니다.

## 5. LaTeX에서 Markdown으로 변환되는 범위

변환기는 Polygon의 [Statements TeX manual](https://polygon.codeforces.com/docs/statements-tex-manual)에 정의된 HTML 지문 명령을 기준으로 동작합니다.

지원 범위는 다음과 같습니다.

- `$...$`, `$$...$$`, `\(...\)`, `\[...\]` 수식을 MathJax용 Markdown 수식으로 보존
- `\InputFile`, `\OutputFile`, `\Interaction`, `\Examples`, `\Scoring`, `\Note`, `\Constraints` 등의 구역 제목
- `\textbf`, `\textit`, `\emph`, `\underline`, `\sout`, `\textsc`와 크기 명령
- `\t`, `\tt`, `\texttt`, `\verb`, `lstlisting`, `verbatim` 코드
- 중첩 `itemize`, `enumerate`, `shortitems`, `shortnums` 목록
- `\url`, `\href`, `\epigraph`, 따옴표와 긴 대시
- `center`, 줄바꿈과 문단
- `tabular`, `tabular*`, `\hline`, `\cline`, `\multicolumn`, `\multirow` 표
- `\includegraphics` 이미지와 크기 옵션
- `example`, `examplewide`, `examplethree`의 `\exmp`와 `\exmpfile`
- Polygon `defs.toml`의 `common` 및 지문 언어별 사용자 명령과 기본 인자

예제는 더 이상 삭제되지 않습니다. 입력과 출력은 각각 `text` 코드 블록으로 만들어 줄바꿈과 공백을 읽기 쉽게 보존합니다. 여러 예제는 `Example 1`, `Example 2`처럼 구분하고 `examplethree`의 설명도 함께 옮깁니다.

이미지는 TeX 파일 기준 상대 경로, 패키지 루트, `files/` 순서로 찾습니다. PNG, JPEG, GIF, SVG, WebP는 배포된 지문에서도 보이도록 Markdown에 data URL로 넣고, 검토용 원본도 `<지문 이름>_assets/`에 복사합니다. 8 MiB를 넘거나 웹 이미지 형식이 아닌 파일은 상대 링크로 남기고 경고합니다. 패키지 바깥을 참조하는 경로는 허용하지 않습니다.

Polygon의 공식 HTML 명령이 아닌 프로젝트 전용 LaTeX는 내용을 조용히 버리지 않습니다. 읽을 수 있는 인자는 최대한 Markdown에 남기고, 변환 결과에 명령 이름을 경고로 표시합니다. 해당 지문을 열어 수동으로 확인하세요.

## 6. Windows와 문자 인코딩

출력되는 `problem.xml` 파생 값, `config.json`, Markdown은 모두 다음 형식으로 정규화됩니다.

- UTF-8, BOM 없음
- 줄바꿈 LF
- Unicode NFC

입력은 다음 순서로 해석합니다.

1. UTF-8, UTF-16 LE/BE BOM
2. `problem.xml`의 XML encoding 선언 또는 지문의 `charset`
3. 유효한 UTF-8
4. 언어별 legacy fallback: EUC-KR/CP949, Windows-1251, Shift_JIS, GB18030/Big5
5. Windows-1252

소스 코드, checker, 이미지와 manual 테스트는 텍스트로 다시 인코딩하지 않고 원본 바이트를 복사합니다. Windows 경로의 `\`는 Polygon 패키지 경로로 안전하게 해석하며 출력 경로에는 현재 운영체제 규칙을 사용합니다.

## 7. ZIP 처리와 안전 제한

ZIP 입력은 시스템 압축 해제 프로그램 없이 CLI가 직접 처리합니다. 다음 항목은 변환 전에 차단합니다.

- `../` 또는 절대 경로로 대상 밖에 쓰는 Zip Slip
- 심볼릭 링크와 일반 파일이 아닌 특수 항목
- 중복 경로
- 100,000개를 넘는 항목
- 압축 해제 후 합계 8 GiB를 넘는 아카이브

레거시 ZIP 파일 이름은 ZIP 표준의 CP437 규칙도 처리하며, UTF-8 이름은 그대로 사용합니다.

## 8. 변환 뒤 확인 순서

변환 성공은 파일 구조와 `config.json`이 PPS 정적 검증을 통과했다는 뜻입니다. 실제 프로그램의 컴파일과 판정까지 성공했다는 뜻은 아닙니다. 다음 순서로 확인하세요.

```sh
pps polygon ./polygon-package.zip ./two-sum
cd ./two-sum

# 경고가 있었다면 먼저 지문과 config.json 확인
pps run .

# 필요하면 생성 입력과 빌드 결과 보존
pps run . --keep-work
```

신뢰하지 않는 Polygon 패키지의 코드를 현재 컴퓨터에서 직접 실행하지 마세요. Docker가 준비되어 있다면 다음처럼 격리 실행합니다.

```sh
pps run . --docker
```

변환 결과는 Git 저장소가 아닙니다. 검토한 뒤 새 저장소로 기록하려면 다음과 같이 초기화합니다.

```sh
git init -b main
git add -A
git commit -m "import Polygon package"
```

이미 만든 PPS 원격 문제에 연결하려면 변환 결과의 Git 저장소 안에서 `pps remote <problem-id 또는 owner/name>`를 실행합니다. 이 명령은 remote와 문제 ID 메타데이터만 기록하고 원격 이력을 병합하지 않으므로, branch와 기존 커밋을 확인한 뒤 `pps sync`, `pps invocate`, `pps deploy`를 사용하세요.

## 9. 문제 해결

### `problem.xml`을 찾지 못함

ZIP이 아닌 다른 파일을 전달했거나 불완전한 패키지입니다. 압축을 풀어 `problem.xml`과 원본 파일이 들어 있는 디렉터리를 확인하세요.

### 여러 `problem.xml`이 발견됨

여러 문제를 묶은 상위 디렉터리 대신 변환할 한 문제의 디렉터리를 직접 지정하세요.

### generator가 executable에 없다고 나옴

`tests/test@cmd`의 첫 단어와 `files/executables`의 원본 이름이 맞지 않습니다. Polygon에서 완전한 패키지를 다시 만들거나 `problem.xml`과 파일 구성을 확인하세요.

### 지문에 unsupported LaTeX 경고가 나옴

공식 Polygon HTML 범위 밖의 사용자 매크로일 가능성이 큽니다. `defs.toml`이 ZIP에 포함되었는지 확인하고, 생성된 Markdown에서 경고에 나온 명령 주변을 검토하세요.

### 변환은 성공했지만 `pps run`이 실패함

컴파일러 버전 차이, Polygon 전용 헤더/리소스, PPS가 지원하지 않는 실행 언어, checker 인자 차이일 수 있습니다. `pps run . --keep-work` 출력과 생성된 `config.json`을 함께 확인하세요.
