class Rea < Formula
  desc "Reverse engineer applications and binaries from your terminal or agent"
  homepage "https://github.com/morluto/rea"
  version "6.6.0"
  license "MIT"

  on_macos do
    depends_on macos: :sonoma

    on_arm do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.6.0/rea-v6.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "3ea2452b39915db0782dc69d7a114e7e6e02dcb1395bf34f77ad70693a64e3ab"
    end
    on_intel do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.6.0/rea-v6.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "1fdee9e7b80533b7fda2f7e2b45c46dcaa8f19060f61bd98120b0e32cf6522de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.6.0/rea-v6.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5ed69585d4139a09f14c069a8fc6e008795fc49dc0577545212965053c9f9113"
    end
    on_intel do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.6.0/rea-v6.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e1c1a11552f44c865b719c6f2fd3064f068adbd25fafc3d9311730c1b2ac05a6"
    end
  end

  def install
    libexec.install "rea", "app", "manifest.json", "RUNTIME_LICENSE"
    (libexec/"command-path").write "#{opt_bin}/rea\n"
    bin.install_symlink libexec/"rea"
    bin.install_symlink libexec/"rea" => "rea-agents"
  end

  def caveats
    <<~EOS
      Set up your agent with:

        rea setup

      Upgrade this Homebrew installation with:

        brew upgrade rea
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rea --version")
    assert_match "setup", shell_output("#{bin}/rea --help")
    assert_match version.to_s, shell_output("#{bin}/rea-agents --version")
  end
end
