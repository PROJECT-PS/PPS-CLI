class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.8.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.8.0/pps_v0.8.0_darwin_arm64.tar.gz"
      sha256 "db5dc5dcbe97b44b5a7e8b745433aa02fbd173670cf27418344020c0c0fd0097"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.8.0/pps_v0.8.0_darwin_amd64.tar.gz"
      sha256 "e435265857635009e7bb928adea0f4a0cfd16fea7e90d7684cb59962e75fae0a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.8.0/pps_v0.8.0_linux_arm64.tar.gz"
      sha256 "3857f00e32c77696afcc56fbda65bf6cdde5edee8e3bbf46c2b9b9d591253ec2"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.8.0/pps_v0.8.0_linux_amd64.tar.gz"
      sha256 "fb56553cdc2bd90fd243d8ef19f9484f41f5fae7074ed110018730e5a15cfb87"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
