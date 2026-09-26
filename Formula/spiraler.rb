class Spiraler < Formula
  desc "Local asset studio for coherent visual families"
  homepage "https://github.com/gridness/spiraler"
  version "0.1.5"
  depends_on :linux

  on_arm do
    url "https://github.com/gridness/spiraler/releases/download/v#{version}/Spiraler_#{version}_aarch64.AppImage", using: :nounzip
    sha256 "636976f5cf8e3c9f56c04c80d47b93fd78927a930af40740d1c9329efefbe7b4"
  end
  on_intel do
    url "https://github.com/gridness/spiraler/releases/download/v#{version}/Spiraler_#{version}_x86_64.AppImage", using: :nounzip
    sha256 "cc31e4e7622450e73f0e5e51fc52996026be123598a2b06da0aeec08b2a0cbe7"
  end

  def install
    appimage = Dir["*.AppImage"].fetch(0)
    chmod 0755, appimage
    system "./#{appimage}", "--appimage-extract"
    libexec.install Pathname("squashfs-root").children
    (bin/"spiraler").write_env_script libexec/"AppRun", APPDIR: libexec
    (share/"applications").install Dir[libexec/"usr/share/applications/*.desktop"]
    share.install libexec/"usr/share/icons" if (libexec/"usr/share/icons").directory?
  end

  def caveats
    "Run spiraler to launch. Install the Codex CLI and run codex login to generate images."
  end
end
