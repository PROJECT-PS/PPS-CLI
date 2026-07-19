class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.3.0/pps_v0.3.0_darwin_arm64.tar.gz"
      sha256 "2ad823adee331b528308bd02a174a9750d4d7f69be010b3063756aa209ed3d56"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.3.0/pps_v0.3.0_darwin_amd64.tar.gz"
      sha256 "3ba505c3d531c4cadfc2eaf698a8e4122f87337b24daedca9d943443f141624c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.3.0/pps_v0.3.0_linux_arm64.tar.gz"
      sha256 "8f75b83ff7910dfce99b673d5fef7a4bb0fa59212da92941f95ec9aa37452c38"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.3.0/pps_v0.3.0_linux_amd64.tar.gz"
      sha256 "2a065db055f372407c44f6a811aa3e3af884dec5b52b5206d69f3d3562a9134e"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
