class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.10.0"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.10.0/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "9b56140b88af8ba11277c24fbb8177d20196b19252ee6890390a3ab5f2773dea"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.10.0/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "2ffa8a4f417a19c123f2af50cba20b43331c61fe25306848391a5ad4f427969d"
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
