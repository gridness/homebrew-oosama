class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.16.3"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.16.3/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "48b58d9939da1ff0a5467cdedb16db83a959046fcaff08e9cb32f697bc8a711c"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.16.3/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "221ded12a570f9768e62078a32c2b908b9d26949608311b820bcc18c4858b225"
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
