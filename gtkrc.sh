make_gtkrc() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local color="${4}"
  local size="${5}"
  local scheme="${6}"
  local window="${7}"

  [[ "${color}" == '-Light' ]] && local ELSE_LIGHT="${color}"
  [[ "${color}" == '-Dark' ]] && local ELSE_DARK="${color}"

  local GTKRC_DIR="${SRC_DIR}/main/gtk-2.0"
  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  case "$theme" in
    '')
      theme_color_dark='#3c84f7'
      theme_color_light='#5b9bf8'
      ;;
    -Purple)
      theme_color_dark='#AB47BC'
      theme_color_light='#BA68C8'
      ;;
    -Pink)
      theme_color_dark='#EC407A'
      theme_color_light='#F06292'
      ;;
    -Red)
      theme_color_dark='#E53935'
      theme_color_light='#F44336'
      ;;
    -Orange)
      theme_color_dark='#F57C00'
      theme_color_light='#FB8C00'
      ;;
    -Yellow)
      theme_color_dark='#FBC02D'
      theme_color_light='#FFD600'
      ;;
    -Green)
      theme_color_dark='#4CAF50'
      theme_color_light='#66BB6A'
      ;;
    -Teal)
      theme_color_dark='#009688'
      theme_color_light='#4DB6AC'
      ;;
    -Grey)
      theme_color_dark='#464646'
      theme_color_light='#DDDDDD'
      ;;
  esac

  if [[ "$scheme" == '-Nord' ]]; then
    case "$theme" in
      '')
        theme_color_dark='#5e81ac'
        theme_color_light='#89a3c2'
        ;;
      -Purple)
        theme_color_dark='#b57daa'
        theme_color_light='#c89dbf'
        ;;
      -Pink)
        theme_color_dark='#cd7092'
        theme_color_light='#dc98b1'
        ;;
      -Red)
        theme_color_dark='#c35b65'
        theme_color_light='#d4878f'
        ;;
      -Orange)
        theme_color_dark='#d0846c'
        theme_color_light='#dca493'
        ;;
      -Yellow)
        theme_color_dark='#e4b558'
        theme_color_light='#eac985'
        ;;
      -Green)
        theme_color_dark='#82ac5d'
        theme_color_light='#a0c082'
        ;;
      -Teal)
        theme_color_dark='#63a6a5'
        theme_color_light='#83b9b8'
        ;;
      -Grey)
        theme_color_dark='#3a4150'
        theme_color_light='#d9dce3'
        ;;
    esac
  fi

  if [[ "$scheme" == '-Dracula' ]]; then
    case "$theme" in
      '')
        theme_color_dark='#a679ec'
        theme_color_light='#bd93f9'
        ;;
      -Purple)
        theme_color_dark='#a679ec'
        theme_color_light='#bd93f9'
        ;;
      -Pink)
        theme_color_dark='#f04cab'
        theme_color_light='#ff79c6'
        ;;
      -Red)
        theme_color_dark='#f44d4d'
        theme_color_light='#ff5555'
        ;;
      -Orange)
        theme_color_dark='#f8a854'
        theme_color_light='#ffb86c'
        ;;
      -Yellow)
        theme_color_dark='#e8f467'
        theme_color_light='#f1fa8c'
        ;;
      -Green)
        theme_color_dark='#4be772'
        theme_color_light='#50fa7b'
        ;;
      -Teal)
        theme_color_dark='#20eed9'
        theme_color_light='#50fae9'
        ;;
      -Grey)
        theme_color_dark='#3c3f51'
        theme_color_light='#d9dae3'
        ;;
    esac
  fi

  if [[ "$scheme" == '-Gruvbox' ]]; then
    case "$theme" in
      '')
        theme_color_dark='#458588'
        theme_color_light='#83a598'
        ;;
      -Purple)
        theme_color_dark='#ab62b1'
        theme_color_light='#d386cd'
        ;;
      -Pink)
        theme_color_dark='#b16286'
        theme_color_light='#d3869b'
        ;;
      -Red)
        theme_color_dark='#cc241d'
        theme_color_light='#fb4934'
        ;;
      -Orange)
        theme_color_dark='#d65d0e'
        theme_color_light='#fe8019'
        ;;
      -Yellow)
        theme_color_dark='#d79921'
        theme_color_light='#fabd2f'
        ;;
      -Green)
        theme_color_dark='#98971a'
        theme_color_light='#b8bb26'
        ;;
      -Teal)
        theme_color_dark='#689d6a'
        theme_color_light='#8ec07c'
        ;;
      -Grey)
        theme_color_dark='#3c3836'
        theme_color_light='#a89984'
        ;;
    esac
  fi

  if [[ "$scheme" == '-Everforest' ]]; then
    case "$theme" in
      '')
        theme_color_dark='#3a94c5'
        theme_color_light='#7fbbb3'
        ;;
      -Purple)
        theme_color_dark='#df69ba'
        theme_color_light='#D699B6'
        ;;
      -Pink)
        theme_color_dark='#b16286'
        theme_color_light='#d3869b'
        ;;
      -Red)
        theme_color_dark='#f85552'
        theme_color_light='#E67E80'
        ;;
      -Orange)
        theme_color_dark='#f57d26'
        theme_color_light='#E69875'
        ;;
      -Yellow)
        theme_color_dark='#dfa000'
        theme_color_light='#DBBC7F'
        ;;
      -Green)
        theme_color_dark='#8da101'
        theme_color_light='#A7C080'
        ;;
      -Teal)
        theme_color_dark='#35a77c'
        theme_color_light='#83C092'
        ;;
      -Grey)
        theme_color_dark='#414b50'
        theme_color_light='#e6e2cc'
        ;;
    esac
  fi

  if [[ "$scheme" == '-Catppuccin' ]]; then
    case "$theme" in
      '')
        theme_color_dark='#1e66f5'
        theme_color_light='#8caaee'
        ;;
      -Purple)
        theme_color_dark='#8839ef'
        theme_color_light='#ca9ee6'
        ;;
      -Pink)
        theme_color_dark='#ea76cb'
        theme_color_light='#f4b8e4'
        ;;
      -Red)
        theme_color_dark='#e64553'
        theme_color_light='#ea999c'
        ;;
      -Orange)
        theme_color_dark='#fe640b'
        theme_color_light='#fe8019'
        ;;
      -Yellow)
        theme_color_dark='#df8e1d'
        theme_color_light='#ef9f76'
        ;;
      -Green)
        theme_color_dark='#40a02b'
        theme_color_light='#a6d189'
        ;;
      -Teal)
        theme_color_dark='#179299'
        theme_color_light='#81c8be'
        ;;
      -Grey)
        theme_color_dark='#5c5f77'
        theme_color_light='#ccd0da'
        ;;
    esac
  fi

  if [[ "$blackness" == 'true' ]]; then
    case "$scheme" in
      '')
        background_light='#FFFFFF'
        background_dark='#0F0F0F'
        background_darker='#121212'
        background_alt='#212121'
        titlebar_light='#F2F2F2'
        titlebar_dark='#030303'
        ;;
      -Nord)
        background_light='#f8fafc'
        background_dark='#0d0e11'
        background_darker='#0f1115'
        background_alt='#1c1f26'
        titlebar_light='#f0f1f4'
        titlebar_dark='#020203'
        ;;
      -Dracula)
        background_light='#f9f9fb'
        background_dark='#0d0d11'
        background_darker='#0f1015'
        background_alt='#1c1e26'
        titlebar_light='#f0f1f4'
        titlebar_dark='#020203'
        ;;
      -Gruvbox)
        background_light='#f9f5d7'
        background_dark='#0f0e0e'
        background_darker='#121110'
        background_alt='#211f1e'
        titlebar_light='#fbf1c7'
        titlebar_dark='#0d0907'
        ;;
      -Everforest)
        background_light='#fffbef'
        background_dark='#1e2326'
        background_darker='#232a2e'
        background_alt='#293136'
        titlebar_light='#f2efdf'
        titlebar_dark='#020203'
        ;;
      -Catppuccin)
        background_light='#eff1f5'
        background_dark='#181825'
        background_darker='#1e1e2e'
        background_alt='#232634'
        titlebar_light='#e6e9ef'
        titlebar_dark='#11111b'
        ;;
    esac
  else
    case "$scheme" in
      '')
        background_light='#FFFFFF'
        background_dark='#2C2C2C'
        background_darker='#3C3C3C'
        background_alt='#464646'
        titlebar_light='#F2F2F2'
        titlebar_dark='#242424'
        ;;
      -Nord)
        background_light='#f8fafc'
        background_dark='#242932'
        background_darker='#333a47'
        background_alt='#3a4150'
        titlebar_light='#f0f1f4'
        titlebar_dark='#1e222a'
        ;;
      -Dracula)
        background_light='#f9f9fb'
        background_dark='#242632'
        background_darker='#343746'
        background_alt='#3c3f51'
        titlebar_light='#f0f1f4'
        titlebar_dark='#1f2029'
        ;;
      -Gruvbox)
        background_light='#f9f5d7'
        background_dark='#282524'
        background_darker='#3c3836'
        background_alt='#504945'
        titlebar_light='#fbf1c7'
        titlebar_dark='#242220'
        ;;
      -Everforest)
        background_light='#fdf6e3'
        background_dark='#2d353b'
        background_darker='#343f44'
        background_alt='#414b50'
        titlebar_light='#f4f0d9'
        titlebar_dark='#272e33'
        ;;
      -Catppuccin)
        background_light='#eff1f5'
        background_dark='#292c3c'
        background_darker='#303446'
        background_alt='#4c4f69'
        titlebar_light='#e6e9ef'
        titlebar_dark='#24273a'
        ;;
    esac
  fi

  cp -r "${GTKRC_DIR}/gtkrc${ELSE_DARK:-}-default"                              "${THEME_DIR}/gtk-2.0/gtkrc"
  sed -i "s/#FFFFFF/${background_light}/g"                                      "${THEME_DIR}/gtk-2.0/gtkrc"
  sed -i "s/#2C2C2C/${background_dark}/g"                                       "${THEME_DIR}/gtk-2.0/gtkrc"
  sed -i "s/#464646/${background_alt}/g"                                        "${THEME_DIR}/gtk-2.0/gtkrc"

  if [[ "${color}" == '-Dark' ]]; then
    sed -i "s/#5b9bf8/${theme_color_light}/g"                                   "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "s/#3C3C3C/${background_darker}/g"                                   "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "s/#242424/${titlebar_dark}/g"                                       "${THEME_DIR}/gtk-2.0/gtkrc"
  else
    sed -i "s/#3c84f7/${theme_color_dark}/g"                                    "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "s/#F2F2F2/${titlebar_light}/g"                                      "${THEME_DIR}/gtk-2.0/gtkrc"
  fi
}
