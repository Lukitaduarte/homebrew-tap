cask "orc-harness" do
  version "0.1.2"
  sha256 "6c0d2a74c9e86fbd62b8ec540226057488100df692241c30d7dfddf9ab7d387d"

  url "https://github.com/Lukitaduarte/orc-harness/releases/download/v#{version}/OrcHarness-#{version}-macos.dmg"
  name "Orc Harness"
  desc "Run many Claude Code sessions in parallel, from desktop and phone"
  homepage "https://github.com/Lukitaduarte/orc-harness"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Orc Harness.app"
  # The daemon ships inside the app; the app installs it as a login
  # service on first launch. `orcd pair` pairs a phone.
  binary "#{appdir}/Orc Harness.app/Contents/Resources/bin/orcd"

  # Not notarized yet (no Developer ID): lift the quarantine so the first
  # launch isn't blocked by Gatekeeper.
  app_path = "#{appdir}/Orc Harness.app"
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", app_path],
        writable_paths: ["Orc Harness.app"],
        writable_base:  :appdir
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
