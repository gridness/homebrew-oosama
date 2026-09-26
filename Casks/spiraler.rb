cask "spiraler" do
  version "0.1.8"
  name "Spiraler"
  desc "Local asset studio for coherent visual families"
  homepage "https://github.com/gridness/spiraler"

  on_macos do
    sha256 "acf63e130a99aef656d16e6e5729893c76f2d8f4a1348087baf4bbd58e4a6c75"
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
    sha256 arm64_linux: "99d49a42a79e3332c528d1f6fb5599ff66ee443f32ccc0d135581f072b94c842", x86_64_linux: "7d4d91adf4c4656eaa78267c818808538a3c1b6c831bf044203df6b833159e63"
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
