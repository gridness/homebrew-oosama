class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.15.0"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.15.0/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "f018f65742006fc3ce4daa9e676f2710589b2bbca8ea0838e67cd9577323733e"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.15.0/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "c630f26264e2fe0a4f276324afb40eb76e5bac45c285460b26a1e24675ffd393"
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
