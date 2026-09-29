class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.10.2"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.10.2/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "53f83c920e142918b1cffd59e33bda898bec5742fc4e91f8c54fe134f27f3f74"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.10.2/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "6cd2b2be62992b0a801d6fc77048c67bfc8ccd8a2574ed4af34e42af383a9496"
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
