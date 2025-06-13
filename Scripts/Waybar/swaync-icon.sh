swayncNoti=$(swaync-client --count)
swayncDnd=$(swaync-client --get-dnd)

function indicator {
  if [[ "$swayncNoti" == 0 ]];then
    echo "󰂚"
  else
    echo "󱅫"
  fi
}

if [[ "$swayncDnd" == 'true' ]]; then
  echo "<span font='FiraCodeRetina 14.5'>󰂛</span>"
else
  icon=$(indicator)
  echo "<span font='FiraCodeRetina 14.0'>$icon</span><span font='Fira Code Bold 8.0'rise='4000'> $swayncNoti</span>"
fi
