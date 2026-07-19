# 패키지 관리자 배포 현황과 공식 등록

[English](package-managers.en.md)

## 현재 제공 범위

| 방식 | 이 저장소에서 자동 생성 | 공식 등록에 필요한 추가 작업 |
| --- | --- | --- |
| Homebrew tap | `Formula/pps.rb` | 없음. 최초 tap 때 이 저장소의 Git URL 지정 |
| Homebrew Core | 해당 없음 | 바이너리 전용 비공개 소스 프로젝트는 Core 정책상 부적합 |
| WinGet | 버전별 YAML manifest | `microsoft/winget-pkgs`에 PR 제출 및 승인 |
| Debian/Ubuntu `.deb` | AMD64, ARM64 패키지 | 릴리즈 파일 직접 설치 가능 |
| `apt install pps` 저장소 | 아직 미호스팅 | GPG 서명 APT 저장소 또는 PPA/배포판 공식 패키징 필요 |

## Homebrew

이 저장소 자체를 tap으로 사용하면 별도 중앙 심사 없이 설치할 수 있습니다. 다만 저장소 이름이 `homebrew-`로 시작하지 않으므로 최초 등록 때 Git URL을 명시해야 합니다.

```sh
brew tap PROJECT-PS/PPS-CLI https://github.com/PROJECT-PS/PPS-CLI.git
brew install PROJECT-PS/PPS-CLI/pps
```

Homebrew의 [tap 생성 공식 문서](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)에 따라 `Formula/pps.rb`를 릴리즈마다 체크섬과 함께 갱신합니다. 접두사 없는 짧은 tap 명령이 필요하다면 나중에 `PROJECT-PS/homebrew-tap` 저장소를 별도로 만드는 방식이 가장 표준적입니다.

`homebrew/core`는 [공식 허용 정책](https://docs.brew.sh/Acceptable-Formulae)상 오픈 소스이고 소스에서 빌드 가능한 formula를 요구하며 바이너리 전용 formula를 받지 않습니다. 현재처럼 공개 소스가 없는 PPS CLI는 자체 tap을 유지하는 것이 적합합니다. macOS 전용 공식 등록이 필요하면 바이너리 배포를 허용하는 `homebrew/cask`를 별도로 검토할 수 있지만, Linux 설치까지 함께 제공하는 현재 tap을 대체하지는 않습니다.

## WinGet

릴리즈가 생성되면 `packaging/winget` 아래에 AMD64와 ARM64 설치 URL 및 SHA-256이 포함된 manifest가 생성됩니다. 공식 `winget install PROJECT-PS.PPS`를 활성화하려면 다음 작업이 남습니다.

1. Windows에서 `winget validate <manifest-directory>`와 Sandbox 설치 테스트를 수행합니다.
2. [Microsoft WinGet 제출 안내](https://learn.microsoft.com/windows/package-manager/package/repository)에 따라 `microsoft/winget-pkgs` 저장소에 manifest PR을 제출합니다.
3. 자동 보안 검사와 검토 승인을 기다립니다.

`wingetcreate`로 생성 및 PR 제출을 자동화할 수도 있습니다. 자세한 형식은 [manifest 생성 공식 문서](https://learn.microsoft.com/windows/package-manager/package/manifest)를 참고하세요.

## APT / Debian / Ubuntu

GitHub Release의 `.deb`는 `apt install ./pps_<version>_<arch>.deb`로 바로 설치할 수 있지만, `apt install pps`만으로 설치하려면 서명된 저장소가 필요합니다.

- 자체 저장소: [Debian reprepro 안내](https://wiki.debian.org/DebianRepository/SetupWithReprepro)에 따라 GPG 키, `InRelease`, `Packages` 인덱스를 만들고 HTTPS 정적 호스팅에 게시합니다.
- Ubuntu PPA: [Launchpad PPA 안내](https://documentation.ubuntu.com/launchpad/user/reference/packaging/ppas/ppa/)에 따라 바이너리가 아니라 Debian 소스 패키지를 업로드해야 합니다. 현재 소스 비공개 정책과 맞지 않으므로 별도 검토가 필요합니다.
- Debian 공식 저장소: Debian 정책에 맞는 소스 패키지와 메인테이너/스폰서 절차가 필요하므로 현재 바이너리 배포만으로는 등록할 수 없습니다.

## 코드 서명

현재 자동화는 SHA-256 체크섬을 제공하지만 운영체제 신뢰 체인의 코드 서명은 별도 자격 증명이 필요합니다.

- macOS: Apple Developer ID로 서명하고 Apple의 [공증 절차](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)를 `notarytool`로 자동화해야 합니다.
- Windows: 신뢰 가능한 코드 서명 인증서를 준비하고 Windows SDK의 [SignTool](https://learn.microsoft.com/windows/win32/seccrypto/signtool)로 AMD64/ARM64 실행 파일을 서명·타임스탬프해야 합니다.
- APT: 오프라인 보관한 GPG 서명 키로 저장소 메타데이터를 서명하고 공개 키를 별도 HTTPS 경로로 제공해야 합니다.
