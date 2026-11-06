class Butler < Formula
  desc "Command-line tool for uploading game builds to itch.io"
  homepage "https://itch.io/docs/butler/"
  version "15.32.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://broth.itch.zone/butler/darwin-arm64/#{version}/archive/default"
      sha256 "f1c460f08c02686b49f8da74344e5578ece9ea1a8bae1779445b5d98e0a794b3"
    end
    on_intel do
      url "https://broth.itch.zone/butler/darwin-amd64/#{version}/archive/default"
      sha256 "a92947c9556c9bfb0cc9bdc3814f342b30e0ee7269efc418658894a916ca9584"
    end
  end

  on_linux do
    on_arm do
      url "https://broth.itch.zone/butler/linux-arm64/#{version}/archive/default"
      sha256 "4f2da37785fd9cbc15052427490e4e4f5cd735a019f21554d6273fa9a3490152"
    end
    on_intel do
      url "https://broth.itch.zone/butler/linux-amd64/#{version}/archive/default"
      sha256 "2335971394ef6596f95ded0833e85ee28755e13761716ef4c91d6b11f69162f5"
    end
  end

  def install
    libexec.install "butler", "7z.so", shared_library("libc7zip")
    bin.install_symlink libexec/"butler"
  end

  test do
    assert_match(/^v#{Regexp.escape(version.to_s)}(?:,|$)/, shell_output("#{bin}/butler version"))
  end
end
