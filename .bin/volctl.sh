#!/bin/sh

set -e
set -u
# shellcheck disable=SC3040
set -o pipefail

error_and_exit()
{
    cat >&2 << EOF
volctl.sh get-volume
volctl.sh set-volume <VOLUME>
volctl.sh set-mute   (0|1|toggle)
EOF
    exit 1
}

get_volume()
{
    case "$(LC_ALL="C" pactl get-sink-mute @DEFAULT_SINK@)" in
        (*yes*)
            printf '%s%%\n' '-'
            return
    esac

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
    END {printf("%s%%\n", volume)}'
}

set_volume()
{
    pactl set-sink-volume @DEFAULT_SINK@ "${1}"

    vol="$(get_volume)"
    vol="${vol%%"%"}"

    case "${vol}" in
        (-)
            return ;;
    esac

    if test "${vol}" -gt 100 ; then
        pactl set-sink-volume @DEFAULT_SINK@ "100%"
    fi
}

set_mute()
{
    pactl set-sink-mute @DEFAULT_SINK@ "${1}"
}

case "${1}" in
    (get-volume)
        get_volume ;;
    (set-volume)
        set_volume "${2}" ;;
    (set-mute)
        set_mute "${2}" ;;
    (*) error_and_exit
esac
