wifi_status=$(rfkill list all | awk '/phy0/{f=1} f&&/Soft blocked/{print $3; exit}')

if [[ "$wifi_status" == 'yes' ]]; then
  echo ' 󰖪 '
else
  echo ' 󰖩 '
fi
