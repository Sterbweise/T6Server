#!/bin/bash

# uninstall.sh - Plutonium Call of Duty: Black Ops II Server Uninstallation Script
# Version: 3.0.1
# Author: Sterbweise
# Last Updated: 01/09/2024

# Description:
# This script automates the uninstallation process for a Plutonium Call of Duty: Black Ops II
# dedicated server. It removes game binaries, .NET framework, Wine, and reverts firewall changes.

# Usage:
# Run this script with sudo permissions:
# sudo ./uninstall.sh

# Note: This script requires sudo privileges to perform system-wide changes.

# Source configuration and function files
# These files contain necessary variables and functions used throughout the script
DEFAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$DEFAULT_DIR/.config/config.sh"
source "$DEFAULT_DIR/.config/function.sh --debug"

# Check for sudo permissions
# The script requires elevated privileges to perform system-wide changes
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Display showLogo and clear screen
# This function improves user experience by presenting a clean interface
showLogo

# Language selection
# Allows users to choose their preferred language for script messages
selectLanguage
showLogo

# Confirm uninstallation
# Prompts the user to confirm before proceeding with the uninstallation
confirmUninstall

# Perform uninstallation
# These functions remove the various components installed by the installation script
uninstallGameBinaries   # Removes game files and directories
uninstallDotnet         # Uninstalls .NET framework
uninstallWine           # Removes Wine
remove_firewall          # Reverts firewall changes made during installation

# Clean up
# Removes unnecessary packages and cleans the package cache
{
    apt-get autoremove -y
    apt-get clean
} > /dev/null 2>&1 &
showProgressIndicator "$(getMessage "cleanup")"

# Display completion message
# Informs the user that the uninstallation process is complete
finishInstallation

# Reset terminal settings and exit
# Ensures the terminal is left in a clean state after script execution
stty -igncr
exit