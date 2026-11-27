class Impeccable < Formula
  desc "Command-line engine for the Impeccable design skill"
  homepage "https://impeccable.style/"
  version "0.1.31"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/pbakaus/impeccable/releases/download/engine-v0.1.31/impeccable-darwin-arm64", using: :nounzip
      sha256 "0d96cf802af6c52f3ed0925a409c7f4a1eda6a4c4b8274ff545b1d23e8dd6ae6"
    end
    on_intel do
      url "https://github.com/pbakaus/impeccable/releases/download/engine-v0.1.31/impeccable-darwin-x64", using: :nounzip
      sha256 "af28d77242fc345f11ade5075c304beef2e938a3df70905a95f9864708ee0a2a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pbakaus/impeccable/releases/download/engine-v0.1.31/impeccable-linux-arm64", using: :nounzip
      sha256 "fd488471ae6df728e260bb54c26d0f7fa9235765777f8ee2ff28e9d3dba0dc6b"
    end
    on_intel do
      url "https://github.com/pbakaus/impeccable/releases/download/engine-v0.1.31/impeccable-linux-x64", using: :nounzip
      sha256 "01c642862b0e505277bb8810b1a74aacc42b2b38eb24bc69bc0bcf324089be77"
    end
  end

  def install
    executable = File.basename(stable.url)
    chmod 0755, executable
    bin.install executable => "impeccable"
  end

  test do
    assert_equal "impeccable-engine #{version}\n", shell_output("#{bin}/impeccable engine-probe")
  end
end
