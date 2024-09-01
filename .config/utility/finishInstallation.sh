# Description:
# This script contains the finishInstallation function, which is used to display
# a summary of the server installation and offer to display server information.

# Usage:
# This script is used to display a summary of the server installation and offer to display server information.

# Note:
# This script should be called after the server installation is complete.

finishInstallation() {
    showLogo
    printf "\n${GREEN}$(getMessage "finish")${NC}\n"
    printf "\n${YELLOW}$(getMessage "quit")${NC}\n"
    
    # Display summary of installed components
    printf "\n${CYAN}Installation Summary:${NC}\n"
    [[ "$firewall" == "yes" ]] && printf "- Firewall installed (SSH port: $ssh_port)\n"
    [[ "$dotnet" == "yes" ]] && printf "- .NET installed\n"
    printf "- Game binaries installed\n"
    
    # Offer to display server information
    printf "\n${YELLOW}Do you want to see server information? (Y/n)${NC} "
    read -r show_info
    if [[ $show_info =~ ^[Yy]$ ]] || [[ -z $show_info ]]; then
        printf "\n${CYAN}Server Information:${NC}\n"
        printf "- Installation Directory: $WORKDIR\n"
        printf "- Server IP: $(hostname -I | awk '{print $1}')\n"
        # Add more relevant server information here
    fi
    
    # Wait for user acknowledgment
    printf "\nPress any key to exit..."
    read -n 1 -s -r
    echo
    exit 0
}