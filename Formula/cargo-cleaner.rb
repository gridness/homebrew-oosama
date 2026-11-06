class CargoCleaner < Formula
  desc "Find and clean Cargo build caches"
  homepage "https://github.com/gridness/cargo-cleaner"
  version "0.2.0"
  license "MIT"

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.2.0/cargo-cleaner-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "5067e64050510b939b9fe3de81cde6067b245a6a5699ac967e4b80227a0fe332"
    end
    on_intel do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.2.0/cargo-cleaner-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "b5ef4ec03b9ac20eeff57d6aa0cea1d9257d28d71ae744915848b9bf4c63393f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.2.0/cargo-cleaner-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3f7ad4cc94c3b09e0749ff1c218c412553d0a3b4a3bd108c4a1f8dc7144b3966"
    end
    on_intel do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.2.0/cargo-cleaner-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4bb2973918394fb27f030255c286bc3a8746be9d2910d091cf994f976b7058e2"
    end
  end

  def install
    bin.install "cargo-cleaner"
    bash_completion.install "completions/cargo-cleaner.bash" => "cargo-cleaner"
    zsh_completion.install "completions/_cargo-cleaner"
    fish_completion.install "completions/cargo-cleaner.fish"
  end

  test do
    assert_equal "cargo-cleaner #{version}", shell_output("#{bin}/cargo-cleaner --version").strip
    assert_match "Find Cargo projects", shell_output("#{bin}/cargo-cleaner scan --help")
  end
end
