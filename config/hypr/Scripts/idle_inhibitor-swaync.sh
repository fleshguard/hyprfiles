#!/bin/bash

hypridle_status=$(pidof hypridle)

if [[ "$hypridle_status" == "" ]]; then
  pkill -x hypridle || hyprctl dispatch exec hypridle
  echo 'dispatched hypridle'
else
  pkill -x hypridle
  echo 'killed hypridle'
fi
