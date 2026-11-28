class Impeccable < Formula
  desc "Command-line engine for the Impeccable design skill"
  homepage "https://impeccable.style/"
  version "0.1.32"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/pbakaus/impeccable/releases/download/engine-v0.1.32/impeccable-darwin-arm64", using: :nounzip
      sha256 "36daa783fff56b9bc08836a311cf8cbe37cae92017b6e60e944dd06704e49024"
    end
    on_intel do
      url "https://github.com/pbakaus/impeccable/releases/download/engine-v0.1.32/impeccable-darwin-x64", using: :nounzip
      sha256 "bf1e266be92696793fe395c044730e335559f6ac8907c019b6f2d3b6f6e9cff4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pbakaus/impeccable/releases/download/engine-v0.1.32/impeccable-linux-arm64", using: :nounzip
      sha256 "02725065db488780d86954f4106be6cc0cdf373e88e7c19891cb4c357889a85d"
    end
    on_intel do
      url "https://github.com/pbakaus/impeccable/releases/download/engine-v0.1.32/impeccable-linux-x64", using: :nounzip
      sha256 "739c719efdca8f93e0c7ce1499588c47d26bbde2f8bb63b093cd6a5ccf6a6913"
    end
  end

  def install
    executable = File.basename(stable.url)
    chmod 0755, executable
    bin.install executable => "impeccable"
  end

  test do
    assert_equal "impeccable-engine #{version}\n", shell_output("#{bin}/impeccable engine-probe")
  end
end
