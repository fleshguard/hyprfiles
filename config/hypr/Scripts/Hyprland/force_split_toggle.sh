#/bin/bash

current_int=$(hyprctl getoption dwindle:force_split | awk '/int:/ {print $2}')

if [[ "$current_int" == 0 ]]; then
  hyprctl 'keyword dwindle:force_split 1'
  notify-send -t 750 -h boolean:transient:true \
    -h string:x-canonical-private-synchronous:splitint 'Dwindle: Left'
elif [[ "$current_int" == 1 ]]; then
  hyprctl 'keyword dwindle:force_split 2'
  notify-send -t 750 -h boolean:transient:true \
    -h string:x-canonical-private-synchronous:splitint 'Dwindle: Right'
else
  hyprctl 'keyword dwindle:force_split 0'
  notify-send -t 750 -h boolean:transient:true \
    -h string:x-canonical-private-synchronous:splitint 'Dwindle: Follows mouse'

fi
