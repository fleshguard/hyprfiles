wallpaper_path="$1"

if [[ -f "$wallpaper_path" ]]; then
  pkill -x swaybg ; pkill -x mpvpaper
  swaybg -o '*' -m fill -i "$wallpaper_path" & disown

  wal -c 
  wal -n -t -i "$wallpaper_path"

  echo -e "\n\e[1m[*] swaync-client --reload-css\e[0m"
  swaync-client --reload-css

  echo -e "\n\e[1m[*] hyprctl reload\e[0m"
  hyprctl reload

  cat ~/.cache/wal/sequences

  cp -r "$wallpaper_path" ~/Pictures/Wallpapers/PyWal/pywallpaper

  echo -e "\nUsing \e[1m'$wallpaper_path'\e[0m ..."
else
  echo -e "\e[1mInvalid path, or none given.\e[0m"
  exit 1
fi
