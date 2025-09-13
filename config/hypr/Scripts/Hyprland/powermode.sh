user_args="$1"
state_file="/home/spacerat/.config/hypr/Scripts/Logs/powermode_state"
modes="Available modes are:\e[1m\ncycle (cycles through all options, useful for scripts)\ndefault\nperformance\nbalanced\npower-saver\nultra-power-saver\e[0m"


if [[ -f "$state_file" ]]; then
    :
  else
    touch "$state_file"
    echo "Set to default mode" > "$state_file" 
fi


cycle() {
  current_mode=$(cat "$state_file" | cut -d ' ' -f 3)
  
  case "$current_mode" in
    default)
      next_mode="performance"
      ;;
    performance)
      next_mode="balanced"
      ;;
    balanced)
      next_mode="power-saver"
      ;;
    power-saver)
      next_mode="ultra-power-saver"
      ;;
    ultra-power-saver)
      next_mode="default"
      ;;
    *) 
      next_mode="default"
      ;;
  esac

  user_args="$next_mode"
  main
}


main() {
  hyprctl keyword decoration:blur:enabled 1 ; hyprctl keyword decoration:shadow:enabled 1
  hyprctl keyword animations:enabled 1
  hyprctl keyword misc:disable_autoreload false

  case $user_args in
    cycle)
      cycle
      ;;
    default)
      hyprctl keyword monitor eDP-2,1920x1200@165Hz,1920x0,1.0
      hyprctl keyword monitor eDP-1,1920x1200@165Hz,1920x0,1.0
      #powerprofilesctl set balanced
      asusctl -k high
      echo -e "Set to \e[1mdefault\e[0m" ; message="Set to default mode" ; echo "$message" > "$state_file"
      ;;
    performance)
      hyprctl keyword monitor eDP-2,1920x1200@165Hz,1920x0,1.0
      hyprctl keyword monitor eDP-1,1920x1200@165Hz,1920x0,1.0
      #tlp ac
      asusctl -k high
      echo -e "Set to \e[1mpower-saver\e[0m" ; message="Set to performance mode" ; echo "$message" > "$state_file"
      ;;
    balanced)
      hyprctl keyword monitor eDP-2,1920x1200@90Hz,1920x0,1.0
      hyprctl keyword monitor eDP-1,1920x1200@90Hz,1920x0,1.0
      #powerprofilesctl set balanced
      asusctl -k med
      echo -e "Set to \e[1mbalanced\e[0m" ; message="Set to balanced mode" ; echo "$message" > "$state_file"
      ;;
    power-saver)
      hyprctl keyword monitor eDP-2,1920x1200@60Hz,1920x0,1.0
      hyprctl keyword monitor eDP-1,1920x1200@60Hz,1920x0,1.0
      #powerprofilesctl set power-saver
      asusctl -k low
      echo -e "Set to \e[1mpower-saver\e[0m" ; message="Set to power-saver mode" ; echo "$message" > "$state_file" 
      ;;
    ultra-power-saver)
      hyprctl keyword monitor eDP-2,1920x1200@60Hz,1920x0,1.0
      hyprctl keyword monitor eDP-1,1920x1200@60Hz,1920x0,1.0
      #powerprofilesctl set power-saver
      asusctl -k off
      hyprctl keyword decoration:blur:enabled 0 ; hyprctl keyword decoration:shadow:enabled 0
      hyprctl keyword animations:enabled 0
      hyprctl keyword misc:disable_autoreload true
      echo -e "Set to \e[1multra-power-saver\e[0m" ; message="Set to ultra-power-saver mode" ; echo "$message" > "$state_file" 
      ;;
    *)
      echo -e "Invalid option. $modes"
      ;;
  esac 
}


transient_notification() {
  notify-send -t 2500 -h boolean:transient:true \
    -h string:x-canonical-private-synchronous:powermode-wrapper "$message"
}


if [[ -z "$user_args" ]]; then
  echo -e "No arguments passed. $modes"
  exit 1
else
  main 
  transient_notification
fi
