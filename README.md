# sing-box-for-apple

Experimental iOS/macOS/tvOS client for sing-box, the universal proxy platform.

## Documentation

[SFI](https://sing-box.sagernet.org/installation/clients/sfi/) | [SFM](https://sing-box.sagernet.org/installation/clients/sfm/)

## Local development and signing

### Apple Team ID

Signing uses Xcode's native `DEVELOPMENT_TEAM` build setting. The project-level
Debug and Release configurations load `Configuration/Signing.shared.xcconfig`,
which optionally includes the ignored local file
`Configuration/Signing.xcconfig`.

After a fresh clone, create the local configuration and replace the placeholder
with your Apple Developer Team ID:

```bash
cp Configuration/Signing.example.xcconfig Configuration/Signing.xcconfig
```

```xcconfig
DEVELOPMENT_TEAM = YOUR_TEAM_ID
```

Do not commit `Configuration/Signing.xcconfig`. It is intentionally ignored by
Git. Also avoid committing target-level `DEVELOPMENT_TEAM` entries to
`sing-box.xcodeproj/project.pbxproj`; those entries override the xcconfig value.
Xcode may add them after selecting a team in **Signing & Capabilities**, so check
the project file diff before committing.

GitHub Actions can generate the ignored file from a repository secret before
running `xcodebuild`:

```bash
printf 'DEVELOPMENT_TEAM = %s\n' "${APPLE_TEAM_ID}" > Configuration/Signing.xcconfig
```

Set `APPLE_TEAM_ID` from `${{ secrets.APPLE_TEAM_ID }}` in the workflow step's
environment.

### Jailbreak Team ID placeholder

Jailbreak entitlements intentionally use the fixed placeholder `TEAMID0000`.
Do not replace it with a personal Apple Team ID. The committed signing check
allows this placeholder.

### Git commit hook

Install the repository's pre-commit hook once after every fresh clone:

```bash
make install_git_hooks
```

The hook examines the complete staged snapshot and rejects hard-coded Apple
Team IDs in Xcode settings and plist values. It also catches a locally ignored
signing file if it is force-added. Run the same check manually with:

```bash
make check_team_ids
```

### SFM LaunchDaemon

The `SFM` target contains an **Install LaunchDaemon** build phase. Xcode runs
`Scripts/install_launch_daemon.sh` automatically during Build, Run, and Archive.
The script reads `DEVELOPMENT_TEAM`, generates the helper's Mach service name,
and places the generated plist in the app bundle. It does not install or start
the service on the current Mac. A missing Team ID stops the build with an error.

## License

```
Copyright (C) 2022 by nekohasekai <contact-sagernet@sekai.icu>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
```
