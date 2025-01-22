#!/bin/bash

LOGFILE="/var/log/reboot_scheduler.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

cancel_reboot() {
    atq | grep "shutdown -r now" | awk '{print $1}' | xargs -r atrm
    log "Scheduled reboot has been canceled."
    echo "Scheduled reboot has been canceled."
    exit 0
}

list_scheduled() {
    echo "Scheduled tasks:"
    atq
    exit 0
}

if [ "$#" -eq 2 ] && [ "$1" == "--cancel" ]; then
    cancel_reboot
elif [ "$#" -eq 1 ] && [ "$1" == "--list" ]; then
    list_scheduled
elif [ "$#" -ne 1 ]; then
    echo "Usage: $0 'HH:MM YYYY-MM-DD' or $0 --cancel to cancel or $0 --list to view scheduled tasks."
    exit 1
fi

TIME=$1

if ! date -d "$TIME" &> /dev/null; then
    echo "Error: Invalid date and time format. Use 'HH:MM YYYY-MM-DD'."
    exit 1
fi

if ! command -v at &> /dev/null; then
    echo "Command 'at' not found. Please install the 'at' package manually."
    exit 1
fi

read -p "Do you want to set this date and time? (yes/no): " CONFIRMATION

if [[ "$CONFIRMATION" != "yes" ]]; then
    echo "Operation canceled."
    exit 0
fi

echo "/sbin/shutdown -r now" | at "$TIME"
log "Reboot scheduled for $TIME."
echo "Reboot scheduled for $TIME."
