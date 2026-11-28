class CloudflareCli < Formula
  desc "Command-line interface for the Cloudflare API and Workers projects"
  homepage "https://developers.cloudflare.com/cf/"
  url "https://registry.npmjs.org/cf/-/cf-1.0.0-rc.6.tgz"
  version "1.0.0-rc.6"
  sha256 "2077439f5b68a9eb348911c268eec6ce49ae529d114c98e3fabf1c684b4b4e50"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "node@24"

  conflicts_with "cf", because: "both install a `cf` executable"
  conflicts_with "cloudfoundry-cli", because: "both install a `cf` executable"

  def install
    node_bin = Formula["node@24"].opt_bin
    ENV.prepend_path "PATH", node_bin
    system "npm", "install", *std_npm_args

    %w[cf cloudflare].each do |command|
      (bin/command).write_env_script libexec/"bin"/command, PATH: "#{node_bin}:$PATH"
    end
  end

  test do
    %w[cf cloudflare].each do |command|
      assert_equal version.to_s, shell_output("#{bin}/#{command} --version").strip
    end
  end
end
