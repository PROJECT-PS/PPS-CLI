class Pps < Formula
  desc "Official command-line interface for PROJECT-PS"
  homepage "https://github.com/PROJECT-PS/PPS-CLI"
  version "0.9.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.9.0/pps_v0.9.0_darwin_arm64.tar.gz"
      sha256 "1aad79c7217586976c03e2dc93c8170cccd11c8bcdcabb06dd0caf5b75178b70"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.9.0/pps_v0.9.0_darwin_amd64.tar.gz"
      sha256 "f222f884915b53277531d95ee5d5d20a4fc200611ad4b917f19fdd8c76a4b54b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.9.0/pps_v0.9.0_linux_arm64.tar.gz"
      sha256 "39c3fcf2d3d0dfde1f8135eda9c6b3a036367bd3db5d558ba246327f613ec1cc"
    else
      url "https://github.com/PROJECT-PS/PPS-CLI/releases/download/v0.9.0/pps_v0.9.0_linux_amd64.tar.gz"
      sha256 "f15adcfd67c48c58d991f265ceeab10129e331ca80296a628935e12629173a41"
    end
  end

  def install
    bin.install "pps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pps --version")
  end
end
