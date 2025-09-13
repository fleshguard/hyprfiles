#!/bin/bash

status=$(pidof kdeconnectd)

if [[ "$status" == "" ]]; then
  pkill -x kdeconnectd || kdeconnectd
  notify-send -i '/usr/share/icons/breeze-dark/status/24@3x/kdeconnect-tray-symbolic.svg' 'Launched kdeconnectd'
else
  pkill -x hypridle
  notify-send -i '/usr/share/icons/breeze-dark/status/24@3x/kdeconnect-tray-symbolic.svg' 'Killed kdeconnectd'
fi
