class A365dt < Formula
  desc "Download Anime365 episodes without guessing translations"
  homepage "https://github.com/Gridness/a365dt"
  version "2.4.0"
  license "Apache-2.0"
  depends_on "ffmpeg-full" => :optional
  deprecate! date: "2026-07-09", because: "has migrated to a365. Please reinstall using brew install gridness/oosama/a365"
  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/Gridness/a365dt/releases/download/v2.4.0/a365dt-v2.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "3b99b36c0302ec376fc65a716f895de947123979e66cf75e167df5ef5da35cc9"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/Gridness/a365dt/releases/download/v2.4.0/a365dt-v2.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "af7c6cff48f0887faeea646c2064e707ae9add33c1a1233e3b2729d24d3dd203"
    end
    on_intel do
      url "https://github.com/Gridness/a365dt/releases/download/v2.4.0/a365dt-v2.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4a11ee800407fcbfca6109c74e04dcaabd53ba48e4f9003cc2508032692a7013"
    end
  end
  def install
    bin.install "a365dt"
    generate_completions_from_executable bin/"a365dt", "completions"
  end
  test do
    assert_match version.to_s, shell_output("#{bin}/a365dt --version")
  end
end
