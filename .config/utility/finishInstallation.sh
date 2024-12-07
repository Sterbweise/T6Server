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
    [[ "$firewall" == "yes" ]] && printf "%s\n" "- Firewall installed (SSH port: $ssh_port)"
    [[ "$dotnet" == "yes" ]] && printf "%s\n" "- .NET installed"
    printf "%s\n" "- Game binaries installed"
    
    # Display server information directly without asking
    printf "\n${CYAN}Server Information:${NC}\n"
    printf "- Installation Directory: $WORKDIR\n"
    printf "- Server IP: $(hostname -I | awk '{print $1}')\n"
    # Add more relevant server information here
    
    # Wait for user acknowledgment
    printf "\nPress any key to exit..."
    read -n 1 -s -r
    echo
    exit 0
}