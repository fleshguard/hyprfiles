bluetooth_status=$(rfkill list all | awk '/hci0/{f=1} f&&/Soft blocked/{print $3; exit}')

if [[ "$bluetooth_status" == 'yes' ]]; then
  echo ' 󰂲 '
  #echo ''
else
  echo "<span font='FiraCodeRetina 14.0'> 󰂯 </span>"
fi
