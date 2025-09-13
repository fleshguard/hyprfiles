#!/bin/bash

batteryPerc=$(cat /sys/class/power_supply/BAT0/capacity)
batteryStatus=$(cat /sys/class/power_supply/BAT0/status)

discharging() {
  case $batteryPerc in
      100)
          icon="󰁹"
          ;;
      9[0-9])
          icon="󰂂"
          ;;
      8[0-9])
          icon="󰂁"
          ;;
      6[0-9]|7[0-9])
          icon="󰂀"
          ;;
      4[0-9]|5[0-9])
          icon="󰁾"
          ;;
      [1-3][0-9])
          icon="󰁼"
          ;;
      [0-9])
          icon="󰂃"
          ;;
      *)
          icon="?"
          ;;
  esac
}

if [ "$batteryStatus" = "Charging" ] || [ $batteryStatus = "Full" ] ; then
  icon="󰂄"
else
  discharging
fi

echo "$icon $batteryPerc%"
