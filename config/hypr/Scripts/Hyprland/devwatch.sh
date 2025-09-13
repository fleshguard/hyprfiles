#!/bin/bash

sound_cmd="paplay --property=media.role=event"


timer() {
  local elapsed=$({ time "$@"; } 2>&1 | grep real | awk '{print $2}')
  echo -e "\e[2m🔊 $elapsed\e[0m"
}


transient_notification() {
  notify-send -t 5000 -h boolean:transient:true \
  -h string:x-canonical-private-synchronous:devwatch_transient_notification "$1" "$2"
}


block_device_watch_notification() {
  echo -e "\e[1m[*] Watching block devices ...\e[0m"

  udisksctl monitor | \
  while read -r line; do
      dev=$(echo "$line" | grep -oP 'block_devices/\K[^ ]+')

      if [[ -z "$dev" ]] || [[ "$dev" =~ [0-9]$ ]]; then
          continue
      fi

      case "$line" in
          *"Added"*)
              notify-send "💽 Device added" "<small>/dev/$dev</small>"
              echo "[+] Block device added: /dev/$dev"
              ;;
          *"Removed"*)
              notify-send "🗄️ Device removed" "<small>/dev/$dev</small>"
              echo "[-] Block device removed: /dev/$dev"
              ;;
          *"Properties Changed"*)
              read -r mount_line
            
              if [[ "$mount_line" == *'MountPoints: '* ]]; then
                mount_point=$(echo "$mount_line" | grep -oP 'MountPoints:\s+\K.*')

              elif [[ -n "$mount_point" ]]; then
                mount_point=$(echo "$mount_point" | xargs)
                message="📁 Device mounted" 
                message2="/dev/$dev --> $mount_point 📋"
                wl-copy "$mount_point"
              else
                message="📂 Device unmounted"
                message2="$mount_point --> /dev/$dev"
              fi

              transient_notification "$message" "$message2"
              ;;
      esac
  done
}


usb_watch_notification() {
  echo -e "\e[1m[*] Watching USB devices ...\e[0m"

  udevadm monitor --udev --subsystem-match=usb --env | \
    while IFS= read -r line; do
      if [[ -z "$line" ]]; then

        if [[ "$ACTION" == "add" && "$DEVTYPE" == "usb_device" ]]; then
        message="🔗 Device plugged in" 
        message2="$ID_MODEL_FROM_DATABASE"
        echo "[+] Device plugged in: '$ID_MODEL_FROM_DATABASE' $(timer eval "$sound_cmd" /usr/share/sounds/ocean/stereo/device-added.oga)"
        transient_notification "$message" "$message2"
      elif [[ "$ACTION" == "remove" && "$DEVTYPE" == "usb_device" ]]; then
        echo "[-] Device unplugged: '$ID_MODEL_FROM_DATABASE' $(timer eval "$sound_cmd" /usr/share/sounds/ocean/stereo/device-removed.oga)"
      fi
      unset ACTION DEVTYPE # ID_MODEL_FROM_DATABASE
    else
      case "$line" in
        ACTION=*) ACTION="${line#ACTION=}" ;;
        DEVTYPE=*) DEVTYPE="${line#DEVTYPE=}" ;;
        ID_MODEL_FROM_DATABASE=*) ID_MODEL_FROM_DATABASE="${line#ID_MODEL_FROM_DATABASE=}" ;;
      esac
    fi
done
  
}


iface_watch_notification() {
  echo -e "\e[1m[*] Watching network interfaces ...\e[0m"

  udevadm monitor --udev --subsystem-match=net --env | \
  while IFS= read -r line; do
    if [[ -z "$line" ]]; then
      if [[ "$ACTION" == "add" ]]; then
        echo "[+] Network interface added: $INTERFACE $(timer eval "$sound_cmd" /usr/share/sounds/ocean/stereo/dialog-information.oga)"
        notify-send "🌐 Interface established" "<small>$INTERFACE</small>"
      elif [[ "$ACTION" == "remove" ]]; then
        echo "[-] Network interface removed: $INTERFACE $(timer eval "$sound_cmd" /usr/share/sounds/ocean/stereo/dialog-information.oga)"
        notify-send "⛓️‍💥 Interface disbanded" "<small>$INTERFACE</small>"
      fi
      unset ACTION INTERFACE
    else
      case "$line" in
        ACTION=*) ACTION="${line#ACTION=}" ;;
        INTERFACE=*) INTERFACE="${line#INTERFACE=}" ;;
      esac
    fi
  done
}


power_supply_watch_notification() {
  echo -e "\e[1m[*] Watching power supply ...\e[0m"
  
  local THRESHOLD=30
  local RECOVERY=35

  local LAST_ADAPTER_STATE=$(cat /sys/class/power_supply/*/online | grep -m1 . || echo "unknown")
  local LAST_BATTERY_STATE=""
  local NOTIFIED=0

  udevadm monitor --udev --subsystem-match=power_supply --env | \
  while IFS= read -r line; do 
    if [[ -z $line ]]; then
      if [[ "$POWER_SUPPLY_NAME" == ADP+([0-9]) ]]; then
        if [[ "$POWER_SUPPLY_ONLINE" != "$LAST_ADAPTER_STATE" ]]; then
          if [[ "$POWER_SUPPLY_ONLINE" == "0" ]]; then
            echo "[-] Power supply status: Offline $(timer eval "$sound_cmd" /usr/share/sounds/ocean/stereo/power-unplug.oga)"
          else
            echo "[+] Power supply status: Online $(timer eval "$sound_cmd" /usr/share/sounds/ocean/stereo/power-plug.oga)"
          fi
          LAST_ADAPTER_STATE="$POWER_SUPPLY_ONLINE"
        fi
      fi

      if [[ "$POWER_SUPPLY_NAME" == BAT+([0-9]) ]]; then
        if [[ "$POWER_SUPPLY_CAPACITY" =~ ^[0-9]+$ ]]; then
          if [[ "$POWER_SUPPLY_CAPACITY" -le "$THRESHOLD" && "$NOTIFIED" == 0 ]]; then
            echo "[!] Power supply capacity: $POWER_SUPPLY_CAPACITY% $(timer eval "$sound_cmd" /usr/share/sounds/ocean/stereo/dialog-error-critical.oga)"
            notify-send -u critical "🪫 Battery critically low" \
            "<small>$POWER_SUPPLY_CAPACITY% capacity. Plug in your device!</small>"
            NOTIFIED=1
          elif [[ "$POWER_SUPPLY_CAPACITY" -ge "$RECOVERY" && "$NOTIFIED" == 1 ]]; then
            NOTIFIED=0
          fi
        fi
      fi
      unset POWER_SUPPLY_ONLINE POWER_SUPPLY_CAPACITY POWER_SUPPLY_NAME
    else 
      case "$line" in 
        POWER_SUPPLY_ONLINE=*) POWER_SUPPLY_ONLINE="${line#POWER_SUPPLY_ONLINE=}" ;;
        POWER_SUPPLY_CAPACITY=*) POWER_SUPPLY_CAPACITY="${line#POWER_SUPPLY_CAPACITY=}" ;;
        POWER_SUPPLY_NAME=*) POWER_SUPPLY_NAME="${line#POWER_SUPPLY_NAME=}" ;;
      esac
    fi 
  done
}


main() {
  trap "echo -e '\n\e[1mReceived SIGINT, terminating all processes.\e[0m'; kill 0" SIGINT

  echo -e "\nDMY: $(date '+%d-%m-%Y, %H:%M:%S')\n" >> "$log_file"
  exec > >(tee -a "$log_file") 2>&1 
  power_supply_watch_notification &
  block_device_watch_notification &
  usb_watch_notification &
  iface_watch_notification &

  wait
}

max_lines=1000
trim=500
log_file="$HOME/.config/hypr/Scripts/Logs/devwatch_logs"

if [[ -f "$log_file" ]]; then
  if (( $(wc -l < "$log_file") > max_lines )); then
    tail -n "$trim" "$log_file" > "${log_file}.tmp" && mv "${log_file}.tmp" "$log_file"
  fi
  main
else
  touch "$log_file"
  main 
fi
