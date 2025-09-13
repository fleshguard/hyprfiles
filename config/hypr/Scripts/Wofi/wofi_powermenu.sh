
lastlogin="`last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7`"
uptime="`uptime -p | sed -e 's/up //g;s/ minutes/m/g;s/ hours*,/h/g'`"

hibernate=' '
shutdown='󰐥'
reboot=' '
lock='󰌾'
suspend='󰤄'
logout='󰍃'
yes=''
no=' ' 

wofi_cmd() {
	wofi -dmenu -p " $USER $uptime" #--config 
}

confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

run_wofi() {
	echo -e "$lock\n$reboot\n$logout\n$suspend\n$shutdown\n$hibernate" | wofi_cmd
}

run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff || loginctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot || loginctl reboot
		elif [[ $1 == '--hibernate' ]]; then
			systemctl hibernate
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			loginctl terminate-user $USER	&& pkill Hyprland
		fi
	else
		exit 0
	fi
}

chosen="$(run_wofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $hibernate)
		run_cmd --hibernate
        ;;
    $lock)
       	hyprlock 
		;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
