#! /bin/zsh

_gtk_launch(){
    local data_dirs="${XDG_DATA_HOME:-"${HOME}/.local/share"}:${XDG_DATA_DIRS:-"/usr/local/share:/usr/share"}"
    local -a cmplist

    for i in $(echo ${data_dirs//":"/$'\n'}) ; do
        for j in "${i}/applications/"*.desktop; do
            local appname="$(basename "${j}" .desktop)"
            cmplist+=("${appname}")
        done
    done

    _values -w "desktop applications" ${cmplist}
}

compdef _gtk_launch gtk_launch

launch_app(){
    gtk-launch ${@}
    exit
}
compdef launch_app="gtk_launch"

if test "${LAUNCHER_MODE}" = "enable" ; then
    print -P "%B%Slaunch desktop application%b%s"
    add-zsh-hook precmd (){print -z "launch_app "}
fi
