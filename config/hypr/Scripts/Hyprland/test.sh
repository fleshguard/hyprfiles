sound_cmd() {
  target_sink=$(pactl get-default-sink)
  current_volume=$(pactl get-sink-volume "$target_sink" | grep -oP '\d+(?=%)' | head -1)
  duck=$((current_volume / 2))

  pactl set-sink-volume "$target_sink" "${duck}%"
  paplay "$1"

  pactl set-sink-volume "$target_sink" "${current_volume}%"

}

sound_cmd /usr/share/sounds/ocean/stereo/service-logout.oga
