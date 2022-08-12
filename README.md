## Colloid gtk theme

![Colloid](colloid.png?raw=true)

## Requirements

- GTK `>=3.20`
- `gnome-themes-extra` (or `gnome-themes-standard`)
- Murrine engine — The package name depends on the distro.
  - `gtk-engine-murrine` on Arch Linux
  - `gtk-murrine-engine` on Fedora
  - `gtk2-engine-murrine` on openSUSE
  - `gtk2-engines-murrine` on Debian, Ubuntu, etc.
- `sassc` — build dependency

- `Icon theme` [Colloid](https://github.com/vinceliuice/Colloid-icon-theme)

## Installation

### Manual Installation

Run the following commands in the terminal:

```sh
./install.sh
```

> Tip: `./install.sh` allows the following options:

```
-d, --dest DIR          Specify destination directory (Default: ~/.themes)
-n, --name NAME         Specify theme name (Default: Colloid)
-t, --theme VARIANT...  Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|teal|grey|all] (Default: blue)
-c, --color VARIANT...  Specify color variant(s) [standard|light|dark] (Default: All variants)
-s, --size VARIANT...   Specify size variant [standard|compact] (Default: standard variant)
-u, --uninstall         Uninstall theme variant [theme|libadwaita] (Default: theme variant)
--tweaks                Specify versions for tweaks [nord|dracula|black|rimless|normal] (only nord and dracula can not mix use with!)
                        1. nord:     Nord ColorScheme version
                        2. dracula   Dracula ColorScheme version
                        3. black:    Blackness color version
                        4. rimless:  Remove the 1px border about windows and menus
                        5. normal:   Normal windows button style (titlebuttons: max/min/close)
-h, --help              Show help
```

> For more information, run: `./install.sh --help`

![tweaks](tweaks.png?raw=true)

### Flatpak Installation

Automatically install your host GTK+ theme as a Flatpak. Use this:

- [pakitheme](https://github.com/refi64/pakitheme)

## Firefox theme
[Install Firefox theme](src/other/firefox)

![01](src/other/firefox/screenshot.png?raw=true)
