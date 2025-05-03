hyprctl workspaces | grep -A 2 "special:magic" | awk '{ print "["$3,$2"]" }'
