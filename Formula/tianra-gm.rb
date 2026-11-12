class TianraGm < Formula
  desc "Tianra Game Master tools for AI agents and humans"
  homepage "https://github.com/gridness/tianra-builds"
  version "0.1.0.2"

  depends_on macos: :sequoia
  depends_on arch: :arm64

  url "https://github.com/gridness/tianra-builds/releases/download/tianra-gm-v0.1.0-build.2/tianra-gm-0.1.0-build-2-macos-aarch64.tar.gz"
  sha256 "d7777951975375e39cfe33ac7d997f11a9561b5a6c7fb7fbb5d2ef62f30d90e6"

  def install
    bin.install "bin/tianra-gm"
    pkgshare.install "version.json", "licenses"
    generate_completions_from_executable(bin/"tianra-gm", "completions", shells: [:bash, :zsh, :fish])
  end

  def caveats
    <<~EOS
      Uses the installed SpacetimeDB CLI sign-in. Tool data stays in ~/.tianra-gm.
      Install the bundled agent skill explicitly:
        tianra-gm skill install --agent codex
        tianra-gm skill install --agent claude
    EOS
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/tianra-gm --version")
    assert_match '"schema_version":1', shell_output("#{bin}/tianra-gm commands")
  end
end
