class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.11.0"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.11.0/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "dbd3714ffd79f43b18b2d958301fbec94efde1ea8263cf161c2b02dd3266a542"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.11.0/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "b31bb8835d3f38c3d54c2dd84e9beb3ffca859f8d60be32be154884b765ae2c2"
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
