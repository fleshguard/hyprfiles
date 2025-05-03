packages=$(pacman -Qu | wc -l)

echo "sudo pacman -Sy"
sudo pacman -Sy
echo \n"Sync Completed."\n"Packages to be updated: $packages"
