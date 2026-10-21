class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.13.0"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.13.0/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "54bb70971b88821563a1839c0d908edb94ece169e0f3bedc8ffdf8e18083c316"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.13.0/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "12268695592b1cd6a7384cc677dad2815a9504ed135a660df75abf7e81c9e6ab"
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
