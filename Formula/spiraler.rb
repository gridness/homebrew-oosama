class Spiraler < Formula
  desc "Local asset studio for coherent visual families"
  homepage "https://github.com/gridness/spiraler"
  version "0.1.9"
  depends_on :linux

  on_arm do
    url "https://github.com/gridness/spiraler/releases/download/v#{version}/Spiraler_#{version}_aarch64.AppImage", using: :nounzip
    sha256 "6f2ec7912b069121fd0132f0ff012a933e71f32f63c476d2c0dadf7313d0ee85"
  end
  on_intel do
    url "https://github.com/gridness/spiraler/releases/download/v#{version}/Spiraler_#{version}_x86_64.AppImage", using: :nounzip
    sha256 "1ba333d3de0f901f598f660d51ef03dfe0e1c77cb6839949bf7192363a52bb44"
  end

  def install
    appimage = Dir["*.AppImage"].fetch(0)
    chmod 0755, appimage
    system "./#{appimage}", "--appimage-extract"
    libexec.install Pathname("squashfs-root").children
    (bin/"spiraler").write_env_script libexec/"AppRun", APPDIR: libexec
    # AppRun follows the AppDir's desktop-file symlink. Keep its target in place.
    (share/"applications").install_symlink Dir[libexec/"usr/share/applications/*.desktop"]
    if (libexec/"usr/share/icons").directory?
      (share/"icons").mkpath
      cp_r (libexec/"usr/share/icons").children, share/"icons"
    end
  end

  def caveats
    "Run spiraler to launch. Install the Codex CLI and run codex login to generate images."
  end
end
