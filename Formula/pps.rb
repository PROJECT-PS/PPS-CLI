class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.1.0/pps_v0.1.0_darwin_arm64.tar.gz"
      sha256 "7ef05480ea5856ad447a5cdefe02cc687e4d39d33d7112a06d3aa457e13e9a27"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.1.0/pps_v0.1.0_darwin_amd64.tar.gz"
      sha256 "2ae353307d26215c6093a25b8d13362566d78b7ed9207a4abbfb7ae94ab44651"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.1.0/pps_v0.1.0_linux_arm64.tar.gz"
      sha256 "f257849556fd612bfe3b872d0af601a0b316c6b3a8a6d8f9e4c6515f4aacf350"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.1.0/pps_v0.1.0_linux_amd64.tar.gz"
      sha256 "3e1af078dce615cec4b4a643ee407ba3625fd929e59713700d8dd902a69bba72"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
