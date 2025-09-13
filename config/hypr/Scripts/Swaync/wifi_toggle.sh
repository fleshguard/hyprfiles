#!/bin/bash

#wlan_signal=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d':' -f2)
wlan_status=$(rfkill list all | awk '/phy0/{f=1} f&&/Soft blocked/{print $3; exit}')

if [[ "$wlan_status" == 'no' ]]; then
  rfkill block wlan 
  notify-send -i '/usr/share/icons/breeze-dark/status/24@3x/nm-signal-00-symbolic.svg' 'Blocked wlan'
else
  rfkill unblock wlan
  notify-send -i '/usr/share/icons/breeze-dark/status/24@3x/nm-signal-100-symbolic.svg' 'Unblocked wlan'
fi
