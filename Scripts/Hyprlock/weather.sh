#!/bin/bash

weather=$(echo "It is currently <b>$(curl -s 'wttr.in?format=%t' | tr -d '+')</b> and <b>$(curl -s 'wttr.in?format=%C')</b>")

if echo "$weather" | grep -q -E "°C|°F" ; then
  echo "$weather"
else  
  echo "<b><big>󰖐 󰖝</big>  Weather data unavailable.</b>"
fi
