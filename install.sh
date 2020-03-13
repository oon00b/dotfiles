#! /bin/sh
set -e

install_dotfiles()
{
    printf "installing from \"${1}\" to \"${2}\"\n"
    cp -R "${1}" "${2}"
}

install_dotfiles "./.vim"      "${HOME}"
install_dotfiles "./.zshrc"    "${ZDOTDIR:-"${HOME}"}"
install_dotfiles "./dein"      "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
install_dotfiles "./git"       "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
install_dotfiles "./nvim"      "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
