class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.14.1"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.14.1/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "3b0f7b2c96a89cbbd323a1f66f7b4bf853cb4b6bac2d471e90213f8b1beb4604"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.14.1/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "c52bd00eddeb817090cec1daeed60665b8906c5211eeb902531826c449e0786c"
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
