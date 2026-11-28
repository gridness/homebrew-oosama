class HighlandsOnlineCli < Formula
  desc "Manage Highlands Online accounts, flags and game releases"
  homepage "https://github.com/gridness/highlands-online"
  url "https://github.com/gridness/highlands-online.git",
      tag:      "hlo-v0.1.0",
      revision: "7f5cc3a7ab242ad8ccbf9be9bcba0ee1687d4000"
  version "0.1.0"

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
    assert_includes help.fetch("commands").map { |command| command.fetch("path") }, "release"
    servers = JSON.parse(shell_output("#{bin}/hlo servers list --json")).fetch("servers")
    assert_equal "shared-dev", servers.first.fetch("name")
  end
end
