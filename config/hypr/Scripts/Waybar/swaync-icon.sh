swayncNoti=$(swaync-client --count)
swayncDnd=$(swaync-client --get-dnd)

function indicator {
  if [[ "$swayncNoti" == 0 ]];then
    echo "󰂚"
  else
    echo "<span font='Font Awesome 7 Free 14.0'>󱅫</span><span font='Fira Code Bold 8.0'rise='4000'> $swayncNoti</span>"
  fi
}

if [[ "$swayncDnd" == 'true' ]]; then
  echo "<span font='Font Awesome 7 Free 15'>󰂛</span>"
else
  indicator
fi
