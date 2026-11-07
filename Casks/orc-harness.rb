cask "orc-harness" do
  version "0.1.0"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  url "https://github.com/Lukitaduarte/orc-harness/releases/download/v#{version}/OrcHarness-#{version}-macos.dmg"
  name "Orc Harness"
  desc "Run many Claude Code sessions in parallel, from desktop and phone"
  homepage "https://github.com/Lukitaduarte/orc-harness"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Orc Harness.app"
  # The daemon ships inside the app; the app installs it as a login
  # service on first launch. `orcd pair` pairs a phone.
  binary "#{appdir}/Orc Harness.app/Contents/Resources/bin/orcd"

  # Not notarized yet (no Developer ID): lift the quarantine so the first
  # launch isn't blocked by Gatekeeper.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Orc Harness.app"]
  end

  uninstall launchctl: "me.lukita.orcd",
            quit:      "me.lukita.orcharness"

  zap trash: [
    "~/.orc",
    "~/Library/Application Support/me.lukita.orcharness",
    "~/Library/LaunchAgents/me.lukita.orcd.plist",
    "~/Library/Preferences/me.lukita.orcharness.plist",
  ]

  caveats <<~EOS
    Orc Harness drives Claude Code. If you don't have it yet:
      brew install --cask claude-code
  EOS
end
