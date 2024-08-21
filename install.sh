#!/bin/bash

# Installation script for T6 server

# Source configuration and function files
DEFAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$DEFAULT_DIR/.config/config.sh"
source "$DEFAULT_DIR/.config/functions.sh"

# Check for sudo permissions
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

# Display logo and clear screen
clear_and_show_logo

# Language selection
select_language
clear_and_show_logo

# Ask for installation options
ask_installations
clear_and_show_logo

# Update the system
update_system

# Configure firewall if requested
if [[ "$firewall" =~ ^[yYoO]$ ]] || [[ -z "$firewall" ]]; then
    install_firewall "$ssh_port"
fi

# Enable 32-bit packages
enable_32bit_packages

# Install Wine
install_wine

# Install Dotnet if requested
if [[ "$dotnet" =~ ^[yYoO]$ ]] || [[ -z "$dotnet" ]]; then
    install_dotnet
fi

# Install game binaries
install_game_binaries

# Display installation completion message
printf "\n${GREEN}$(get_message "finish")${NC}\n"
printf "\n$(get_message "quit")"
read

# Reset terminal settings and exit
stty -igncr
exit