#! /bin/sh
set -e

install_dotfiles()
{
    _dotfiles_path="$(dirname "${0}")/${1}"
    printf "installing from \"${_dotfiles_path}\" to \"${2}\"\n"
    test -d "${2}" || mkdir -p "${2}"
    cp -R "${_dotfiles_path}" "${2}"
}

install_dotfiles ".dir_colors" "${HOME}"
install_dotfiles ".vim"        "${HOME}"
install_dotfiles ".zshrc"      "${ZDOTDIR:-${HOME}}"
install_dotfiles "alacritty"   "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
install_dotfiles "dein"        "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
install_dotfiles "git"         "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
install_dotfiles "nvim"        "${XDG_CONFIG_HOME:-"${HOME}/.config"}"
