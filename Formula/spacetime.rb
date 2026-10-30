class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.14.0"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.14.0/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "1228fd5a63fd2547b466429aecffea9a84c9f2c7df813db38504ef6399fb68f6"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.14.0/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "1ce64f6f445d44ed8ea8c73526baa22049144b0bfdc6b2aab28dfee107ae482f"
  end

  def caveats
    <<~EOS
      This formula uses Homebrew for SpacetimeDB version management.
      Upgrade with:

        brew upgrade spacetime

      SpacetimeDB stores user configuration and local database data
      outside the Homebrew prefix. These are intentionally preserved
      when the formula is uninstalled.

      Default locations:

        ~/.config/spacetime
        ~/.local/share/spacetime/data

      If you previously used the official SpacetimeDB installer, it may
      also have installed version-managed binaries under:

        ~/.local/share/spacetime/bin
        ~/.local/bin/spacetime
    EOS
  end

  def install
    bin.install "spacetimedb-cli" => "spacetime"
    bin.install "spacetimedb-standalone"
  end

  test do
    system bin/"spacetime", "--version"
  end
end
