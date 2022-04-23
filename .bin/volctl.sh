#! /bin/sh
#
# Required: pactl

error_and_exit()
{
    cat >&2 << "EOF"
volctl.sh get-volume
volctl.sh set-volume <VOLUME>
volctl.sh set-mute   (0|1|toggle)
EOF
    exit 1
}

get_volume()
{
    # ロケールによって出力のフォーマットが変わるみたいなので、ロケールを明示する
    if LC_ALL="POSIX" pactl get-sink-mute @DEFAULT_SINK@ | grep -i -s -q "yes" ; then
        echo "-%"
        return
    fi

    pactl get-sink-volume @DEFAULT_SINK@ \
    | awk '
    BEGIN {volume = 0}
    {
        for(i = 1; i <= NF; ++i) {
            if($i ~ /^[0-9]{1,}%$/) {
                v = substr($i, 1, length($i) - 1)
                if(v > volume) volume = v
            }
        }
    }
    END {print volume"%"}'
}

set_volume()
{
    pactl set-sink-volume @DEFAULT_SINK@ ${@}
}

set_mute()
{
    pactl set-sink-mute @DEFAULT_SINK@ ${@}
}

case ${1} in
    get-volume) get_volume;;
    set-volume) set_volume ${@#set-volume};;
    set-mute) set_mute ${@#set-mute};;
    *) error_and_exit;;
esac
