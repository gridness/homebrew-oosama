class Spacetime < Formula
  desc "Command-line interface for SpacetimeDB"
  homepage "https://spacetimedb.com"
  version "2.8.3"

  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.8.3/spacetime-aarch64-apple-darwin.tar.gz"
    sha256 "b557835b862a7af4e60ad09de895a3aa2eee86dd690a9816df08b1b9e3f782ec"
  else
    url "https://github.com/clockworklabs/SpacetimeDB/releases/download/v2.8.3/spacetime-x86_64-apple-darwin.tar.gz"
    sha256 "0861a8f0808647c6442912acbdde0daf6db5a61a073fef6bf5eef9074b94e07b"
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
