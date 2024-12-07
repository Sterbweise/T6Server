#!/bin/bash

# File: uninstallDependencies.sh
# Description: Script to uninstall dependencies for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--uninstall" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to uninstall dependencies
uninstallDependencies() {
    {
        apt-get remove -y software-properties-common apt-transport-https
        apt-get autoremove -y
    } > /dev/null 2>&1 &
    showProgressIndicator "$(getMessage "cleanup")"
    
    # Verify uninstallation
    if dpkg -s software-properties-common &> /dev/null || dpkg -s apt-transport-https &> /dev/null
    then
        printf "${RED}Error:${NC} Dependencies uninstallation failed.\n"
        printf "Attempting manual removal...\n"
        apt-get remove -y software-properties-common apt-transport-https
        apt-get autoremove -y
        if dpkg -s software-properties-common &> /dev/null || dpkg -s apt-transport-https &> /dev/null
        then
            printf "${RED}Error:${NC} Manual removal failed. Some dependencies may still be present.\n"
        else
            printf "${GREEN}Success:${NC} Dependencies have been manually removed.\n"
        fi
    else
        if [ "$1" = "--uninstall" ]; then
            printf "${GREEN}Success:${NC} Dependencies have been uninstalled.\n"
        fi
    fi
}

# Run the uninstallation function if --uninstall is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--uninstall" ]; then
    uninstallDependencies
else
    echo "Usage: $0 [--uninstall] | [--import]"
    echo "This script uninstalls dependencies. Use --uninstall or no argument to proceed with uninstallation."
fi
