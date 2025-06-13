eth0_state=$(nmcli device show eth0 | awk -F': +' '/GENERAL.STATE/ {print $2}')

if [[ "$eth0_state" == '100 (connected)' ]]; then
  nmcli device down eth0 
  echo 'eth0 down'
else
  nmcli device up eth0 
  echo 'eth0 up'
fi
