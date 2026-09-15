class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.10.1"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.10.1/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "ecbd76e9e9a2b36f3b08763616182ad740522426c35043c39dff55f6470d0c37"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.10.1/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "8599a94ac67806c4515926462454a59476502216d1949d0077884717288a4873"
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
