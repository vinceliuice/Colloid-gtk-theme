#! /usr/bin/env bash

for color in '' '-Light'; do
  for type in '' '-Nord' '-Dracula' '-Gruvbox' '-Everforest' '-Catppuccin'; do
    if [[ "$type" == '-Nord' ]]; then
      headerbar_light='#f0f1f4'
      headerbar_dark='#1e222a'
      headerbar_backdrop_light='#f8fafc'
      headerbar_backdrop_dark='#242932'
      close_color='#bf616a'
      max_color='#a3be8c'
      min_color='#ebcb8b'
    fi

    if [[ "$type" == '-Dracula' ]]; then
      headerbar_light='#f0f1f4'
      headerbar_dark='#1f2029'
      headerbar_backdrop_light='#f9f9fb'
      headerbar_backdrop_dark='#242632'
      close_color='#ed5d5d'
      max_color='#43db68'
      min_color='#e3d93b'
    fi

    if [[ "$type" == '-Gruvbox' ]]; then
      headerbar_light='#fbf1c7'
      headerbar_dark='#242220'
      headerbar_backdrop_light='#f9f5d7'
      headerbar_backdrop_dark='#282524'
      close_color='#cc241d'
      max_color='#98971a'
      min_color='#d79921'
    fi

    if [[ "$type" == '-Everforest' ]]; then
      headerbar_light='#f4f0d9'
      headerbar_dark='#272e33'
      headerbar_backdrop_light='#fdf6e3'
      headerbar_backdrop_dark='#2d353b'
      close_color='#E67E80'
      max_color='#A7C080'
      min_color='#DBBC7F'
    fi

    if [[ "$type" == '-Catppuccin' ]]; then
      headerbar_light='#e6e9ef'
      headerbar_dark='#24273a'
      headerbar_backdrop_light='#eff1f5'
      headerbar_backdrop_dark='#292c3c'
      close_color='#ea999c'
      max_color='#a6d189'
      min_color='#e5c890'
    fi

    for window in '' '-Normal'; do
      if [[ "$type" != '' ]]; then
        cp -rf "assets${color}${window}.svg" "assets${color}${type}${window}.svg"

        if [[ "$window" == '' ]]; then
          sed -i "s/#fd5f51/${close_color}/g" "assets${color}${type}${window}.svg"
          sed -i "s/#38c76a/${max_color}/g" "assets${color}${type}${window}.svg"
          sed -i "s/#fdbe04/${min_color}/g" "assets${color}${type}${window}.svg"
        fi

        if [[ "$color" == '-Light' ]]; then
          sed -i "s/#f2f2f2/${headerbar_light}/g" "assets${color}${type}${window}.svg"
          sed -i "s/#fafafa/${headerbar_backdrop_light}/g" "assets${color}${type}${window}.svg"
        else
          sed -i "s/#242424/${headerbar_dark}/g" "assets${color}${type}${window}.svg"
          sed -i "s/#2c2c2c/${headerbar_backdrop_dark}/g" "assets${color}${type}${window}.svg"
        fi
      fi
    done
  done
done

echo -e "DONE!"
