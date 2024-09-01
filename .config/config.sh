#!/bin/bash

# config.sh - Configuration file for Plutonium Call of Duty: Black Ops II Server
# Version: 3.0.1
# Author: Sterbweise
# Last Updated: 01/09/2024

# Description:
# This script defines global variables and configurations used across the server installation
# and management scripts. It includes settings for work directories, distribution detection,
# color codes for output formatting, and language preferences.

# Usage:
# This file is sourced by other scripts and should not be executed directly.

# Note: Modify the variables in this file to customize your server setup.

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
# These variables allow for colored text output in the terminal
YELLOW='\033[1;33m'
GREY='\033[1;37m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BLACK='\033[0;30m'
ORANGE='\033[0;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
LIGHT_CYAN='\033[1;36m'
LIGHT_RED='\033[1;31m'
LIGHT_PURPLE='\033[1;35m'
NC='\033[0m'  # No Color (resets color to default)

# Global variables
# These variables are used across different scripts for configuration
language=0    # Default language setting (0 for English)
firewall=""   # Firewall configuration (empty string for default behavior)
ssh_port=22   # Default SSH port
dotnet=""     # .NET installation flag (empty string for default behavior)
