# typed: strict
# frozen_string_literal: true

# a365 terminal application formula populated by the release workflow.
class A365 < Formula
  # Validates the native macOS Player installed by Homebrew Cask.
  class IinaRequirement < Requirement
    fatal true
    cask "iina"

    satisfy(build_env: false) do
      File.exist?("/Applications/IINA.app") ||
        File.exist?(File.expand_path("~/Applications/IINA.app"))
    end

    def message
      "IINA is required by a365 on macOS. Install it with:\n  brew install --cask iina"
    end
  end

  desc "Browse, play, and download from Anime365 in the terminal"
  homepage "https://github.com/gridness/a365"
  version "3.0.1"
  license "Apache-2.0"
  depends_on "ffmpeg-full" => :optional
  on_macos do
    depends_on arch: :arm64
    depends_on IinaRequirement

    on_arm do
      url "https://github.com/gridness/a365/releases/download/v3.0.1/a365-v3.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "f213ba90ead9ada67f589ddb77277bc5479c981fedc7fd5cdbb702a91bb932f5"
    end
  end
  on_linux do
    depends_on "libsecret"
    depends_on "mpv"

    on_arm do
      url "https://github.com/gridness/a365/releases/download/v3.0.1/a365-v3.0.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "54a76e8948730f681841c5fd191a58555a8d04b86bd0249d4c9cb9528b29f01d"
    end
    on_intel do
      url "https://github.com/gridness/a365/releases/download/v3.0.1/a365-v3.0.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4a9fe5f408a8f513ab10763422b1fdee72b196a8d157c0cbde22ae2ce0c0aafa"
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
