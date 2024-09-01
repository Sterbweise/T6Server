#!/bin/bash

# File: wine-install.sh
# Description: Script to install and configure Wine for the Plutonium Call of Duty: Black Ops II Server
# Version: 1.0.0
# Author: Sterbweise
# Last Updated: 01/09/2024

# Import global configurations
if [ "$1" = "--install" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to install Wine
installWine() {
    {
        # Add Wine repository key if it doesn't exist
        if [ ! -f /etc/apt/keyrings/winehq-archive.key ]; then
            sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
        fi

        # Add Wine repository sources based on Debian version
        case "$VERSION" in
            "12") SYSTEM_VERSION="bookworm" ;;
            "11") SYSTEM_VERSION="bullseye" ;;
            "10") SYSTEM_VERSION="buster" ;;
            *) 
                echo "Unsupported Debian version. Using bullseye sources by default."
                SYSTEM_VERSION="bullseye"
                ;;
        esac

        SOURCES_FILE="/etc/apt/sources.list.d/winehq-${SYSTEM_VERSION}.sources"
        if [ ! -f "$SOURCES_FILE" ]; then
            SOURCES_URL="https://dl.winehq.org/wine-builds/debian/dists/${SYSTEM_VERSION}/winehq-${SYSTEM_VERSION}.sources"
            sudo wget -O "$SOURCES_FILE" "$SOURCES_URL"
        fi

        # Update package list and install Wine
        if ! dpkg -l | grep -q winehq-stable; then
            sudo apt update -y
            sudo apt install --install-recommends winehq-stable -y
        fi

        # Configure Wine environment
        if [ ! -d "$HOME/.wine" ]; then
            # Add Wine environment variables if they don't exist
            declare -A wine_vars=(
                ["WINEPREFIX"]="$HOME/.wine"
                ["WINEDEBUG"]="-all"
                ["WINEARCH"]="win64"
                ["WINEESYNC"]="1"
                ["WINEFSYNC"]="1"
                ["WINEDLLOVERRIDES"]="mscoree,mshtml="
            )

            for var in "${!wine_vars[@]}"; do
                if ! grep -q "$var" "$HOME/.bashrc"; then
                    echo "export $var=${wine_vars[$var]}" >> "$HOME/.bashrc"
                fi
            done
            
            # Apply changes to current session
            source "$HOME/.bashrc"
            
            # Run Wine configuration
            winecfg
        fi
    } > /dev/null 2>&1 &
    showProgressIndicator "$(getMessage "wine")"
    
    # Verify installation
    if ! command -v wine &> /dev/null; then
        printf "${RED}Error:${NC} Wine installation failed.\n"
        printf "You can try running the installation script separately by executing:\n"
        printf "cd .config/wine && ./wine-install.sh\n"
    fi
}

# Run the installation function if --install is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--install" ]; then
    installWine
else
    echo "Usage: $0 [--install] | [--import]"
    echo "This script installs Wine. Use --install or no argument to proceed with installation."
fi
