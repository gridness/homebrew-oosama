class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.9.0"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.9.0/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "cdbfda90f9e40f7b3ce50a980c129ac6d17e84ba793271149abc4d5bf9014d1b"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.9.0/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "48c8def0e004c5980769ba03bd4107a079ab52c963e62e0d01a52bb22316c82b"
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
