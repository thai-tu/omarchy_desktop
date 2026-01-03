#!/usr/bin/env bash

CACHE_FILE="/tmp/waybar-updates-cache"
CACHE_DURATION=300

check_updates() {
    local official=0
    local aur=0

    # Check official repos
    if command -v checkupdates &> /dev/null; then
        official=$(checkupdates 2>/dev/null | wc -l) || official=0
    fi

    # Check AUR (prefer paru for Omarchy, fallback to yay)
    if command -v paru &> /dev/null; then
        aur=$(paru -Qua 2>/dev/null | wc -l) || aur=0
    elif command -v yay &> /dev/null; then
        aur=$(yay -Qua 2>/dev/null | wc -l) || aur=0
    fi

    # Return both values separated by colon
    echo "$official:$aur"
}

# Use cache if valid
if [[ -f "$CACHE_FILE" ]]; then
    cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
    if [[ $cache_age -lt $CACHE_DURATION ]]; then
        updates=$(cat "$CACHE_FILE")
    else
        updates=$(check_updates)
        echo "$updates" > "${CACHE_FILE}.tmp" && mv "${CACHE_FILE}.tmp" "$CACHE_FILE"
    fi
else
    updates=$(check_updates)
    echo "$updates" > "${CACHE_FILE}.tmp" && mv "${CACHE_FILE}.tmp" "$CACHE_FILE"
fi

# Parse updates (format: official:aur)
IFS=':' read -r official aur <<< "$updates"
total=$((official + aur))

# Output JSON with detailed tooltip
if [[ "$total" -gt 0 ]]; then
    tooltip="Official: $official | AUR: $aur\nClick to update system"
    echo "{\"text\":\"$total\",\"tooltip\":\"$tooltip\",\"class\":\"pending\"}"
else
    echo "{\"text\":\"0\",\"tooltip\":\"System up to date ✓\",\"class\":\"updated\"}"
fi