_gtk_launch(){
    local data_dirs="${XDG_DATA_HOME:-"${HOME}/.local/share"}:${XDG_DATA_DIRS:-"/usr/local/share:/usr/share"}"
    local -a cmplist

    for dir in $(echo ${data_dirs//":"/$'\n'}) ; do
        for app in "${dir}"/applications/*.desktop(N); do
            local appname="$(basename "${app}" .desktop)"
            cmplist+=("${appname}")
        done
    done

    _values -w "desktop applications" ${cmplist}
}

compdef _gtk_launch gtk-launch

launch_app(){
    gtk-launch ${@}
    exit
}
compdef launch_app="gtk-launch"

if test "${LAUNCHER_MODE}" = "enable" ; then
    unset LAUNCHER_MODE
    print -P "%B%Slaunch desktop application%b%s"
    add-zsh-hook precmd (){print -z "launch_app "}
fi
