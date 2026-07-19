class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.3.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.3.1/pps_v0.3.1_darwin_arm64.tar.gz"
      sha256 "240ae51542dfb5b14a34eb76b2b55fd2c700cc421da5f844c51a8f8f0cb3fa41"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.3.1/pps_v0.3.1_darwin_amd64.tar.gz"
      sha256 "125f53d926147351bae0bfcbf1b91cc83efafb1ded992aa641bd9d73b418a4dd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.3.1/pps_v0.3.1_linux_arm64.tar.gz"
      sha256 "946390731e05c9da2fc450ef8aaab911a03c08f340794564da136d7923ba4e08"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.3.1/pps_v0.3.1_linux_amd64.tar.gz"
      sha256 "fc5d6bd7922240ff8c0a0d84a731bd0c965c9c9ea746fa7c791477f7974e2a9a"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
