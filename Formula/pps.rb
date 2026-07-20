class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.4.0/pps_v0.4.0_darwin_arm64.tar.gz"
      sha256 "c8649b20c4d6a312a33c7c8ee6861e45e7e3db7e7d22160ef2b3c422b294c1c6"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.4.0/pps_v0.4.0_darwin_amd64.tar.gz"
      sha256 "7e77591cc8b248081fbbbe6af79f5a36f63aa90199b94239616cc6b662b3193e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.4.0/pps_v0.4.0_linux_arm64.tar.gz"
      sha256 "d049dfc91cca9075722cf5b1d34802b8718613b10f9b6978d65f0f02db86b2b5"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.4.0/pps_v0.4.0_linux_amd64.tar.gz"
      sha256 "a409e26cad3bde99a98cf739c151923d19f0bc07f0623fa46db08ea4b7a6a59b"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
