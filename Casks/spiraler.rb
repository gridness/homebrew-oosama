cask "spiraler" do
  version "0.1.9"
  name "Spiraler"
  desc "Local asset studio for coherent visual families"
  homepage "https://github.com/gridness/spiraler"

  on_macos do
    sha256 "2b1b914db93ab04e52736ac44c27bfda4696dc99344da687dc10a870b1474828"
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
    sha256 arm64_linux: "6f2ec7912b069121fd0132f0ff012a933e71f32f63c476d2c0dadf7313d0ee85", x86_64_linux: "1ba333d3de0f901f598f660d51ef03dfe0e1c77cb6839949bf7192363a52bb44"
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
