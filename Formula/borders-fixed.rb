class BordersFixed < Formula
  env :std
  desc "JankyBorders with the macOS 27 Mission Control fix"
  homepage "https://github.com/michaellee4/JankyBorders"
  url "https://github.com/michaellee4/JankyBorders/archive/6305edcde1ff938ecdc5727c9374f8ec7c7a94aa.tar.gz"
  version "1.9.0-mc1"
  sha256 "458021b1c85dda9f26297150498fc92a6c43cc504a2aacb5154a3c566b4dd0a1"
  license "GPL-3.0-only"

  def install
    ENV.delete("CFLAGS")
    ENV.delete("LDFLAGS")
    ENV.delete("CXXFLAGS")
    inreplace "src/main.c", 'borders-v%d.%d.%d\n', 'borders-v%d.%d.%d-mc1\n'
    system "make"
    system "/usr/bin/codesign", "--force", "--sign", "-", "bin/borders"
    bin.install "bin/borders"
    man1.install "docs/borders.1"
    (var/"log/borders-fixed").mkpath
  end

  service do
    run opt_bin/"borders"
    environment_variables PATH: std_service_path_env, LANG: "en_US.UTF-8"
    keep_alive true
    process_type :interactive
    log_path var/"log/borders-fixed/borders.out.log"
    error_log_path var/"log/borders-fixed/borders.err.log"
  end

  test do
    assert_equal "borders-v1.9.0-mc1\n", shell_output("#{bin}/borders --version")
  end
end
