export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
export XDG_CACHE_HOME="${XDG_CONFIG_HOME:-"${HOME}/.cache"}"

export INPUTRC="${INPUTRC:-"${XDG_CONFIG_HOME}"}"

export ZDOTDIR="${ZDOTDIR:-"${XDG_CONFIG_HOME}/zsh"}"

add_path(){
    for i in ${@} ; do
        case ${PATH} in
            ("${i}" | "${i}:"* | *":${i}:"* | *":${i}") : ;;
            (*) export PATH="${i}${PATH:+":${PATH}"}"
        esac
    done
}
add_path "${HOME}/.local/bin"
add_path "${HOME}/.bin"
