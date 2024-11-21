#!/bin/bash

volume=$(pamixer --get-volume)
volumeIfMuted=$(pamixer --get-mute)
icon=""

if [ "$volumeIfMuted" = "true" ]; then
		icon="×"
fi

echo "$icon $volume%"
