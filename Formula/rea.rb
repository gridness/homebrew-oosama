class Rea < Formula
  desc "Reverse engineer applications and binaries from your terminal or agent"
  homepage "https://github.com/morluto/rea"
  version "6.7.0"
  license "MIT"

  on_macos do
    depends_on macos: :sonoma

    on_arm do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.7.0/rea-v6.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "f45cd196c5ee0bdcb4d5bb5ed589205c257236be9a939cc86ea935dc7deb1c46"
    end
    on_intel do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.7.0/rea-v6.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "6163f1504ccb2cf9fad300a90c42611f63e291cd769a4840958db61d8a14edd0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.7.0/rea-v6.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e9ab0565b6ebac648790debce9a6fb23ffb73292d8e0ff79dc416dcb8d5fa764"
    end
    on_intel do
      url "https://github.com/gridness/homebrew-oosama/releases/download/rea-v6.7.0/rea-v6.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "96fc1a5b0038bf7eca5ab1c9f4c535764e96abb28ba315de2bfef3a681607051"
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
