#!/bin/bash

# install.sh - Plutonium Call of Duty: Black Ops II Server Installation Script
# Version: 2.1.0
# Author: Sterbweise
# Last Updated: 21/08/2024

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
source "$DEFAULT_DIR/.config/functions.sh"

# Check for sudo permissions
# The script requires elevated privileges to perform system-wide changes
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Display logo and clear screen
# This function improves user experience by presenting a clean interface
clear_and_show_logo

# Language selection
# Allows users to choose their preferred language for script messages
select_language
clear_and_show_logo

# Ask for installation options
# Prompts the user for specific components they want to install
ask_installations
clear_and_show_logo

# Update the system
# Ensures the system is up-to-date before proceeding with the installation
update_system

# Install dependencies
# Installs necessary dependencies for the script to function
install_dependencies

# Configure firewall if requested
# Sets up firewall rules to allow server traffic if the user opts for it
if [[ "$firewall" =~ ^[yYoO]$ ]] || [[ -z "$firewall" ]]; then
    install_firewall "$ssh_port"
fi

# Enable 32-bit packages
# Required for compatibility with certain components of the server
enable_32bit_packages

# Install Wine
# Necessary for running Windows executables on Linux
install_wine

# Install Dotnet if requested
# Required for certain server functionalities
if [[ "$dotnet" =~ ^[yYoO]$ ]] || [[ -z "$dotnet" ]]; then
    install_dotnet
fi

# Install game binaries
# Downloads and sets up the necessary game files for the server
install_game_binaries

# Display installation completion message
# Informs the user that the installation process is complete
finish_installation

# Reset terminal settings and exit
# Ensures the terminal is left in a clean state after script execution
stty -igncr
exit