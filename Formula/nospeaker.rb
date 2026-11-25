class Nospeaker < Formula
  desc "Play speech and tones through a Mac trackpad's haptic motor"
  homepage "https://github.com/os6/nospeaker"
  url "https://github.com/os6/nospeaker/releases/download/v1.1/nospeaker.zip"
  sha256 "8c740e484b8d45549e4e63061314345638a0cbc6020d0f88015e1caf0b41473b"
  license "MIT"

  depends_on macos: :monterey

  def install
    bin.install "nospeaker"
  end

  test do
    assert_match "nospeaker --sweep", shell_output("#{bin}/nospeaker --help")
  end
end
