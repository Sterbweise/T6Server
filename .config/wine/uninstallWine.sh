#!/bin/bash

# File: uninstallWine.sh
# Description: Script to uninstall Wine for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--uninstall" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to uninstall Wine
uninstallWine() {
    {
        # Check if Wine is installed before attempting to remove
        if dpkg -l | grep -q winehq-stable; then
            apt-get remove --purge winehq-stable -y
        fi

        # Remove Wine repository based on Debian version if it exists
        if [ -f /etc/apt/sources.list.d/wine.list ]; then
            rm /etc/apt/sources.list.d/wine.list
        fi

        # Remove Wine repository key if it exists
        if [ -f /etc/apt/trusted.gpg.d/winehq.asc ]; then
            rm /etc/apt/trusted.gpg.d/winehq.asc
        fi

        # Remove Wine environment variables from .bashrc
        sed -i '/WINEPREFIX/d' ~/.bashrc
        sed -i '/WINEDEBUG/d' ~/.bashrc
        sed -i '/WINEARCH/d' ~/.bashrc
        sed -i '/WINEESYNC/d' ~/.bashrc
        sed -i '/WINEFSYNC/d' ~/.bashrc
        sed -i '/WINEDLLOVERRIDES/d' ~/.bashrc

        # Remove Wine prefix directory if it exists
        if [ -d "$HOME/.wine" ]; then
            rm -rf "$HOME/.wine"
        fi

        # Update package list
        apt-get update
    } > /dev/null 2>&1 &
    showProgressIndicator "$(getMessage "uninstallWine")"
    
    # Verify uninstallation
    if ! dpkg -l | grep -q winehq-stable; then
        printf "${GREEN}Success:${NC} Wine has been uninstalled.\n"
    else
        printf "${RED}Error:${NC} Wine uninstallation may have failed.\n"
        printf "You can try manually removing Wine using:\n"
        printf "sudo apt-get remove --purge winehq-stable\n"
    fi
}

# Run the uninstallation function if --uninstall is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--uninstall" ]; then
    uninstallWine
else
    echo "Usage: $0 [--uninstall] | [--import]"
    echo "This script uninstalls Wine. Use --uninstall or no argument to proceed with uninstallation."
fi
