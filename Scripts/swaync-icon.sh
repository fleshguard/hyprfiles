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
  echo "󰂛"
else
  indicator
fi
