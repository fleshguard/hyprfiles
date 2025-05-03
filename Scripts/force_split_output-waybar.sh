#!/bin/bash 

force_split_out=$(hyprctl getoption dwindle:force_split | awk '/int:/ {print $2}')
current_layout=$(hyprctl getoption general:layout | awk -F': ' '/str/ {print $2}')


function windows_in_active_workspace {
    active_workspace=$(hyprctl activewindow | awk '/workspace:/ { gsub("[()]", "", $3); print $2 }')

    hyprctl workspaces | awk -v active_workspace="$active_workspace" '
        $1 == "workspace" && $3 == active_workspace { in_target=1 }
        in_target && $1 == "windows:" { print $2; exit }
    '
}


function call_split_out {
  if [[ "$force_split_out" == 0 ]]; then
    icon=' 󰍽 '
  elif [[ "$force_split_out" == 1 ]]; then
    icon='   '
  else
    icon='   '
  fi
}

if [[ "$current_layout" == dwindle ]]; then
  call_split_out
else
  icon='󰶮  '
fi

echo -n "$icon" ; windows_in_active_workspace
