#! /usr/bin/env bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/themes"
else
  DEST_DIR="$HOME/.themes"
fi

THEME_NAME=Colloid
THEME_VARIANTS=('' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-teal' '-grey')
COLOR_VARIANTS=('' '-light' '-dark')
SIZE_VARIANTS=('' '-compact')
TYPE_VARIANTS=('' '-nord' '-dracula')
SCREEN_VARIANTS=('' '-hdpi' '-xhdpi')

clean() {
  local dest=${1}
  local name=${2}
  local theme=${3}
  local color=${4}
  local size=${5}
  local type=${6}
  local screen=${7}

  local THEME_DIR=${dest}/${name}${theme}${color}${size}${type}${screen}

  if [[ ${theme} == '' && ${color} == '' && ${size} == '' && ${type} == '' ]]; then
    cleantheme='none'
  elif [[ -d ${THEME_DIR} ]]; then
    rm -rf ${THEME_DIR}
    echo -e "Find: ${THEME_DIR} ! removing it ..."
  fi
}

clean_theme() {
  for theme in "${themes[@]-${THEME_VARIANTS[@]}}"; do
    for color in "${colors[@]-${COLOR_VARIANTS[@]}}"; do
      for size in "${sizes[@]-${SIZE_VARIANTS[@]}}"; do
        for type in "${types[@]-${TYPE_VARIANTS[@]}}"; do
          for screen in "${screens[@]-${SCREEN_VARIANTS[@]}}"; do
            clean "${dest:-${DEST_DIR}}" "${name:-${THEME_NAME}}" "${theme}" "${color}" "${size}" "${type}" "${screen}"
          done
        done
      done
    done
  done
}

clean_theme

exit 0
