#!/bin/bash

volume=$(pamixer --get-volume)
volumeIfMuted=$(pamixer --get-mute)

if [ "$volumeIfMuted" = "true" ]; then
	icon="×"
else
	icon=""
fi

echo "$icon $volume%"
