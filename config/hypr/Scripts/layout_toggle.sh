#/bin/bash

current_layout=$(hyprctl getoption general:layout | grep -oP '(?<=str: )\w+')

if [[ "$current_layout" == "master" ]]; then
    hyprctl keyword general:layout "dwindle"
    echo "dwindle"
else
    hyprctl keyword general:layout "master"
    echo "master"
fi
