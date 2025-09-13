#!/bin/bash

bt_status=$(rfkill list all | awk '/hci0/{f=1} f&&/Soft blocked/{print $3; exit}')

if [[ "$bt_status" == 'no' ]]; then
  rfkill block bluetooth 
  notify-send -i '/usr/share/icons/breeze-dark/status/22@3x/network-bluetooth-symbolic.svg' 'Blocked bluetooth'
else
  rfkill unblock bluetooth
  notify-send -i '/usr/share/icons/breeze-dark/status/22@3x/network-bluetooth-inactive-symbolic.svg' 'Unblocked bluetooth'
fi
