class Rea < Formula
  desc "Reverse engineer applications and binaries from your terminal or agent"
  homepage "https://github.com/morluto/rea"
  version "6.5.0"
  license "MIT"

  on_macos do
    depends_on macos: :sonoma

    on_arm do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.5.0/rea-v6.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "1c8a38d13827dd1ff24cd14a176ffd073f20dfcf8243729ab476158de13822b2"
    end
    on_intel do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.5.0/rea-v6.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "793f71eb851e11e32835ecd697f1367f831a713c60084bd7a0f09c3477c1874f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.5.0/rea-v6.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1d0c26a4d4986bed6b1518823ede35ddf5fca9375763f99531f78ac50305f7f0"
    end
    on_intel do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.5.0/rea-v6.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4501931fdc643ac7af0b4f27b943b08dbb7eb6c0cdcce617bd38ab5cd7f563a4"
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
