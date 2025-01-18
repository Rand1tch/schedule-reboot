#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Using: $0 'HH:MM YYYY-MM-DD'"
    exit 1
fi

TIME=$1

if ! [[ "$TIME" =~ ^[0-9]{2}:[0-9]{2}\ [0-9]{4}\-[0-9]{2}\-[0-9]{2}$ ]]; then
echo "Error: Invalid date and time format. Use 'HH:MM YYYY-MM-DD.'"
exit 1
fi

if ! command -v at &> /dev/null; then
    echo "Command 'at' not found. Trying to install the package..."
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y at
elif command -v yum &> /dev/null; then
    sudo yum install -y at
elif command -v dnf &> /dev/null; then
    sudo dnf install -y at
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy at -y
else
    echo "Error: Unable to install 'at' package. Please install it manually."
    exit 1
fi

echo "Package 'at' installed successfully."


read -p "You want to set this date and time? (yes/no): " CONFIRMATION

if [[ "$CONFIRMATION" != "yes" ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo "/bin/bash -c '/sbin/shutdown -r now'" | at "$TIME"

echo "Restart server is scheduled with $TIME."
