#!/bin/sh

set -e
set -u

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
ZDOTDIR="${ZDOTDIR:-"${XDG_CONFIG_HOME}/zsh"}"
INPUTRC="${INPUTRC:-"${XDG_CONFIG_HOME}/.inputrc"}"

install_dotfiles()
{
    _dotfiles_path="$(dirname "${0}")/${1}"
    printf "installing from %s to %s\n" "${_dotfiles_path}" "${2}"
    test -d "${2}" || mkdir -p "${2}"
    cp -R "${_dotfiles_path}" "${2}"
}

install_dotfiles ".bin"           "${HOME}"
install_dotfiles ".vim"           "${HOME}"
install_dotfiles ".zshenv"        "${HOME}"
install_dotfiles "zsh"            "${ZDOTDIR%"/zsh"}"
install_dotfiles ".dir_colors"    "${XDG_CONFIG_HOME}"
install_dotfiles "alacritty"      "${XDG_CONFIG_HOME}"
install_dotfiles "containers"     "${XDG_CONFIG_HOME}"
install_dotfiles "dein"           "${XDG_CONFIG_HOME}"
install_dotfiles "foot"           "${XDG_CONFIG_HOME}"
install_dotfiles "git"            "${XDG_CONFIG_HOME}"
install_dotfiles "gtk-3.0"        "${XDG_CONFIG_HOME}"
install_dotfiles "nvim"           "${XDG_CONFIG_HOME}"
install_dotfiles "sway"           "${XDG_CONFIG_HOME}"
install_dotfiles "user-dirs.dirs" "${XDG_CONFIG_HOME}"
install_dotfiles ".inputrc"       "${INPUTRC%"/.inputrc"}"
