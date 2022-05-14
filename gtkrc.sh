make_gtkrc() {
  local dest="${1}"
  local name="${2}"
  local theme="${3}"
  local color="${4}"
  local size="${5}"
  local ctype="${6}"
  local window="${7}"

  [[ "${color}" == '-Light' ]] && local ELSE_LIGHT="${color}"
  [[ "${color}" == '-Dark' ]] && local ELSE_DARK="${color}"

  local GTKRC_DIR="${SRC_DIR}/main/gtk-2.0"
  local THEME_DIR="${1}/${2}${3}${4}${5}${6}"

  if [[ "${color}" != '-Dark' ]]; then
    case "$theme" in
      '')
        theme_color='#3c84f7'
        ;;
      -Purple)
        theme_color='#AB47BC'
        ;;
      -Pink)
        theme_color='#EC407A'
        ;;
      -Red)
        theme_color='#E53935'
        ;;
      -Orange)
        theme_color='#F57C00'
        ;;
      -Yellow)
        theme_color='#FBC02D'
        ;;
      -Green)
        theme_color='#4CAF50'
        ;;
      -Teal)
        theme_color='#009688'
        ;;
      -Grey)
        theme_color='#464646'
        ;;
    esac

    if [[ "$ctype" == '-Nord' ]]; then
      case "$theme" in
        '')
          theme_color='#5e81ac'
          ;;
        -Purple)
          theme_color='#b57daa'
          ;;
        -Pink)
          theme_color='#cd7092'
          ;;
        -Red)
          theme_color='#c35b65'
          ;;
        -Orange)
          theme_color='#d0846c'
          ;;
        -Yellow)
          theme_color='#e4b558'
          ;;
        -Green)
          theme_color='#82ac5d'
          ;;
        -Teal)
          theme_color='#83b9b8'
          ;;
        -Grey)
          theme_color='#3a4150'
          ;;
      esac
    fi

    if [[ "$ctype" == '-Dracula' ]]; then
      case "$theme" in
        '')
          theme_color='#a679ec'
          ;;
        -Purple)
          theme_color='#a679ec'
          ;;
        -Pink)
          theme_color='#f04cab'
          ;;
        -Red)
          theme_color='#f44d4d'
          ;;
        -Orange)
          theme_color='#f8a854'
          ;;
        -Yellow)
          theme_color='#e8f467'
          ;;
        -Green)
          theme_color='#4be772'
          ;;
        -Teal)
          theme_color='#20eed9'
          ;;
        -Grey)
          theme_color='#3c3f51'
          ;;
      esac
    fi
  else
    case "$theme" in
      '')
        theme_color='#5b9bf8'
        ;;
      -Purple)
        theme_color='#BA68C8'
        ;;
      -Pink)
        theme_color='#F06292'
        ;;
      -Red)
        theme_color='#F44336'
        ;;
      -Orange)
        theme_color='#FB8C00'
        ;;
      -Yellow)
        theme_color='#FFD600'
        ;;
      -Green)
        theme_color='#66BB6A'
        ;;
      -Teal)
        theme_color='#4DB6AC'
        ;;
      -Grey)
        theme_color='#DDDDDD'
        ;;
    esac

    if [[ "$ctype" == '-Nord' ]]; then
      case "$theme" in
        '')
          theme_color='#89a3c2'
          ;;
        -Purple)
          theme_color='#c89dbf'
          ;;
        -Pink)
          theme_color='#dc98b1'
          ;;
        -Red)
          theme_color='#d4878f'
          ;;
        -Orange)
          theme_color='#dca493'
          ;;
        -Yellow)
          theme_color='#eac985'
          ;;
        -Green)
          theme_color='#a0c082'
          ;;
        -Teal)
          theme_color='#83b9b8'
          ;;
        -Grey)
          theme_color='#d9dce3'
          ;;
      esac
    fi

    if [[ "$ctype" == '-Dracula' ]]; then
      case "$theme" in
        '')
          theme_color='#bd93f9'
          ;;
        -Purple)
          theme_color='#bd93f9'
          ;;
        -Pink)
          theme_color='#ff79c6'
          ;;
        -Red)
          theme_color='#ff5555'
          ;;
        -Orange)
          theme_color='#ffb86c'
          ;;
        -Yellow)
          theme_color='#f1fa8c'
          ;;
        -Green)
          theme_color='#50fa7b'
          ;;
        -Teal)
          theme_color='#50fae9'
          ;;
        -Grey)
          theme_color='#d9dae3'
          ;;
      esac
    fi
  fi

  if [[ "$blackness" == 'true' ]]; then
    case "$ctype" in
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
    esac
  else
    case "$ctype" in
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
    esac
  fi

  cp -r "${GTKRC_DIR}/gtkrc${ELSE_DARK:-}-default"                              "${THEME_DIR}/gtk-2.0/gtkrc"
  sed -i "s/#FFFFFF/${background_light}/g"                                      "${THEME_DIR}/gtk-2.0/gtkrc"
  sed -i "s/#2C2C2C/${background_dark}/g"                                       "${THEME_DIR}/gtk-2.0/gtkrc"
  sed -i "s/#464646/${background_alt}/g"                                        "${THEME_DIR}/gtk-2.0/gtkrc"

  if [[ "${color}" == '-Dark' ]]; then
    sed -i "s/#5b9bf8/${theme_color}/g"                                         "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "s/#3C3C3C/${background_darker}/g"                                   "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "s/#242424/${titlebar_dark}/g"                                       "${THEME_DIR}/gtk-2.0/gtkrc"
  else
    sed -i "s/#3c84f7/${theme_color}/g"                                         "${THEME_DIR}/gtk-2.0/gtkrc"
    sed -i "s/#F2F2F2/${titlebar_light}/g"                                      "${THEME_DIR}/gtk-2.0/gtkrc"
  fi
}
