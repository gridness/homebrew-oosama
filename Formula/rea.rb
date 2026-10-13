class Rea < Formula
  desc "Reverse engineer applications and binaries from your terminal or agent"
  homepage "https://github.com/morluto/rea"
  version "6.4.0"
  license "MIT"

  on_macos do
    depends_on macos: :sonoma

    on_arm do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.4.0/rea-v6.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "8c0ea958b20a39ccd39ba43abbb2fb0962eeed4c53a23803c4fbf769a010a9f8"
    end
    on_intel do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.4.0/rea-v6.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "b76c853a80f1f85e7509a0873615ed2a4258f1b0224f93044b71b60303d8bb14"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.4.0/rea-v6.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "48214d182ef18c2d380ca19edd5a923f211166143724dd5704b09b93a59e0744"
    end
    on_intel do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.4.0/rea-v6.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5781007ee68bd8ef4482441bc5f975385ce87b04a941773c9574c28b0d49a3f5"
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
