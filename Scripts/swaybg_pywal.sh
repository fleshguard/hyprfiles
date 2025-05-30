wallpaper_path="$1"

if [[ -f "$wallpaper_path" ]]; then
  pkill -x swaybg
  swaybg -o '*' -m fill -i $wallpaper_path & disown
  wal -c 
  wal -n -t -i $wallpaper_path

  swaync-client --reload-css

  hyprctl reload

  cat ~/.cache/wal/sequences

  cp -r $wallpaper_path ~/Pictures/Wallpapers/PyWal/pywallpaper.png
else
  echo "Invalid Path"
  exit 1
fi
