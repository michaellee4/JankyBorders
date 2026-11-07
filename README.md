# JankyBorders

## Why this fork exists

Created on **November 7, 2026** to fix **Mission Control on macOS 27 Golden Gate**.
With upstream JankyBorders v1.9.0, borders stayed at their original desktop
positions and sizes while Mission Control shrank the window previews.
This fork hides borders while Mission Control is open and restores them on exit.

At the time we forked, the upstream [bug report (#209)](https://github.com/FelixKratz/JankyBorders/issues/209)
was open and the proposed [fix (#210)](https://github.com/FelixKratz/JankyBorders/pull/210)
had not been merged. Check those links for their current status when revisiting.

### Fix provenance and scope

- Base: upstream **v1.9.0** (`a7297ca7d1933f3a30b12e8f10750e8d84eeee1e`).
- Original fix: [Andrew Cincotta's commit `0017b53`](https://github.com/andrewcincotta/JankyBorders/commit/0017b53b9ec8eed21dc33bdbb9d2bbe383574a54).
- Applied through [ishmukhamet's source-only backport `6305edc`](https://github.com/ishmukhamet/JankyBorders/commit/6305edcde1ff938ecdc5727c9374f8ec7c7a94aa),
  merged into this fork in [PR #1](https://github.com/michaellee4/JankyBorders/pull/1).
- The backport changes seven source files. Andrew's unrelated glow, gradient,
  and fade features are excluded.
- Verified on macOS **27.0 (26A428)** with **two monitors**: three Mission Control
  open/close cycles successfully hid and restored the borders on November 7, 2026.

### Installed build and future updates

The [Homebrew formula](Formula/borders-fixed.rb) builds the pinned source commit
`6305edcde1ff938ecdc5727c9374f8ec7c7a94aa` and labels the binary
**`borders-v1.9.0-mc1`**. The package is `michaellee4/borders/borders-fixed`;
the executable is still named `borders` and uses `~/.config/borders/bordersrc`.

For future code changes, update the formula's source commit, SHA-256, package
version, and binary version marker, then rebuild/install and restart the service.
Editing GitHub's `main` branch alone does not update the installed binary.

Before returning to the official package, confirm an upstream release includes
the fix and test Mission Control entry/exit and monitor switching. This fork can
be retired once the official release works correctly in that setup.

## Install this fork

```sh
brew tap michaellee4/borders https://github.com/michaellee4/JankyBorders.git
# When replacing an installed official Borders package:
brew services stop felixkratz/formulae/borders
brew unlink felixkratz/formulae/borders
brew install michaellee4/borders/borders-fixed
brew services start michaellee4/borders/borders-fixed
borders --version
```

The original `felixkratz/formulae/borders` package was retained as an installed,
unlinked rollback copy, with its service stopped. It is not a dependency of the
patched package. To switch back while that original package is still installed:

```sh
brew services stop michaellee4/borders/borders-fixed
brew unlink michaellee4/borders/borders-fixed
brew link felixkratz/formulae/borders
brew services start felixkratz/formulae/borders
```

## Upstream usage reference

The following text is preserved from upstream. Its installation and service
commands select the official package; use the commands above for this fork.

<img align="right" width="50%" src="images/screenshot.png" alt="Screenshot">

*JankyBorders* is a lightweight tool designed to add colored borders to
user windows on macOS 14.0+. It enhances the user experience by visually
highlighting the currently focused window without relying on the accessibility
API, thereby being faster than comparable tools.

### Install
The binary can be made available by installing it through Homebrew:
```bash
brew tap FelixKratz/formulae
brew install borders
```

For a comprehensive overview of all available options and commands, consult the
man page: `man borders`. A rendered version of the man page is available in the
[Wiki](https://github.com/FelixKratz/JankyBorders/wiki/Man-Page).

### Bootstrap with yabai
For example, if you are using `yabai`, you could add:
```bash
borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0 &
```
to the very end of your `yabairc`. This will start the borders with the
specified options along with yabai.

### Bootstrap with AeroSpace
You could add:
```toml
after-startup-command = [
  'exec-and-forget borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0'
]
```
to you `aerospace.toml`. This will start borders with the specified options
along with AeroSpace.

### Bootstrap with brew
If you want to run this as a separate service, you could use:
```bash
brew services start borders
```

### Configuring the appearance
You can either configure the appearance directly when starting the borders
process (as shown in "Bootstrap with yabai") or use a configuration file.
The appearance can be adapted at any point in time.

#### Using a configuration file (Optional)
If the primary `borders` process is started without any arguments (or launched
as a service by brew), it will search for a file at
`~/.config/borders/bordersrc` and execute it on launch if found.

An example configuration file could look like this:
`~/.config/borders/bordersrc`
```bash
#!/bin/bash

options=(
	style=round
	width=6.0
	hidpi=off
	active_color=0xffe2e2e3
	inactive_color=0xff414550
)

borders "${options[@]}"
```

#### Updating the border properties during runtime
If a `borders` process is already running, invoking a new `borders` instance
with any combination of the available options will update the properties of
the already running instance.

## Documentation
Local documentation is available as `man borders` and as a rendered version in
the [Wiki](https://github.com/FelixKratz/JankyBorders/wiki/Man-Page).
