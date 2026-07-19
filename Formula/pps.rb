class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.2.0/pps_v0.2.0_darwin_arm64.tar.gz"
      sha256 "d20bdabf18ee4e7a492c594390ffdb948c442410092566467a8ea3e8f98a8671"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.2.0/pps_v0.2.0_darwin_amd64.tar.gz"
      sha256 "19213bb135eb6a1a2cbeb9ea04d3083608b0a9dbd57fde6b0e019cdc2eb0daaf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.2.0/pps_v0.2.0_linux_arm64.tar.gz"
      sha256 "0d6c5e7fdf35fad3312469beec49aa653044a1b6efc57e87a98937f39f3397b8"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.2.0/pps_v0.2.0_linux_amd64.tar.gz"
      sha256 "0ad8db276938cf4bde462bc8d5075626472652da08e6ad22323ae362845a05c7"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
