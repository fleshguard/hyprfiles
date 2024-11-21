#!/bin/bash

batteryPerc=$(cat /sys/class/power_supply/BAT1/capacity)
batteryStatus=$(cat /sys/class/power_supply/BAT1/status)

icon="󰁹"

if [ "$batteryStatus" = "Charging" ]; then
	icon="󰂄"
fi

echo "$icon $batteryPerc%"
