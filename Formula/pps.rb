class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.8.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.8.1/pps_v0.8.1_darwin_arm64.tar.gz"
      sha256 "fc50f82216b75682e6cae4a58ebf23baa0a471fbe33cb44ea5a3dc952735997c"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.8.1/pps_v0.8.1_darwin_amd64.tar.gz"
      sha256 "1f809f736a12f99fa9ca2a0618fcf13e5f7d95d94c43958e41b263838f3ccbcf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.8.1/pps_v0.8.1_linux_arm64.tar.gz"
      sha256 "ca1f78891205fc6e3dbbe34fc826c6b6ee9f0d0fb21a3da00c4c7fee150a3007"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.8.1/pps_v0.8.1_linux_amd64.tar.gz"
      sha256 "c1392104d8cab567a9bf8ba97b40d2ae1995ac710d2d6759771a07adbaef035a"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
