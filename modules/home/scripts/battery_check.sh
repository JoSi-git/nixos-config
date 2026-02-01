#!/usr/bin/env bash

# Flags to track if a notification was already shown (prevents constant pop-ups)
warned_low=false
warned_critical=false

# Infinite loop to keep the script running in the background
while true; do
    # Get the system path for the battery device
    BAT_PATH=$(upower -e | grep 'BAT')
    
    # Get battery percentage and remove the '%' symbol
    battery=$(upower -i "$BAT_PATH" | grep "percentage" | awk '{print $2}' | tr -d '%')
    
    # Get current power state (e.g., discharging, charging, fully-charged)
    status=$(upower -i "$BAT_PATH" | grep "state" | awk '{print $2}')

    # Only check for alerts if the laptop is currently unplugged (discharging)
    if [ "$status" = "discharging" ]; then
        
        # CRITICAL: Check if battery is 5% or less and hasn't triggered a warning yet
        if [ "$battery" -le 5 ] && [ "$warned_critical" = false ]; then
            zenity --warning --title="Battery Critical" --icon="battery-caution" \
                   --text="Battery is at ${battery}%.\nConnect charger immediately." --width=300
            warned_critical=true
            warned_low=true
        
        # LOW: Check if battery is 20% or less and hasn't triggered a warning yet
        elif [ "$battery" -le 20 ] && [ "$battery" -gt 5 ] && [ "$warned_low" = false ]; then
            zenity --info --title="Battery Low" --icon="battery-low" \
                   --text="Battery is at ${battery}%." --width=250
            warned_low=true
        fi
    else
        # If charging or full, reset the warning flags for the next time we unplug
        warned_low=false
        warned_critical=false
    fi

    # Adjust check frequency: Every 60s if low, every 5 mins (300s) if healthy
    if [ "$battery" -le 25 ]; then
        sleep 60
    else
        sleep 300
    fi
done
