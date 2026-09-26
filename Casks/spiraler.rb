cask "spiraler" do
  version "0.1.2"
  sha256 "df70dba51ad0b466e005908658f93f20164e28a6bf30882ec903dae167045447"

  url "https://github.com/gridness/spiraler/releases/download/v#{version}/Spiraler_#{version}_aarch64.dmg"
  name "Spiraler"
  desc "Local asset studio for coherent visual families"
  homepage "https://github.com/gridness/spiraler"

  depends_on arch: :arm64
  depends_on cask: "codex"

  app "Spiraler.app"

  caveats <<~EOS
    Spiraler is unsigned and not notarized. macOS may require approval
    in System Settings > Privacy & Security before the first launch.
    Sign in to Codex to generate images.
  EOS
end
