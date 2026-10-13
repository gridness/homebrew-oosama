class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.12.0"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.12.0/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "1e668e9d120db802a0a567fca88cc83eb8e89019cd602d33487bfbee2656717c"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.12.0/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "4d69ef0ce5810a600ac321c91c1f6d2665ec82aec4cabb8a3b9fd353fc8c6e8d"
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
