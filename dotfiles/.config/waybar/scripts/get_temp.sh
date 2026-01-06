#!/bin/bash

# Function to find temperature input for a given name pattern
find_temp_input() {
    local pattern=$1
    for hwmon in /sys/class/hwmon/hwmon*; do
        if grep -qi "$pattern" "$hwmon/name"; then
            # Found the correct hwmon, now look for the first temp input
            for input in "$hwmon"/temp*_input; do
                if [ -f "$input" ]; then
                    echo "$input"
                    return 0
                fi
            done
        fi
    done
    return 1
}

# Main logic
case "$1" in
    cpu)
        # Try k10temp (AMD) first, then coretemp (Intel)
        TEMP_PATH=$(find_temp_input "k10temp")
        if [ -z "$TEMP_PATH" ]; then
            TEMP_PATH=$(find_temp_input "coretemp")
        fi
        LABEL="CPU"
        ICON=""
        THRESHOLD_WARN=75
        THRESHOLD_CRIT=90
        ;;
    gpu)
        # Try amdgpu, then nvidia
        TEMP_PATH=$(find_temp_input "amdgpu")
        if [ -z "$TEMP_PATH" ]; then
            TEMP_PATH=$(find_temp_input "nvidia")
        fi
        LABEL="GPU"
        ICON="󰢮 "
        THRESHOLD_WARN=80
        THRESHOLD_CRIT=95
        ;;
    *)
        echo "Usage: $0 {cpu|gpu}"
        exit 1
        ;;
esac

if [ -n "$TEMP_PATH" ] && [ -r "$TEMP_PATH" ]; then
    TEMP_MILLI=$(cat "$TEMP_PATH")
    TEMP_C=$((TEMP_MILLI / 1000))
    
    # Determine class for coloring
    CLASS="normal"
    if [ "$TEMP_C" -ge "$THRESHOLD_CRIT" ]; then
        CLASS="critical"
    elif [ "$TEMP_C" -ge "$THRESHOLD_WARN" ]; then
        CLASS="warning"
    fi

    # Output JSON for Waybar
    echo "{\"text\": \"$ICON $LABEL ${TEMP_C}°C\", \"class\": \"$CLASS\", \"tooltip\": \"Device: $LABEL\nTemperature: ${TEMP_C}°C\"}"
else
    echo "{\"text\": \"$ICON $LABEL N/A\", \"class\": \"critical\", \"tooltip\": \"Sensor not found\"}"
fi
