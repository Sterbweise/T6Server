#!/bin/bash

# File: uninstallDotnet.sh
# Description: Script to uninstall .NET for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--uninstall" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to uninstall .NET
uninstallDotnet() {
    {
        # Check if .NET packages are installed before attempting to remove
        if dpkg -l | grep -qE "aspnetcore-runtime-8.0|aspnetcore-runtime-7.0"; then
            if [ "$VERSION_ID" = "12" ] || [ "$VERSION_ID" = "11" ]; then
                apt-get remove --purge aspnetcore-runtime-8.0 -y
            elif [ "$VERSION_ID" = "10" ]; then
                apt-get remove --purge aspnetcore-runtime-7.0 -y
            fi
        fi

        # Remove Microsoft repository list file if it exists
        if [ -f /etc/apt/sources.list.d/microsoft-prod.list ]; then
            rm /etc/apt/sources.list.d/microsoft-prod.list
        fi

        # Remove Microsoft repository key if it exists
        if [ -f /etc/apt/trusted.gpg.d/microsoft.asc.gpg ]; then
            rm /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        fi

        # Update package list
        apt-get update
    } > /dev/null 2>&1 &
    showProgressIndicator "$(getMessage "uninstallDotnet")"
    
    # Verify uninstallation
    if ! dpkg -l | grep -qE "aspnetcore-runtime-8.0|aspnetcore-runtime-7.0"; then
        printf "${GREEN}Success:${NC} .NET has been uninstalled.\n"
    else
        printf "${RED}Error:${NC} .NET uninstallation may have failed.\n"
        printf "You can try manually removing .NET using:\n"
        printf "sudo apt-get remove --purge aspnetcore-runtime-8.0 aspnetcore-runtime-7.0\n"
    fi
}

# Run the uninstallation function if --uninstall is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--uninstall" ]; then
    uninstallDotnet
else
    echo "Usage: $0 [--uninstall]"
    echo "This script uninstalls .NET. Use --uninstall or no argument to proceed with uninstallation."
fi
