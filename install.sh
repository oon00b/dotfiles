#! /bin/sh
set -e

install_cmd()
{
    printf "installing from \"${1}\" to \"${2}\"\n"
    cp -R "${1}" "${2}"
}

install_cmd "./.vim"      "${HOME}"
install_cmd "./.zshrc"    "${ZDOTDIR:-"${HOME}"}"
install_cmd "./dein"      "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
install_cmd "./git"       "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
install_cmd "./nvim"      "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
