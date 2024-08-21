#!/bin/bash

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

# Clear the terminal screen and show logo
clear_and_show_logo

# Language selection
select_language
clear_and_show_logo

# Confirm uninstallation
confirm_uninstall

# Perform uninstallation
uninstall_game_binaries
uninstall_dotnet
uninstall_wine
remove_firewall

# Clean up
{
    apt-get autoremove -y
    apt-get clean
} > /dev/null 2>&1 &
spinner "$(get_message "cleanup")"

# Display completion message
finish_installation

# Reset terminal settings and exit
stty -igncr
exit