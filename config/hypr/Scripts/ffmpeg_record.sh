#!/bin/bash

output="$HOME/Videos/Camera/output-$(date +%m-%d-%y-%I%M%p_%N).mkv"
input="/dev/video0"


record() {
  ffmpeg -re -f v4l2 -i "$input" \
    -c:v libx264 -preset ultrafast \
    -tune zerolatency \
    -f matroska "$output"
}

stream() {
  ffplay -window_title "FFmpeg camera stream" \
    -fflags nobuffer \
    -f v4l2 -i $input
}


main() {
  set -e
  trap "echo -e '\n\e[1mGracefully terminating all processes.\e[0m'; kill 0" SIGINT

  stream
  record &

  wait
}

main
