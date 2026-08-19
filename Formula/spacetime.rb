class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.8.2"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.8.2/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "3fc1f68bedb5e5fe52d90a54b5f71121140d77a4a85d5f6ea723bfe3e5d8fb5f"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.8.2/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "889e0fa5732d19d611ddc1844f8101f447a8ae001469bcc572d798fb9210a404"
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
