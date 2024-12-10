#!/bin/bash

# config.sh - Configuration file for Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Description:
# This script defines global variables and configurations used across the server installation
# and management scripts. It includes settings for work directories, distribution detection,
# color codes for output formatting, and language preferences.

# Usage:
# This file is sourced by other scripts and should not be executed directly.

# Note: Modify the variables in this file to customize your server setup.

# Set default language and locale settings
# These ensure consistent character encoding and language behavior across the system
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Work directory
# This is the base directory where the server files will be installed
WORKDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &> /dev/null && pwd)"

# Distribution detection
# Automatically detects the Linux distribution and version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
else
    # Default to Debian 10 if detection fails
    DISTRO="debian"
    VERSION="10"
fi

# Color codes for terminal output
# Import color definitions from utility/colors.sh
source "$(dirname "${BASH_SOURCE[0]}")/utility/colors.sh"


# Global variables
# These variables are used across different scripts for configuration
language=0    # Default language setting (0 for English)
firewall=""   # Firewall configuration (empty string for default behavior)
ssh_port=22   # Default SSH port
dotnet=""     # .NET installation flag (empty string for default behavior)

# Function to check and install required commands
checkAndInstallCommand() {
    local command=$1
    local package=$2
    if ! command -v "$command" &> /dev/null; then
        printf "Installing %s...\n" "$package"
        apt-get install -y "$package" > /dev/null 2>&1
    fi
}