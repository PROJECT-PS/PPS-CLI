class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.6.0/pps_v0.6.0_darwin_arm64.tar.gz"
      sha256 "51d09fe4a0491049ab656c4525d2f0cbb3f9f011191eb04b537b7369e219b6d1"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.6.0/pps_v0.6.0_darwin_amd64.tar.gz"
      sha256 "7b7f0beb4d4b492a82b0a781c5ed7142705f003276ac57fbf72a18a22061dfe4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.6.0/pps_v0.6.0_linux_arm64.tar.gz"
      sha256 "ee1605c0b75be2f6843622f5a9419df48bb0cd5ee664aa6a26ee0dbf38fbe0c8"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.6.0/pps_v0.6.0_linux_amd64.tar.gz"
      sha256 "5c092bbf9bcf6661eba998755f8ddcf97fcb8742e7199732cd68c35e2091769d"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
