#!/bin/bash

source=$(pactl list sources | awk '/^Source #/ {name=""} /^Name: / {name=$2} /^State: RUNNING/ && name {print name; exit}')

if [ -z "$source" ]; then
  exit 0
fi

get_mute=$(pactl get-source-mute "$source" | awk '{print $2}')

if [ "$get_muted" = "yes" ]; then
  echo "󰍭"
else
  echo "󰍬"
fi
