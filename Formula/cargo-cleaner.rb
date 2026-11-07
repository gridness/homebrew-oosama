class CargoCleaner < Formula
  desc "Find and clean Cargo build caches"
  homepage "https://github.com/gridness/cargo-cleaner"
  version "0.2.1"
  license "MIT"

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.2.1/cargo-cleaner-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "8d148eda2f2b18168efc87709073582aac745987d7451fd51705953897d84d9f"
    end
    on_intel do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.2.1/cargo-cleaner-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "1c8b95d465bb7f271590be43a48c5920d064fbeabc9feb602bfaf36ce9f49432"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.2.1/cargo-cleaner-v0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d11a7fea4257398faaf951fa5922d9549bc52abac6852e3f09e24db43c8eaf38"
    end
    on_intel do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.2.1/cargo-cleaner-v0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f18e924f1ddc4c186a96df5be0efadc2a5b90a1a737826495382cfc6a1800966"
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
