#!/bin/bash

bt_status=$(rfkill list all | awk '/hci0/{f=1} f&&/Soft blocked/{print $3; exit}')

if [[ "$bt_status" == 'no' ]]; then
  rfkill block bluetooth 
  echo 'blocked bluetooth'
else
  rfkill unblock bluetooth
  echo 'unblocked bluetooth'
fi
