weather=$(curl -s 'wttr.in/?format=%c+%t+%C' | tr -d '+' | awk '{$1=$1; print}' | sed -E 's/^([^ ]+) ([^ ]+) (.+)/\1   \2  \3/')

# case statement in weather? for corresponding emojis based on weather? i.e  Light drizzle=🌦️

if echo "$weather" | grep -q -E "°C|°F"; then 
  echo "$weather"
else 
  #echo "󰖐 󰖝  Weather data unavailable."
  exit 1
fi

