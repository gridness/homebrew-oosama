class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.8.1"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.8.1/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "5da17b369523c22d1aae5c22b7cd50cd23401538fe02331f7a216d324473b679"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.8.1/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "89585c9c58bea82f2c94dd1d1a8b4add62d41347fa8699dfe31648ea23212f90"
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
