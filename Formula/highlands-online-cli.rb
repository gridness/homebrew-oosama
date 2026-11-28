class HighlandsOnlineCli < Formula
  desc "Manage Highlands Online accounts, flags, items and game releases"
  homepage "https://github.com/gridness/highlands-online"
  url "https://github.com/gridness/highlands-online.git",
      tag:      "hlo-v0.1.3",
      revision: "b89fe8fce18a98d0080783c87c7442dab3dd01d0"
  version "0.1.3"

  depends_on "node@24"

  def install
    libexec.install "cli/package.json", "cli/src"
    (bin/"hlo").write <<~SH
      #!/bin/sh
      exec "#{formula_opt_bin("node@24")}/node" "#{libexec}/src/main.ts" "$@"
    SH
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/hlo --version").strip
    help = JSON.parse(shell_output("#{bin}/hlo help --json --no-input"))
    commands = help.fetch("commands").map { |command| command.fetch("path") }
    assert_includes commands, "release"
    assert_includes commands, "flags condition"
    assert_includes commands, "users backpack add"
    assert_includes commands, "items list"
    servers = JSON.parse(shell_output("#{bin}/hlo servers list --json")).fetch("servers")
    assert_equal "shared-dev", servers.first.fetch("name")
  end
end
