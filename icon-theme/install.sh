#! /usr/bin/env bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

THEME_NAME=Colloid
COLOR_VARIANTS=('' '-dark')
THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-grey')

usage() {
cat << EOF
  Usage: $0 [OPTION]...

  OPTIONS:
    -d, --dest DIR          Specify destination directory (Default: $DEST_DIR)
    -n, --name NAME         Specify theme name (Default: $THEME_NAME)
    -t, --theme VARIANT     Specify theme color variant(s) [default|purple|pink|red|orange|yellow|green|grey|all] (Default: blue)
    -h, --help              Show help
EOF
}

install() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}

  local THEME_DIR=${dest}/${name}${theme}${color}

  [[ -d ${THEME_DIR} ]] && rm -rf ${THEME_DIR}

  echo "Installing '${THEME_DIR}'..."

  mkdir -p                                                                                 ${THEME_DIR}
  cp -r ${SRC_DIR}/src/index.theme                                                         ${THEME_DIR}

  cd ${THEME_DIR}
  sed -i "s/${name}/${name}${theme}${color}/g" index.theme
  sed -i "s/WhiteSur/WhiteSur${color}/g" index.theme

  if [[ ${color} == '' ]]; then
    cp -r ${SRC_DIR}/src/*                                                                 ${THEME_DIR}
    cp -r ${SRC_DIR}/links/*                                                               ${THEME_DIR}

    if [[ ${theme} != '' ]]; then
      cp -r ${SRC_DIR}/colors/color${theme}/*.svg                                          ${THEME_DIR}/places/scalable
    fi
  fi

  if [[ ${color} == '-dark' ]]; then
    mkdir -p                                                                               ${THEME_DIR}/{apps,categories,devices,mimetypes,places,status}
    cp -r ${SRC_DIR}/src/actions                                                           ${THEME_DIR}
    cp -r ${SRC_DIR}/src/apps/symbolic                                                     ${THEME_DIR}/apps
    cp -r ${SRC_DIR}/src/categories/symbolic                                               ${THEME_DIR}/categories
    cp -r ${SRC_DIR}/src/mimetypes/symbolic                                                ${THEME_DIR}/mimetypes
    cp -r ${SRC_DIR}/src/devices/{16,22,24,symbolic}                                       ${THEME_DIR}/devices
    cp -r ${SRC_DIR}/src/places/{16,22,24,symbolic}                                        ${THEME_DIR}/places
    cp -r ${SRC_DIR}/src/status/{16,22,24,symbolic}                                        ${THEME_DIR}/status

    # Change icon color for dark theme
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,devices,places,status}/{16,22,24}/*
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/actions/32/*
    sed -i "s/#363636/#dedede/g" "${THEME_DIR}"/{actions,apps,categories,devices,mimetypes,places,status}/symbolic/*

    cp -r ${SRC_DIR}/links/actions/{16,22,24,32,symbolic}                              ${THEME_DIR}/actions
    cp -r ${SRC_DIR}/links/devices/{16,22,24,symbolic}                                 ${THEME_DIR}/devices
    cp -r ${SRC_DIR}/links/places/{16,22,24,symbolic}                                  ${THEME_DIR}/places
    cp -r ${SRC_DIR}/links/status/{16,22,24,symbolic}                                  ${THEME_DIR}/status
    cp -r ${SRC_DIR}/links/apps/symbolic                                               ${THEME_DIR}/apps
    cp -r ${SRC_DIR}/links/categories/symbolic                                         ${THEME_DIR}/categories
    cp -r ${SRC_DIR}/links/mimetypes/symbolic                                          ${THEME_DIR}/mimetypes

    cd ${dest}
    ln -s ../../${name}${theme}/apps/scalable ${name}${theme}-dark/apps/scalable
    ln -s ../../${name}${theme}/devices/scalable ${name}${theme}-dark/devices/scalable
    ln -s ../../${name}${theme}/places/scalable ${name}${theme}-dark/places/scalable
    ln -s ../../${name}${theme}/categories/32 ${name}${theme}-dark/categories/32
    ln -s ../../${name}${theme}/mimetypes/scalable ${name}${theme}-dark/mimetypes/scalable
  fi

  (
    cd ${THEME_DIR}
    ln -sf actions actions@2x
    ln -sf apps apps@2x
    ln -sf categories categories@2x
    ln -sf devices devices@2x
    ln -sf mimetypes mimetypes@2x
    ln -sf places places@2x
    ln -sf status status@2x
  )

  gtk-update-icon-cache ${THEME_DIR}
}

while [[ "$#" -gt 0 ]]; do
  case "${1:-}" in
    -d|--dest)
      dest="$2"
      mkdir -p "$dest"
      shift 2
      ;;
    -n|--name)
      name="${2}"
      shift 2
      ;;
    -t|--theme)
      shift
      for theme in "${@}"; do
        case "${theme}" in
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
          grey)
            themes+=("${THEME_VARIANTS[7]}")
            shift
            ;;
          all)
            themes+=("${THEME_VARIANTS[@]}")
            shift
            ;;
          -*|--*)
            break
            ;;
          *)
            prompt -e "ERROR: Unrecognized theme variant '$1'."
            prompt -i "Try '$0 --help' for more information."
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
      echo "ERROR: Unrecognized installation option '$1'."
      echo "Try '$0 --help' for more information."
      exit 1
      ;;
  esac
done

if [[ "${#themes[@]}" -eq 0 ]] ; then
  themes=("${THEME_VARIANTS[0]}")
fi

if [[ "${#colors[@]}" -eq 0 ]] ; then
  colors=("${COLOR_VARIANTS[@]}")
fi

install_theme() {
  for theme in "${themes[@]}"; do
    for color in "${colors[@]}"; do
      install "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}"
    done
  done
}

install_theme
