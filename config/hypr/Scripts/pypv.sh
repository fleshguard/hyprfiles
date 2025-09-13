wallpaper_path="$1"

if [[ -f "$wallpaper_path" ]]; then
  echo -e "\nExtracting frame from \e[1m'$wallpaper_path'\e[0m ... \n"
  ffmpeg -i "$wallpaper_path" -vf "select=eq(n\,0)" -vframes 1 ~/Pictures/Wallpapers/PyWal/pypv_colors.png

  pkill -x mpvpaper ; pkill -x swaybg
  mpvpaper '*' -vsp -o "no-audio loop" "$wallpaper_path" & disown 

  wal -c 
  wal -n -t -i ~/Pictures/Wallpapers/PyWal/pypv_colors.png

  echo -e "\nswaync-client --reload-css"
  swaync-client --reload-css

  echo -e "\nhyprctl reload "
  hyprctl reload

  cat ~/.cache/wal/sequences
  
  ln -ifvs "$wallpaper_path" ~/Pictures/Wallpapers/PyWal/pypv  # For manual wallpaper setting 
else
  echo -e "\e[1mInvalid path, or none given.\e[0m"
  exit 1
fi
