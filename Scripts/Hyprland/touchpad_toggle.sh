#/bin/bash

#touchpad_state=$(hyprctl getoption device[asuf1204:00-2808:0202-touchpad]:disable_while_typing | grep -oP '(?<=str: )\w+') # Doesn't work in modern Hyprland
touchpad_state=$(awk '/name *= *asuf1204:00-2808:0202-touchpad/ {f=1} f && /disable_while_typing/ {gsub(/[ \t]/,""); split($0,a,"="); print a[2]; exit}' ~/.config/hypr/hyprland.conf)
state_file="/home/spacerat/.config/hypr/Scripts/Hyprland/touchpad_state_file"

main() {
  current_state=$(cat "$state_file" | cut -d ' ' -f 3)

  if [[ "$current_state" == "true" ]]; then
      hyprctl keyword device[asuf1204:00-2808:0202-touchpad]:disable_while_typing false
          notify-send -i /usr/share/icons/breeze-dark/status/32/touchpad_enabled.svg -t 1000 -h boolean:transient:true \
          -h string:x-canonical-private-synchronous:layout 'DWT disabled'
          echo "false" > "$state_file"
  else
      hyprctl keyword device[asuf1204:00-2808:0202-touchpad]:disable_while_typing true
          notify-send -i /usr/share/icons/breeze-dark/status/32/touchpad_disabled.svg -t 1000 -h boolean:transient:true \
          -h string:x-canonical-private-synchronous:layout 'DWT enabled'
          echo "true" > "$state_file"
  fi

}


if [[ -f "$state_file" ]]; then
    main
  else
    touch "$state_file"
    echo "$touchpad_state" > "$state_file"
    main
fi
