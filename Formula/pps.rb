class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.7.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.7.0/pps_v0.7.0_darwin_arm64.tar.gz"
      sha256 "0c4fa074318f0262b0bb5fc0eea56a0dfeac7592646ac49378980765d5feb901"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.7.0/pps_v0.7.0_darwin_amd64.tar.gz"
      sha256 "e92376cbbecc8917d5313c0620d5be995d6eaa2dcd3465ea5d47e1e66076d299"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.7.0/pps_v0.7.0_linux_arm64.tar.gz"
      sha256 "f66c655967a72947252a4c2db99926e91503427135e1ddf45addc5e9c2f2f700"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.7.0/pps_v0.7.0_linux_amd64.tar.gz"
      sha256 "ce656484bb57b1c32a0850955b94e2678bcad500e0d3a2592126e99de8fc0111"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
