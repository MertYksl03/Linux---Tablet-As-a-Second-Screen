#!/bin/bash

# Virtually plug the monitor
xrandr --newmode "1280x800_60.00"   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync
xrandr --addmode HDMI-1-0 "1280x800_60.00"
xrandr --output HDMI-1-0 --right-of eDP --mode 1280x800_60.00

# Start the android server
adb start-server
adb reverse tcp:5900 tcp:5900

# Start the x11vnc server in the background and capture its PID
x11vnc --clip 1280x800+1920+0  -viewonly -repeat -rfbwait 3000 -once
  
VNC_PID=$!

cleanup() {
    echo "Stopping x11vnc..."
    kill "$VNC_PID" 2>/dev/null
    echo "Killing ADB server..."
    adb kill-server 
    echo "Turning off HDMI-1-0..."
    xrandr --output HDMI-1-0 --off
    echo "Cleanup complete."
}

# Handle script exit and Ctrl+C
trap cleanup EXIT SIGINT SIGTERM

# Keep script running until x11vnc stops or Ctrl+C is pressed
wait "$VNC_PID"
