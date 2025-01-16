#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Using: $0 'HH:MM YYYY-MM-DD'"
    exit 1
fi

TIME=$1

if ! command -v at &> /dev/null; then
    echo "Error: command 'at' not installed. Install Package 'at'."
    exit 1
fi


read -p "You want to set this date and time? (yes/no): " CONFIRMATION

if [[ "$CONFIRMATION" != "yes" ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo "/bin/bash -c '/sbin/shutdown -r now'" | at "$TIME"

echo "Restart server is scheduled with $TIME."
