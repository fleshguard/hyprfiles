#!/bin/bash

wlan_status=$(rfkill list all | awk '/phy0/{f=1} f&&/Soft blocked/{print $3; exit}')

if [[ "$wlan_status" == 'no' ]]; then
  rfkill block wlan 
  echo 'blocked wlan'
else
  rfkill unblock wlan
  echo 'unblocked wlan'
fi
