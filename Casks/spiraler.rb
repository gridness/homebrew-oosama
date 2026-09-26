cask "spiraler" do
  version "0.1.5"
  name "Spiraler"
  desc "Local asset studio for coherent visual families"
  homepage "https://github.com/gridness/spiraler"

  on_macos do
    sha256 "2620d787b85149176a2a46e0342d547d4438ee397f31a2d604179bf84e25b568"
    url "https://github.com/gridness/spiraler/releases/download/v#{version}/Spiraler_#{version}_aarch64.dmg"
    depends_on arch: :arm64
    depends_on cask: "codex"
    app "Spiraler.app"

    caveats <<~EOS
      Spiraler is ad-hoc signed and not notarized. macOS requires approval
      in System Settings > Privacy & Security before the first launch.
      Sign in to Codex to generate images.
    EOS
  end

  on_linux do
    arch arm: "aarch64", intel: "x86_64"
    sha256 arm64_linux: "636976f5cf8e3c9f56c04c80d47b93fd78927a930af40740d1c9329efefbe7b4", x86_64_linux: "cc31e4e7622450e73f0e5e51fc52996026be123598a2b06da0aeec08b2a0cbe7"
    url "https://github.com/gridness/spiraler/releases/download/v#{version}/Spiraler_#{version}_#{arch}.AppImage"
    container type: :naked

    preflight_steps do
      set_permissions "Spiraler_{{version}}_{{arch}}.AppImage", "0755"
    end
    # Extract on launch so the cask also works without a FUSE mount.
    command_wrapper "spiraler",
                    executable: "#{staged_path}/Spiraler_#{version}_#{arch}.AppImage",
                    env: { "APPIMAGE_EXTRACT_AND_RUN" => "1" }

    caveats "Run spiraler to launch. Install the Codex CLI and run codex login to generate images."
  end
end
