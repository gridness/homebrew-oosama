class TianraGm < Formula
  desc "Tianra Game Master tools for AI agents and humans"
  homepage "https://github.com/gridness/tianra-builds"
  version "0.1.0.4"

  depends_on macos: :sequoia
  depends_on arch: :arm64

  url "https://github.com/gridness/tianra-builds/releases/download/tianra-gm-v0.1.0-build.4/tianra-gm-0.1.0-build-4-macos-aarch64.tar.gz"
  sha256 "8f4135b9c5b18daf176e9ed63aaf608f2fa7ff9e5af936aa911011901e174e40"

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
