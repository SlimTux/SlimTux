#!/bin/sh
#
# power_button.sh - Trigger poweroff sequence by sending USR1 to this script,
#                   abort poweroff sequence by sending USR2 to thes script.
#
# USAGE: power_button.sh [countdown]
#
# TAGS:
#  Name        Type     Return
#  ---------------------------------------------
#  {status}    string   status of power button
#  {pid}       int      pid of this script
#  {countdown} int      time until poweroff is executed
#
# Exemples configuration:
# - script:
#     path: /home/jrd/.config/yambar/power_button.sh
#     args: [10]
#     content:
#       map:
#         conditions:
#           status == on:
#             string:
#               text: ''
#               on-click: kill -USR1 {pid}
#           status == off:
#             string:
#               text: "{countdown}"
#               on-click: kill -USR2 {pid}

countdown="$1"
[ "$countdown" = "" ] && countdown="5"

pid=$$

status_on() {
    echo "status|string|on"
    echo "pid|int|${pid}"
    echo "countdown|int|${i}"
    echo ""
    sleep infinity &
    infinity_sleep="$!"
    wait "$infinity_sleep"
}

status_off() {
    kill "$infinity_sleep"
    i="$countdown"
    while [ "$i" -ge 0 ]; do
        echo "status|string|off"
        echo "pid|int|${pid}"
        echo "countdown|int|${i}"
        echo ""
        i=$((i - 1))
        sleep 1 &
        wait $!
    done
    sudo poweroff
}

trap 'status_off' USR1
trap 'status_on' USR2

# initial status:
status_on

