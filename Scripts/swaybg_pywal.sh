wallpaper_path="$1"

if [[ -f "$wallpaper_path" ]]; then
  pkill -x swaybg
  swaybg -o '*' -m fill -i $wallpaper_path & disown

  wal -c 
  wal -n -t -i $wallpaper_path

  echo -e "\nswaync-client --reload-css"
  swaync-client --reload-css

  echo -e "\nhyprctl reload "
  hyprctl reload

  cat ~/.cache/wal/sequences

  cp -r $wallpaper_path ~/Pictures/Wallpapers/PyWal/pywallpaper.png

  echo -e "\nusing \e[1m'$wallpaper_path'\e[0m ..."
else
  echo -e "\e[1mInvalid path, or none given.\e[0m"
  exit 1
fi
