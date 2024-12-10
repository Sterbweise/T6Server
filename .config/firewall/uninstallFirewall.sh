#!/bin/bash

# File: uninstallFirewall.sh
# Description: Script to uninstall firewall for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--uninstall" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to uninstall firewall
uninstallFirewall() {
    {
        # Check if ufw is installed before attempting to disable
        if command -v ufw >/dev/null 2>&1; then
            ufw disable
        fi

        # Check if ufw or fail2ban are installed before attempting to remove
        if dpkg -l | grep -qE "ufw|fail2ban"; then
            apt-get remove --purge ufw fail2ban -y
        fi

        # Clean up any leftover configuration files
        apt-get autoremove -y
        apt-get autoclean
    } > /dev/null 2>&1 &
    showProgressIndicator "$(getMessage "remove_firewall")"

    # Verify uninstallation
    if command -v ufw >/dev/null 2>&1 || command -v fail2ban-client >/dev/null 2>&1; then
        printf "${COLORS[RED]}Error:${COLORS[RESET]} Firewall uninstallation failed.\n"
        printf "Attempting manual removal...\n"
        apt-get remove --purge ufw fail2ban -y
        apt-get autoremove -y
        apt-get autoclean
        if command -v ufw >/dev/null 2>&1 || command -v fail2ban-client >/dev/null 2>&1; then
            printf "${COLORS[RED]}Error:${COLORS[RESET]} Manual removal failed. Please check your system and try again.\n"
            exit 1
        fi
    fi

    if [ "$1" = "--uninstall" ]; then
        printf "${COLORS[GREEN]}Success:${COLORS[RESET]} Firewall has been uninstalled.\n"
    fi
}

# Run the uninstallation function if --uninstall is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--uninstall" ]; then
    uninstallFirewall
else
    echo "Usage: $0 [--uninstall | --import]"
    echo "This script uninstalls the firewall. Use --uninstall or --import to proceed with uninstallation."
fi
