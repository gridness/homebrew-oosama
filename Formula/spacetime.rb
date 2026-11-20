class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.16.1"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.16.1/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "4036ae58db892d9b8c3acda48942b42c3c2dc7f1d293177c4096ed4baba06343"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.16.1/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "4f53a1643c53e588eda47158a3ac75e3bd7b7c5af181faa0f9695b4e3734fc31"
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
