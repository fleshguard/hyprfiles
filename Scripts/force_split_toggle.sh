#/bin/bash

current_int=$(hyprctl getoption dwindle:force_split | awk '/int:/ {print $2}')

if [[ "$current_int" == 0 ]]; then
  hyprctl 'keyword dwindle:force_split 1'
  echo '1'
elif [[ "$current_int" == 1 ]]; then
  hyprctl 'keyword dwindle:force_split 2'
  echo '2'
else
  hyprctl 'keyword dwindle:force_split 0'
  echo '0'
fi
