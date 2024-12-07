#!/bin/bash

# File: dependencies-install.sh
# Description: Script to install dependencies for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--install" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to install dependencies
installDependencies() {
    {
        apt-get update
        apt-get install -y sudo tar wget gnupg2 software-properties-common apt-transport-https curl
    } > /dev/null 2>&1 &
    showProgressIndicator "$(getMessage "dependencies_install")"
    
    # Verify installation
    if ! command -v wget &> /dev/null || ! command -v gpg &> /dev/null || ! command -v curl &> /dev/null || ! dpkg -s software-properties-common &> /dev/null || ! dpkg -s apt-transport-https &> /dev/null
    then
        printf "${RED}Error:${NC} Dependencies installation failed.\n"
        printf "Attempting reinstallation...\n"
        apt-get install -y sudo wget gnupg2 software-properties-common apt-transport-https curl
        if ! command -v wget &> /dev/null || ! command -v gpg &> /dev/null || ! command -v curl &> /dev/null || ! dpkg -s software-properties-common &> /dev/null || ! dpkg -s apt-transport-https &> /dev/null
        then
            printf "${RED}Error:${NC} Reinstallation failed. Please check your internet connection and try again.\n"
            exit 1
        fi
    fi
    
    if [ "$1" = "--install" ]; then
        printf "${GREEN}Success:${NC} Dependencies have been installed.\n"
    fi
}

# Run the installation function if --install is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--install" ]; then
    installDependencies
else
    echo "Usage: $0 [--install] | [--import]"
    echo "This script installs dependencies. Use --install or no argument to proceed with installation."
fi
