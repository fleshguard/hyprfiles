eno1_state=$(nmcli device show eno0 | awk -F': +' '/GENERAL.STATE/ {print $2}')

if [[ "$eno0_state" == '100 (connected)' ]]; then
  nmcli device down eno1 
  echo 'eno1 down'
else
  nmcli device up eno1
  echo 'eno1 up'
fi
