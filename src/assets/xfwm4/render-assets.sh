#! /usr/bin/env bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

INDEX="assets.txt"

./make-assets.sh

for i in `cat $INDEX`; do
  for color in '' '-Light'; do
    for type in '' '-Nord' '-Dracula' '-Gruvbox'; do
      for window in '' '-Normal'; do
        for screen in '' '-hdpi' '-xhdpi'; do
          ASSETS_DIR="assets${color}${type}${window}${screen}"
          SRC_FILE="assets${color}${type}${window}.svg"

          case "${screen}" in
            -hdpi)
              DPI='144'
              ;;
            -xhdpi)
              DPI='192'
               ;;
            *)
              DPI='96'
              ;;
          esac

          mkdir -p $ASSETS_DIR

          if [ -f $ASSETS_DIR/$i.png ]; then
              echo $ASSETS_DIR/$i.png exists.
          else
              echo
              echo Rendering $ASSETS_DIR/$i.png
              $INKSCAPE --export-id=$i \
                        --export-id-only \
                        --export-dpi=$DPI \
                        --export-filename=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null \
              && $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png
          fi
        done
      done
    done
  done
done

for color in '' '-Light'; do
  for type in '' '-Nord' '-Dracula' '-Gruvbox'; do
    for window in '' '-Normal'; do
      if [[ "${type}" == '' ]]; then
        echo "keep assets.svg file..."
      else
        ASSETS_FILE="assets${color}${type}${window}.svg"
        rm -rf "${ASSETS_FILE}"
      fi
    done
  done
done

exit 0
