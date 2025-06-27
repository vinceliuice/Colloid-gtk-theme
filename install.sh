#! /usr/bin/env bash

set -Eeo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
SRC_DIR="${REPO_DIR}/src"

source "${REPO_DIR}/gtkrc.sh"
source "${REPO_DIR}/assets.sh"

ROOT_UID=0
DEST_DIR=

scheme=
window=

# Destination directory
if [[ "$UID" -eq "$ROOT_UID" ]]; then
  DEST_DIR="/usr/share/themes"
elif [[ -n "$XDG_DATA_HOME" ]]; then
  DEST_DIR="$XDG_DATA_HOME/themes"
elif [[ -d "$HOME/.themes" ]]; then
  DEST_DIR="$HOME/.themes"
elif [[ -d "$HOME/.local/share/themes" ]]; then
  DEST_DIR="$HOME/.local/share/themes"
else
  DEST_DIR="$HOME/.themes"
fi

SASSC_OPT="-M -t expanded"

THEME_NAME=Colloid
THEME_VARIANTS=('' '-Purple' '-Pink' '-Red' '-Orange' '-Yellow' '-Green' '-Teal' '-Grey')
SCHEME_VARIANTS=('' '-Nord' '-Dracula' '-Gruvbox' '-Everforest' '-Catppuccin')
COLOR_VARIANTS=('' '-Light' '-Dark')
SIZE_VARIANTS=('' '-Compact')

if [[ "$(command -v gnome-shell)" ]]; then
  echo && gnome-shell --version

  SHELL_VERSION="$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f -1)"

  if [[ "${SHELL_VERSION:-}" -ge "48" ]]; then
    GS_VERSION="48-0"
  elif [[ "${SHELL_VERSION:-}" -ge "47" ]]; then
    GS_VERSION="47-0"
  elif [[ "${SHELL_VERSION:-}" -ge "46" ]]; then
    GS_VERSION="46-0"
  elif [[ "${SHELL_VERSION:-}" -ge "44" ]]; then
    GS_VERSION="44-0"
  elif [[ "${SHELL_VERSION:-}" -ge "42" ]]; then
    GS_VERSION="42-0"
  elif [[ "${SHELL_VERSION:-}" -ge "40" ]]; then
    GS_VERSION="40-0"
  else
    GS_VERSION="3-28"
  fi
else
  echo "'gnome-shell' not found, using styles for last gnome-shell version available."
  GS_VERSION="48-0"
fi

usage() {
cat << EOF
Usage: $0 [OPTION]...

OPTIONS:
  -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)

  -n, --name NAME         Specify theme name (Default: $THEME_NAME)

  -t, --theme VARIANT     Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|teal|grey|all] (Default: blue)

  -c, --color VARIANT     Specify color variant(s) [standard|light|dark] (Default: All variants))

  -s, --size VARIANT      Specify size variant [standard|compact] (Default: standard variant)

  -l, --libadwaita        Install specify gtk-4.0 theme into config folder ($HOME/.config/gtk-4.0) for all gtk4 apps use this theme
                          Default ColorSchemes theme will follow the system style (light/dark mode switch), all ColorSchemes versions not support this !
                          Options for default ColorSchemes:
                          1. system                      Default option (using system colors for light/dark mode switching)
                          2. fixed                       Using fixed theme colors (that will break light/dark mode switch)

  --tweaks                Specify versions for tweaks
                          1. [nord|dracula|gruvbox|everforest|catppuccin|all]  (Nord/Dracula/Gruvbox/Everforest/Catppuccin/all) ColorSchemes version
                          2. black                       Blackness color version
                          3. rimless                     Remove the 1px border about windows and menus
                          4. normal                      Normal windows button style like gnome default theme (titlebuttons: max/min/close)
                          5. float                       Floating gnome-shell panel style

  -r, --remove,
  -u, --uninstall         Uninstall/Remove installed themes or links

  -h, --help              Show help
EOF
}

install() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local color="${4}"
  local size="${5}"
  local scheme="${6}"
  local window="${7}"

  [[ "${color}" == '-Light' ]] && local ELSE_LIGHT="${color}"
  [[ "${color}" == '-Dark' ]] && local ELSE_DARK="${color}"

  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  [[ -d "${THEME_DIR}" ]] && rm -rf "${THEME_DIR}"{'','-hdpi','-xhdpi'}

  echo "Installing '${THEME_DIR}'..."

  theme_tweaks

  mkdir -p                                                                                   "${THEME_DIR}"

  echo "[Desktop Entry]" >>                                                                  "${THEME_DIR}/index.theme"
  echo "Type=X-GNOME-Metatheme" >>                                                           "${THEME_DIR}/index.theme"
  echo "Name=${2}${3}${4}${5}${6}" >>                                                        "${THEME_DIR}/index.theme"
  echo "Comment=An Flat Gtk+ theme based on Elegant Design" >>                               "${THEME_DIR}/index.theme"
  echo "Encoding=UTF-8" >>                                                                   "${THEME_DIR}/index.theme"
  echo "" >>                                                                                 "${THEME_DIR}/index.theme"
  echo "[X-GNOME-Metatheme]" >>                                                              "${THEME_DIR}/index.theme"
  echo "GtkTheme=${2}${3}${4}${5}${6}" >>                                                    "${THEME_DIR}/index.theme"
  echo "MetacityTheme=${2}${3}${4}${5}${6}" >>                                               "${THEME_DIR}/index.theme"
  echo "IconTheme=Colloid${3}${6}${4}" >>                                                    "${THEME_DIR}/index.theme"
  echo "CursorTheme=${2}-cursors" >>                                                         "${THEME_DIR}/index.theme"
  echo "ButtonLayout=close,minimize,maximize:menu" >>                                        "${THEME_DIR}/index.theme"

  mkdir -p                                                                                   "${THEME_DIR}/gnome-shell"
  cp -r "${SRC_DIR}/main/gnome-shell/pad-osd.css"                                            "${THEME_DIR}/gnome-shell"
  sassc $SASSC_OPT "${SRC_DIR}/main/gnome-shell/gnome-shell${color}.scss"                    "${THEME_DIR}/gnome-shell/gnome-shell.css"

  mkdir -p                                                                                   "${THEME_DIR}/gtk-2.0"
  # cp -r "${SRC_DIR}/main/gtk-2.0/gtkrc${theme}${ELSE_DARK:-}${scheme}"                       "${THEME_DIR}/gtk-2.0/gtkrc"
  cp -r "${SRC_DIR}/main/gtk-2.0/common/"*'.rc'                                              "${THEME_DIR}/gtk-2.0"

  mkdir -p                                                                                   "${THEME_DIR}/gtk-3.0"
  sassc $SASSC_OPT "${SRC_DIR}/main/gtk-3.0/gtk${color}.scss"                                "${THEME_DIR}/gtk-3.0/gtk.css"
  sassc $SASSC_OPT "${SRC_DIR}/main/gtk-3.0/gtk-Dark.scss"                                   "${THEME_DIR}/gtk-3.0/gtk-dark.css"

  mkdir -p                                                                                   "${THEME_DIR}/gtk-4.0"
  sassc $SASSC_OPT "${SRC_DIR}/main/gtk-4.0/gtk${color}.scss"                                "${THEME_DIR}/gtk-4.0/gtk.css"
  sassc $SASSC_OPT "${SRC_DIR}/main/gtk-4.0/gtk-Dark.scss"                                   "${THEME_DIR}/gtk-4.0/gtk-dark.css"

  mkdir -p                                                                                   "${THEME_DIR}/cinnamon"
  sassc $SASSC_OPT "${SRC_DIR}/main/cinnamon/cinnamon${color}.scss"                          "${THEME_DIR}/cinnamon/cinnamon.css"

  mkdir -p                                                                                   "${THEME_DIR}/metacity-1"
  cp -r "${SRC_DIR}/main/metacity-1/metacity-theme-3${window}.xml"                           "${THEME_DIR}/metacity-1/metacity-theme-3.xml"
  cd "${THEME_DIR}/metacity-1" && ln -sf metacity-theme-3.xml metacity-theme-1.xml && ln -sf metacity-theme-3.xml metacity-theme-2.xml

  mkdir -p                                                                                   "${THEME_DIR}/xfwm4"
  cp -r "${SRC_DIR}/main/xfwm4/themerc"                                                      "${THEME_DIR}/xfwm4/themerc"
  mkdir -p                                                                                   "${THEME_DIR}-hdpi/xfwm4"
  cp -r "${SRC_DIR}/main/xfwm4/themerc"                                                      "${THEME_DIR}-hdpi/xfwm4/themerc"
  sed -i "s/button_offset=6/button_offset=9/"                                                "${THEME_DIR}-hdpi/xfwm4/themerc"
  mkdir -p                                                                                   "${THEME_DIR}-xhdpi/xfwm4"
  cp -r "${SRC_DIR}/main/xfwm4/themerc"                                                      "${THEME_DIR}-xhdpi/xfwm4/themerc"
  sed -i "s/button_offset=6/button_offset=12/"                                               "${THEME_DIR}-xhdpi/xfwm4/themerc"

  mkdir -p                                                                                   "${THEME_DIR}/labwc"
  cp "${SRC_DIR}/main/labwc/themerc${color}${scheme}"                                        "${THEME_DIR}/labwc/themerc"
  cp -r "${SRC_DIR}/assets/labwc/assets${color}/"*.svg                                       "${THEME_DIR}/labwc/"

  mkdir -p                                                                                   "${THEME_DIR}/plank"
  if [[ "$color" == '-Light' ]]; then
    cp -r "${SRC_DIR}/main/plank/theme-Light${scheme}/"*                                     "${THEME_DIR}/plank"
  else
    cp -r "${SRC_DIR}/main/plank/theme-Dark${scheme}/"*                                      "${THEME_DIR}/plank"
  fi
}

themes=()
colors=()
sizes=()
lcolors=()
schemes=()

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -d|--dest)
      dest="${2}"
      if [[ ! -d "${dest}" ]]; then
        echo -e "\nDestination directory does not exist. Let's make a new one..."
        mkdir -p ${dest}
      fi
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -r|--remove|-u|--uninstall)
      uninstall="true"
      shift
      ;;
    -l|--libadwaita)
      libadwaita="true"
      shift
      for type in "${@}"; do
        case "${type}" in
          system)
            echo -e "\nUse system default colors for light/dark mode switch."
            shift
            ;;
          fixed)
            colortype='fixed'
            echo -e "\nUse fixed theme colors but that will break light/dark mode switch."
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            echo -e "\nERROR: Unrecognized type variant '$1'."
            echo -e "\nTry '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -c|--color)
      shift
      for color in "${@}"; do
        case "${color}" in
          standard)
            colors+=("${COLOR_VARIANTS[0]}")
            lcolors+=("${COLOR_VARIANTS[0]}")
            shift
            ;;
          light)
            colors+=("${COLOR_VARIANTS[1]}")
            lcolors+=("${COLOR_VARIANTS[1]}")
            shift
            ;;
          dark)
            colors+=("${COLOR_VARIANTS[2]}")
            lcolors+=("${COLOR_VARIANTS[2]}")
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            echo -e "\nERROR: Unrecognized color variant '$1'."
            echo -e "\nTry '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -t|--theme)
      accent='true'
      shift
      for variant in "$@"; do
        case "$variant" in
          default)
            themes+=("${THEME_VARIANTS[0]}")
            shift
            ;;
          purple)
            themes+=("${THEME_VARIANTS[1]}")
            shift
            ;;
          pink)
            themes+=("${THEME_VARIANTS[2]}")
            shift
            ;;
          red)
            themes+=("${THEME_VARIANTS[3]}")
            shift
            ;;
          orange)
            themes+=("${THEME_VARIANTS[4]}")
            shift
            ;;
          yellow)
            themes+=("${THEME_VARIANTS[5]}")
            shift
            ;;
          green)
            themes+=("${THEME_VARIANTS[6]}")
            shift
            ;;
          teal)
            themes+=("${THEME_VARIANTS[7]}")
            shift
            ;;
          grey)
            themes+=("${THEME_VARIANTS[8]}")
            shift
            ;;
          all)
            themes+=("${THEME_VARIANTS[@]}")
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo -e "\nERROR: Unrecognized theme variant '$1'."
            echo -e "\nTry '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -s|--size)
      shift
      for variant in "$@"; do
        case "$variant" in
          standard)
            sizes+=("${SIZE_VARIANTS[0]}")
            shift
            ;;
          compact)
            sizes+=("${SIZE_VARIANTS[1]}")
            compact='true'
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo -e "\nERROR: Unrecognized size variant '${1:-}'."
            echo -e "\nTry '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    --tweaks)
      shift
      for variant in $@; do
        case "$variant" in
          nord)
            colorscheme='true'
            schemes+=("${SCHEME_VARIANTS[1]}")
            echo -e "\nNord ColorScheme version! ..."
            shift
            ;;
          dracula)
            colorscheme='true'
            schemes+=("${SCHEME_VARIANTS[2]}")
            echo -e "\nDracula ColorScheme version! ..."
            shift
            ;;
          gruvbox)
            colorscheme='true'
            schemes+=("${SCHEME_VARIANTS[3]}")
            echo -e "\nGruvbox ColorScheme version! ..."
            shift
            ;;
          everforest)
            colorscheme='true'
            schemes+=("${SCHEME_VARIANTS[4]}")
            echo -e "\nEverforest ColorScheme version! ..."
            shift
            ;;
          catppuccin)
            colorscheme='true'
            schemes+=("${SCHEME_VARIANTS[5]}")
            echo -e "\nCatppuccin ColorScheme version! ..."
            shift
            ;;
          all)
            colorscheme='true'
            schemes+=("${SCHEME_VARIANTS[@]}")
            shift
            ;;
          black)
            blackness="true"
            echo -e "\nBlackness version! ..."
            shift
            ;;
          rimless)
            rimless="true"
            echo -e "\nRimless version! ..."
            shift
            ;;
          normal)
            normal="true"
            window="-Normal"
            echo -e "\nNormal window button version! ..."
            shift
            ;;
          float)
            float="true"
            echo -e "\nInstall Floating Gnome-Shell Panel version! ..."
            shift
            ;;
          -*)
            break
            ;;
          *)
            echo -e "\nERROR: Unrecognized tweaks variant '$1'."
            echo -e "\nTry '$0 --help' for more information."
            exit 1
            ;;
        esac
      done
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo -e "\nERROR: Unrecognized installation option '$1'."
      echo -e "\nTry '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#themes[@]}" -eq 0 ]]; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]]; then
  colors=("${COLOR_VARIANTS[@]}")
fi

if [[ "${#lcolors[@]}" -eq 0 ]]; then
  lcolors=("${COLOR_VARIANTS[1]}")
fi

if [[ "${#sizes[@]}" -eq 0 ]]; then
  sizes=("${SIZE_VARIANTS[0]}")
fi

if [[ "${#schemes[@]}" -eq 0 ]]; then
  schemes=("${SCHEME_VARIANTS[0]}")
fi

#  Check command avalibility
function has_command() {
  command -v $1 > /dev/null
}

#  Install needed packages
install_package() {
  if ! has_command sassc; then
    echo sassc needs to be installed to generate the css.
    if has_command zypper; then
      sudo zypper in sassc
    elif has_command apt; then
      sudo apt install sassc
    elif has_command apt-get; then
      sudo apt-get install sassc
    elif has_command dnf; then
      sudo dnf install sassc
    elif has_command yum; then
      sudo yum install sassc
    elif has_command pacman; then
      sudo pacman -S --noconfirm sassc
    elif has_command xbps-install; then
      sudo xbps-install -y sassc
    fi
  fi
}

tweaks_temp() {
  cp -rf "${SRC_DIR}/sass/_tweaks.scss" "${SRC_DIR}/sass/_tweaks-temp.scss"
}

compact_size() {
  sed -i "/\$compact:/s/false/true/" "${SRC_DIR}/sass/_tweaks-temp.scss"
}

color_schemes() {
  if [[ "$scheme" != '' ]]; then
    case "$scheme" in
      -Nord)
        scheme_color='nord'
        ;;
      -Dracula)
        scheme_color='dracula'
        ;;
      -Gruvbox)
        scheme_color='gruvbox'
        ;;
      -Everforest)
        scheme_color='everforest'
        ;;
      -Catppuccin)
        scheme_color='catppuccin'
        ;;
    esac
    sed -i "/\@import/s/color-palette-default/color-palette-${scheme_color}/" "${SRC_DIR}/sass/_tweaks-temp.scss"
    sed -i "/\$colorscheme:/s/default/${scheme_color}/" "${SRC_DIR}/sass/_tweaks-temp.scss"
  fi
}

color_type() {
  sed -i "/\$colortype:/s/system/fixed/" "${SRC_DIR}/sass/_tweaks-temp.scss"
}

blackness_color() {
  sed -i "/\$blackness:/s/false/true/" "${SRC_DIR}/sass/_tweaks-temp.scss"
}

border_rimless() {
  sed -i "/\$rimless:/s/false/true/" "${SRC_DIR}/sass/_tweaks-temp.scss"
}

normal_winbutton() {
  sed -i "/\$window_button:/s/mac/normal/" "${SRC_DIR}/sass/_tweaks-temp.scss"
}

float_panel() {
  sed -i "/\$float:/s/false/true/" "${SRC_DIR}/sass/_tweaks-temp.scss"
}

gnome_shell_version() {
  cp -rf "${SRC_DIR}/sass/gnome-shell/_common.scss" "${SRC_DIR}/sass/gnome-shell/_common-temp.scss"

  sed -i "/\widgets/s/40-0/${GS_VERSION}/" "${SRC_DIR}/sass/gnome-shell/_common-temp.scss"

  if [[ "${GS_VERSION}" == '3-28' ]]; then
    sed -i "/\extensions/s/40-0/3-28/" "${SRC_DIR}/sass/gnome-shell/_common-temp.scss"
  elif [[ "${GS_VERSION}" -ge '46-0' ]]; then
    sed -i "/\extensions/s/40-0/46-0/" "${SRC_DIR}/sass/gnome-shell/_common-temp.scss"
  fi

  if [[ "${SHELL_VERSION:-}" -ge "47" ]]; then
    sed -i "/\gnome_version/s/default/new/" "${SRC_DIR}/sass/_tweaks-temp.scss"
  fi
}

theme_color() {
  if [[ "$theme" != '' ]]; then
    case "$theme" in
      -Purple)
        theme_color='purple'
        ;;
      -Pink)
        theme_color='pink'
        ;;
      -Red)
        theme_color='red'
        ;;
      -Orange)
        theme_color='orange'
        ;;
      -Yellow)
        theme_color='yellow'
        ;;
      -Green)
        theme_color='green'
        ;;
      -Teal)
        theme_color='teal'
        ;;
      -Grey)
        theme_color='grey'
        ;;
    esac
    sed -i "/\$theme:/s/default/${theme_color}/" "${SRC_DIR}/sass/_tweaks-temp.scss"
  fi
}

theme_tweaks() {
  if [[ "$accent" = "true" || "$colorscheme" = "true" ]]; then
    tweaks_temp
  fi

  if [[ "$accent" = "true" ]]; then
    theme_color
  fi

  if [[ "$compact" = "true" ]]; then
    compact_size
  fi

  if [[ "$colortype" = "fixed" ]] ; then
    color_type
  fi

  if [[ "$colorscheme" = "true" ]] ; then
    color_schemes
  fi

  if [[ "$blackness" = "true" ]]; then
    blackness_color
  fi

  if [[ "$rimless" = "true" ]]; then
    border_rimless
  fi

  if [[ "$normal" = "true" ]]; then
    normal_winbutton
  fi

  if [[ "$float" = "true" ]]; then
    float_panel
  fi
}

uninstall_libadwaita() {
  rm -rf "${HOME}/.config/gtk-4.0/"{assets,windows-assets,gtk.css,gtk-dark.css,gtk-Light.css,gtk-Dark.css}
}

link_libadwaita() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local color="${4}"
  local size="${5}"
  local scheme="${6}"

  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  rm -rf "${HOME}/.config/gtk-4.0/"{assets,gtk.css,gtk-dark.css}

  echo -e "\nLink '${THEME_DIR}/gtk-4.0' to '${HOME}/.config/gtk-4.0' for libadwaita...\n"

  mkdir -p                                                                      "${HOME}/.config/gtk-4.0"
  ln -sf "${THEME_DIR}/gtk-4.0/assets"                                          "${HOME}/.config/gtk-4.0/assets"
  ln -sf "${THEME_DIR}/gtk-4.0/gtk.css"                                         "${HOME}/.config/gtk-4.0/gtk.css"
  ln -sf "${THEME_DIR}/gtk-4.0/gtk-dark.css"                                    "${HOME}/.config/gtk-4.0/gtk-dark.css"
}

libadwaita_theme() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local color="${4}"
  local size="${5}"
  local scheme="${6}"

  theme_tweaks

  rm -rf "${HOME}/.config/gtk-4.0/"{assets,gtk.css,gtk-dark.css}

  echo -e "\nInstalling ${2}${3}${4}${5}${6} theme into '${HOME}/.config/gtk-4.0' for libadwaita..."

  mkdir -p                                                                      "${HOME}/.config/gtk-4.0"
  cp -r "${SRC_DIR}/assets/gtk/assets"                                          "${HOME}/.config/gtk-4.0"
  cp -r "${SRC_DIR}/assets/gtk/symbolics/"*'.svg'                               "${HOME}/.config/gtk-4.0/assets"

  if [[ "$colorscheme" = "true" || "$blackness" = "true" || "$colortype" = "fixed" ]] ; then
    sassc $SASSC_OPT "${SRC_DIR}/main/libadwaita/libadwaita${color}.scss"       "${HOME}/.config/gtk-4.0/gtk.css"
  else
    sassc $SASSC_OPT "${SRC_DIR}/main/libadwaita/libadwaita-Light.scss"         "${HOME}/.config/gtk-4.0/gtk.css"
  fi
}

link_theme() {
  for theme in "${themes[@]}"; do
    for color in "${lcolors[@]}"; do
      for size in "${sizes[@]}"; do
        for scheme in "${schemes[@]}"; do
          link_libadwaita "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme"
        done
      done
    done
  done
}

install_libadwaita() {
  for theme in "${themes[@]}"; do
    for color in "${lcolors[@]}"; do
      for size in "${sizes[@]}"; do
        for scheme in "${schemes[@]}"; do
          libadwaita_theme "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme"
        done
      done
    done
  done
}

install_theme() {
  for theme in "${themes[@]}"; do
    for color in "${colors[@]}"; do
      for size in "${sizes[@]}"; do
        for scheme in "${schemes[@]}"; do
          install "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme" "$window"
          make_gtkrc "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme" "$window"
          make_assets "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme" "$window"
        done
      done
    done
  done

  if (command -v xfce4-popup-whiskermenu &> /dev/null) && $(sed -i "s|.*menu-opacity=.*|menu-opacity=95|" "$HOME/.config/xfce4/panel/whiskermenu"*".rc" &> /dev/null); then
    sed -i "s|.*menu-opacity=.*|menu-opacity=95|" "$HOME/.config/xfce4/panel/whiskermenu"*".rc"
  fi

  if (pgrep xfce4-session &> /dev/null); then
    xfce4-panel -r
  fi
}

uninstall() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local color="${4}"
  local size="${5}"
  local scheme="${6}"

  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  if [[ "$uninstall" == 'true' ]]; then
    type='Uninstall'
  else
    type='Clean'
  fi

  if [[ -d "${THEME_DIR}" ]]; then
    echo -e "${type} ${THEME_DIR}... "
    rm -rf "${THEME_DIR}"{'','-hdpi','-xhdpi'}
  fi
}

uninstall_theme() {
  for theme in "${THEME_VARIANTS[@]}"; do
    for color in "${COLOR_VARIANTS[@]}"; do
      for size in "${SIZE_VARIANTS[@]}"; do
        for scheme in "${SCHEME_VARIANTS[@]}"; do
          uninstall "${dest:-$DEST_DIR}" "${name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme"
        done
      done
    done
  done
}

clean_theme() {
  if [[ "$UID" != "$ROOT_UID" ]]; then
    if [[ "$DEST_DIR" == "$HOME/.themes" ]]; then
      local dest="$HOME/.local/share/themes"
    elif [[ "$DEST_DIR" == "$XDG_DATA_HOME/themes" || "$DEST_DIR" == "$HOME/.local/share/themes" ]]; then
      local dest="$HOME/.themes"
    fi

    for theme in "${themes[@]}"; do
      for color in "${colors[@]}"; do
        for size in "${sizes[@]}"; do
          for scheme in "${schemes[@]}"; do
            uninstall "${dest}" "${name:-$THEME_NAME}" "$theme" "$color" "$size" "$scheme"
          done
        done
      done
    done
  fi
}

if [[ "$uninstall" == 'true' ]]; then
  if [[ "$libadwaita" == 'true' ]]; then
    echo -e "\nUninstall libadwaita theme from ${HOME}/.config/gtk-4.0 ..."
    uninstall_libadwaita
  else
    echo && uninstall_theme && uninstall_libadwaita
  fi
else
  install_package && tweaks_temp
  gnome_shell_version && echo && clean_theme && install_theme

  if [[ "$libadwaita" == 'true' ]]; then
    uninstall_libadwaita && install_libadwaita
  fi
fi

echo
echo Done.
