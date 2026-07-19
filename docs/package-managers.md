# 설치 및 배포 채널 현황

[English](package-managers.en.md)

## 현재 제공 범위

| 방식 | 제공 범위 | 운영 방식 |
| --- | --- | --- |
| Homebrew tap | `Formula/pps.rb` | 최초 tap 때 이 저장소의 Git URL 지정 |
| Homebrew Core | 해당 없음 | 바이너리 전용 비공개 소스 프로젝트는 Core 정책상 부적합 |
| Windows 직접 설치 | AMD64, ARM64 ZIP과 `install.ps1` | GitHub Release를 통해 독립 배포 |
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

## Windows

Windows는 패키지 관리자에 등록하지 않고 별도 관리합니다. 릴리즈마다 AMD64와 ARM64용 ZIP을 GitHub Release에 게시하며, `install.ps1`이 운영체제 아키텍처 감지, 다운로드, SHA-256 검증, 설치 및 사용자 `PATH` 등록을 처리합니다.

```powershell
irm https://raw.githubusercontent.com/PROJECT-PS/PPS-CLI/main/install.ps1 | iex
```

최초 설치 후에는 `pps update`로 새 릴리즈를 설치할 수 있으며, 설치 스크립트를 다시 실행해도 됩니다. 직접 설치하거나 삭제하는 방법은 [설치 상세 안내](installation.md)를 참고하세요.

## APT / Debian / Ubuntu

GitHub Release의 `.deb`는 `apt install ./pps_<version>_<arch>.deb`로 바로 설치할 수 있지만, `apt install pps`만으로 설치하려면 서명된 저장소가 필요합니다.

`.deb`로 설치된 실행 파일은 일반적으로 root 소유이므로 `pps update`에 쓰기 권한이 없을 수 있습니다. 이 경우 새 `.deb`를 받아 `sudo apt install ./파일명.deb`로 업데이트합니다.

- 자체 저장소: [Debian reprepro 안내](https://wiki.debian.org/DebianRepository/SetupWithReprepro)에 따라 GPG 키, `InRelease`, `Packages` 인덱스를 만들고 HTTPS 정적 호스팅에 게시합니다.
- Ubuntu PPA: [Launchpad PPA 안내](https://documentation.ubuntu.com/launchpad/user/reference/packaging/ppas/ppa/)에 따라 바이너리가 아니라 Debian 소스 패키지를 업로드해야 합니다. 현재 소스 비공개 정책과 맞지 않으므로 별도 검토가 필요합니다.
- Debian 공식 저장소: Debian 정책에 맞는 소스 패키지와 메인테이너/스폰서 절차가 필요하므로 현재 바이너리 배포만으로는 등록할 수 없습니다.

## 코드 서명

현재 자동화는 SHA-256 체크섬을 제공하지만 운영체제 신뢰 체인의 코드 서명은 별도 자격 증명이 필요합니다.

- macOS: Apple Developer ID로 서명하고 Apple의 [공증 절차](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution)를 `notarytool`로 자동화해야 합니다.
- Windows: 신뢰 가능한 코드 서명 인증서를 준비하고 Windows SDK의 [SignTool](https://learn.microsoft.com/windows/win32/seccrypto/signtool)로 AMD64/ARM64 실행 파일을 서명·타임스탬프해야 합니다.
- APT: 오프라인 보관한 GPG 서명 키로 저장소 메타데이터를 서명하고 공개 키를 별도 HTTPS 경로로 제공해야 합니다.
