#!/bin/bash

# install.sh - Plutonium Call of Duty: Black Ops II Server Installation Script
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 01/09/2024

# Description:
# This script automates the installation process for a Plutonium Call of Duty: Black Ops II
# dedicated server. It handles system updates, firewall configuration, Wine installation,
# .NET framework setup, and game binary installation.

# Usage:
# Run this script with sudo permissions:
# sudo ./install.sh

# Note: This script requires an active internet connection and sudo privileges.

# Source configuration and function files
# These files contain necessary variables and functions used throughout the script
DEFAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$DEFAULT_DIR/.config/config.sh"
source "$DEFAULT_DIR/.config/function.sh"

# Check for sudo permissions
# The script requires elevated privileges to perform system-wide changes
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Language selection
# Allows users to choose their preferred language for script messages
showLogo
selectLanguage

# Ask for installation options
# Prompts the user for specific components they want to install
showLogo
confirmInstallations

# Show logo
showLogo

# Update the system
# Ensures the system is up-to-date before proceeding with the installation
updateSystem

# Install dependencies
# Installs necessary dependencies for the script to function
installDependencies

# Configure firewall if requested
# Sets up firewall rules to allow server traffic if the user opts for it
if [[ "$firewall" =~ ^[yYoO]$ ]] || [[ -z "$firewall" ]]; then
    installFirewall "$ssh_port"
fi

# Enable 32-bit packages
# Required for compatibility with certain components of the server
enable32BitPackages

# Install Wine
# Necessary for running Windows executables on Linux
installWine

# Install Dotnet if requested
# Required for certain server functionalities
if [[ "$dotnet" =~ ^[yYoO]$ ]] || [[ -z "$dotnet" ]]; then
    installDotnet
fi

# Install game binaries
# Downloads and sets up the necessary game files for the server
installGameBinaries 

# Display installation completion message
# Informs the user that the installation process is complete
finishInstallation

# Reset terminal settings and exit
# Ensures the terminal is left in a clean state after script execution
stty -igncr
exit