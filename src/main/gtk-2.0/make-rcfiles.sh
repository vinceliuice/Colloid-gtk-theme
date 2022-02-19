#! /usr/bin/env bash

for theme in '' '-purple' '-pink' '-red' '-orange' '-yellow' '-green' '-teal' '-grey'; do
for color in '' '-dark'; do
for type in '' '-nord' '-dracula'; do
  if [[ "$color" == '' ]]; then
    case "$theme" in
      '')
        theme_color='#3c84f7'
        ;;
      -purple)
        theme_color='#AB47BC'
        ;;
      -pink)
        theme_color='#EC407A'
        ;;
      -red)
        theme_color='#E53935'
        ;;
      -orange)
        theme_color='#F57C00'
        ;;
      -yellow)
        theme_color='#FBC02D'
        ;;
      -green)
        theme_color='#4CAF50'
        ;;
      -teal)
        theme_color='#009688'
        ;;
      -grey)
        theme_color='#464646'
        ;;
    esac

    if [[ "$type" == '-nord' ]]; then
      case "$theme" in
        '')
          theme_color='#5e81ac'
          ;;
        -purple)
          theme_color='#b57daa'
          ;;
        -pink)
          theme_color='#cd7092'
          ;;
        -red)
          theme_color='#c35b65'
          ;;
        -orange)
          theme_color='#d0846c'
          ;;
        -yellow)
          theme_color='#e4b558'
          ;;
        -green)
          theme_color='#82ac5d'
          ;;
        -teal)
          theme_color='#83b9b8'
          ;;
        -grey)
          theme_color='#3a4150'
          ;;
      esac
    fi

    if [[ "$type" == '-dracula' ]]; then
      case "$theme" in
        '')
          theme_color='#a679ec'
          ;;
        -purple)
          theme_color='#a679ec'
          ;;
        -pink)
          theme_color='#f04cab'
          ;;
        -red)
          theme_color='#f44d4d'
          ;;
        -orange)
          theme_color='#f8a854'
          ;;
        -yellow)
          theme_color='#e8f467'
          ;;
        -green)
          theme_color='#4be772'
          ;;
        -teal)
          theme_color='#20eed9'
          ;;
        -grey)
          theme_color='#3c3f51'
          ;;
      esac
    fi
  else
    case "$theme" in
      '')
        theme_color='#5b9bf8'
        ;;
      -purple)
        theme_color='#BA68C8'
        ;;
      -pink)
        theme_color='#F06292'
        ;;
      -red)
        theme_color='#F44336'
        ;;
      -orange)
        theme_color='#FB8C00'
        ;;
      -yellow)
        theme_color='#FFD600'
        ;;
      -green)
        theme_color='#66BB6A'
        ;;
      -teal)
        theme_color='#4DB6AC'
        ;;
      -grey)
        theme_color='#DDDDDD'
        ;;
    esac

    if [[ "$type" == '-nord' ]]; then
      case "$theme" in
        '')
          theme_color='#89a3c2'
          ;;
        -purple)
          theme_color='#c89dbf'
          ;;
        -pink)
          theme_color='#dc98b1'
          ;;
        -red)
          theme_color='#d4878f'
          ;;
        -orange)
          theme_color='#dca493'
          ;;
        -yellow)
          theme_color='#eac985'
          ;;
        -green)
          theme_color='#a0c082'
          ;;
        -teal)
          theme_color='#83b9b8'
          ;;
        -grey)
          theme_color='#d9dce3'
          ;;
      esac
    fi

    if [[ "$type" == '-dracula' ]]; then
      background_color='#242632'

      case "$theme" in
        '')
          theme_color='#bd93f9'
          ;;
        -purple)
          theme_color='#bd93f9'
          ;;
        -pink)
          theme_color='#ff79c6'
          ;;
        -red)
          theme_color='#ff5555'
          ;;
        -orange)
          theme_color='#ffb86c'
          ;;
        -yellow)
          theme_color='#f1fa8c'
          ;;
        -green)
          theme_color='#50fa7b'
          ;;
        -teal)
          theme_color='#50fae9'
          ;;
        -grey)
          theme_color='#d9dae3'
          ;;
      esac
    fi
  fi

    case "$type" in
      -nord)
        background_light='#f8fafc'
        background_dark='#242932'
        background_darker='#333a47'
        background_alt='#3a4150'
        titlebar_light='#f0f1f4'
        titlebar_dark='#1e222a'
        ;;
      -dracula)
        background_light='#f9f9fb'
        background_dark='#242632'
        background_darker='#343746'
        background_alt='#3c3f51'
        titlebar_light='#f0f1f4'
        titlebar_dark='#1f2029'
        ;;
    esac

  if [[ "$type" != '' ]]; then
    cp -r "gtkrc${color}" "gtkrc${theme}${color}${type}"
    sed -i "s/#FFFFFF/${background_light}/g" "gtkrc${theme}${color}${type}"
    sed -i "s/#2C2C2C/${background_dark}/g" "gtkrc${theme}${color}${type}"
    sed -i "s/#464646/${background_alt}/g" "gtkrc${theme}${color}${type}"
    if [[ "$color" == '' ]]; then
      sed -i "s/#3c84f7/${theme_color}/g" "gtkrc${theme}${color}${type}"
      sed -i "s/#F2F2F2/${titlebar_light}/g" "gtkrc${theme}${color}${type}"
    else
      sed -i "s/#5b9bf8/${theme_color}/g" "gtkrc${theme}${color}${type}"
      sed -i "s/#3C3C3C/${background_darker}/g" "gtkrc${theme}${color}${type}"
      sed -i "s/#242424/${titlebar_dark}/g" "gtkrc${theme}${color}${type}"
    fi
  elif [[ "$theme" != '' ]]; then
    cp -r "gtkrc${color}" "gtkrc${theme}${color}"
    if [[ "$color" == '' ]]; then
      sed -i "s/#3c84f7/${theme_color}/g" "gtkrc${theme}${color}"
    else
      sed -i "s/#5b9bf8/${theme_color}/g" "gtkrc${theme}${color}"
    fi
  fi

done
done
done

echo -e "DONE!"
