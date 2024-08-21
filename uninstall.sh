#!/bin/bash

# Source configuration and functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/functions.sh"

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
clearclear_and_show_logo

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
printf "\n${GREEN}$(get_message "uninstall_finish")${NC}\n"
printf "\n$(get_message "quit")"
read

# Reset terminal settings and exit
stty -igncr
exit