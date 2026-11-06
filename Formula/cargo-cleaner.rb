class CargoCleaner < Formula
  desc "Find and clean Cargo build caches"
  homepage "https://github.com/gridness/cargo-cleaner"
  version "0.1.0"
  license "MIT"

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.1.0/cargo-cleaner-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "c2a124d648338afce111b62cea373c5e906a0fed2a8407396e7c007154653ecb"
    end
    on_intel do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.1.0/cargo-cleaner-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "6661943f9bdaa972ba72d1c9c367384fc5ff44cb7ef4589740665840712ed79e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.1.0/cargo-cleaner-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "743a3488e74cd2b14e917688f8c32135e5c6cd3ca682520f582ec67a14f82a54"
    end
    on_intel do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.1.0/cargo-cleaner-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1dbf944c8853827e7e3ffdf7f716a3eba2986477c654ef0ac402ecff6854b1fa"
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
