class CargoCleaner < Formula
  desc "Find and clean Cargo build caches"
  homepage "https://github.com/gridness/cargo-cleaner"
  version "0.3.0"
  license "MIT"

  on_macos do
    depends_on macos: :ventura

    on_arm do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.3.0/cargo-cleaner-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "ae566cad91b3965bb85b7aa2c506e84db867b3e23f8a9d711d76f6767e66b594"
    end
    on_intel do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.3.0/cargo-cleaner-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "b802d94946a0ef9d6ffc466a55d36511b32d971c9c1abacb39756d24b164c4b3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.3.0/cargo-cleaner-v0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "61b1d54d50dc8d4efbddfaff95aec0a3377b7c49f9925215ee134675a6d66a86"
    end
    on_intel do
      url "https://github.com/gridness/cargo-cleaner/releases/download/v0.3.0/cargo-cleaner-v0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23b9ae117fb89f85b1f278f2409f290a1b719cacc46dac5a21c909aac442f0b4"
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
