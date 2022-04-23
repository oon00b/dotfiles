# /bin/sh

pipe_path="${XDG_RUNTIME_DIR}/$(basename ${0}).pipe"
update_word="update"

if ps -p "${PPID}" -o "comm" | grep -q -s "^swaybar$" ; then
    mkfifo -m 600 "${pipe_path}"
else
    echo "${update_word}" > "${pipe_path}"
    exit
fi

echo "{\"version\":1}"
echo "["

send_status(){
    pulse_status="$(pactl get-default-sink):$(${HOME}/.bin/volctl.sh get-volume)"
    wifi_status="wl:$(cat /sys/class/net/wlp3s0/operstate)"
    date_status="$(date "+%Y-%m-%d(%a) %H:%M")"

    echo "[{\
\"full_text\":\"${pulse_status}\",
\"separator\":true},{\
\"full_text\":\"${wifi_status}\",
\"separator\":true},{\
\"full_text\":\"${date_status}\"}],"
}

while true ; do
    send_status
    sleep 60
done &

while read a < "${pipe_path}" ; do
    test "${a}" = "${update_word}" && send_status
done
