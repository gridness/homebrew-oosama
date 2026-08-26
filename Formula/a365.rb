# typed: strict
# frozen_string_literal: true

# a365 terminal application formula populated by the release workflow.
class A365 < Formula
  desc "Browse, play, and download from Anime365 in the terminal"
  homepage "https://github.com/gridness/a365"
  version "3.0.0"
  license "Apache-2.0"
  depends_on "ffmpeg-full" => :optional
  on_macos do
    depends_on arch: :arm64
    on_arm do
      url "https://github.com/gridness/a365/releases/download/v3.0.0/a365-v3.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "10175866f5bbd5b443a5279407b5e0f0a0263cd6df61fe2fae6cae7f711c28b8"
    end
  end
  on_linux do
    depends_on "libsecret"
    depends_on "mpv"

    on_arm do
      url "https://github.com/gridness/a365/releases/download/v3.0.0/a365-v3.0.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "851c0b179542417fd99151e82fc17c7dea15d59696bef84f8dae5cca57bf93d2"
    end
    on_intel do
      url "https://github.com/gridness/a365/releases/download/v3.0.0/a365-v3.0.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c2111f1a4e332646b58f928dab4841257246b03884670efb1ce652dbe83b1d6a"
    end
  end
  def install
    bin.install "a365", "a365dt"
    generate_completions_from_executable bin/"a365", "completions"
  end
  test do
    assert_match version.to_s, shell_output("#{bin}/a365 --version")
    assert_match version.to_s, shell_output("#{bin}/a365dt --version 2>&1")
  end
end
