#/bin/bash

current_layout=$(hyprctl getoption general:layout | grep -oP '(?<=str: )\w+')

if [[ "$current_layout" == "master" ]]; then
    hyprctl keyword general:layout "dwindle"
        notify-send -t 750 -h boolean:transient:true \
          -h string:x-canonical-private-synchronous:layout 'dwindle'
else
    hyprctl keyword general:layout "master"
        notify-send -t 750 -h boolean:transient:true \
          -h string:x-canonical-private-synchronous:layout 'master'
fi
