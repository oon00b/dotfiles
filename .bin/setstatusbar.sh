#!/bin/sh

pipe_path="${XDG_RUNTIME_DIR}/$(basename "${0}").pipe"
update_word="update"

if ps -p "${PPID}" -o "comm" | grep -q -s "^swaybar$" ; then
    mkfifo -m 600 "${pipe_path}"
else
    echo "${update_word}" > "${pipe_path}"
    exit
fi

status_commands=""
add_status_commands(){
    for comm in ${@} ; do
        status_commands="${status_commands} ${comm}"
    done
    status_commands=${status_commands##" "}
}

audio_status(){
    pulse_sink="$(pactl get-default-sink)"
    pulse_volume="$(volctl.sh get-volume)"
    echo "${pulse_sink}:${pulse_volume}"
}
add_status_commands "audio_status"

battery_path="/sys/class/power_supply/BAT0"
battery_status(){
    capacity="$(cat "${battery_path}/capacity")"
    is_charging="$(grep -i -s -q "^Charging$" "${battery_path}/status" && echo "+" || echo "-")"
    echo "BAT:${capacity}%[${is_charging}]"
    test "${capacity}" -lt "10" && test "${is_charging}" != "+" && swaynag -t warning -m "バッテリー 残り ${capacity}% 充電しろ"
}
test -d "${battery_path}" && add_status_commands "battery_status"

wifi_interface_path="/sys/class/net/wlan0"
wifi_status(){
    operational_state="$(cat "${wifi_interface_path}/operstate")"
    echo "wl:${operational_state}"
}
test -d ${wifi_interface_path} && add_status_commands "wifi_status"

date_status(){
    date "+%F(%a) %H:%M"
}
add_status_commands "date_status"

echo '{"version":1}'
echo '['

send_status(){
    body="[{}"
    for comm in ${status_commands} ; do
        body="${body},$(printf '{"full_text":"%s", "separator":true}' "$(eval "${comm}")")"
    done
    printf "%s" "${body}],"
}

while true ; do
    send_status
    sleep 60
done &

while read -r a < "${pipe_path}" ; do
    test "${a}" = "${update_word}" && send_status
done
