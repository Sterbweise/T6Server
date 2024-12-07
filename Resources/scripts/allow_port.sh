#!/bin/bash

# Function to display error messages
display_error() {
    echo "[Error] $1" >&2
}

# Function to open a port
open_port() {
    local port=$1
    local name=$2

    if sudo ufw allow "$port" comment "$name"; then
        echo "The port $port has been opened successfully."
        return 0
    else
        display_error "Failed to open port $port."
        return 1
    fi
}

# Function to reload the firewall
reload_firewall() {
    if sudo ufw reload; then
        echo "The firewall has been reloaded successfully."
        return 0
    else
        display_error "Failed to reload the firewall."
        return 1
    fi
}

# Main script
echo "Enter the port you want to allow (Example: 4976)"
read -p 'Port Number: ' port

echo "Name of your port (Example: T6Server)"
read -p 'Name: ' name

if ! [[ "$port" =~ ^[0-9]+$ ]]; then
    display_error "Invalid port number. Please enter a numeric value."
    exit 1
fi

if [ -z "$name" ]; then
    display_error "Port name cannot be empty."
    exit 1
fi

if open_port "$port" "$name"; then
    reload_firewall
else
    exit 1
fi