class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.5.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.5.0/pps_v0.5.0_darwin_arm64.tar.gz"
      sha256 "56c7f72eaeb4ccc212e1fb441e31aeb8c0f2405ba54baad475eeb5934db3aa71"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.5.0/pps_v0.5.0_darwin_amd64.tar.gz"
      sha256 "05bbbaa0d5e2fb755733c717f613197849b92b76f58dea5327730f4830cd5d9e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.5.0/pps_v0.5.0_linux_arm64.tar.gz"
      sha256 "1ba04d1346e20b144e0a134d13b70d938bc9550a6faf1c383c18a4ce798a97db"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.5.0/pps_v0.5.0_linux_amd64.tar.gz"
      sha256 "d26398779ba5c6d0402d806d3af5f5a5716902695cfa776411c3567caf47e99d"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
