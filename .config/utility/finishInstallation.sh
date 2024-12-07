# Description:
# This script contains the finishInstallation function, which is used to display
# a summary of the server installation and offer to display server information.

# Usage:
# This script is used to display a summary of the server installation and offer to display server information.

# Note:
# This script should be called after the server installation is complete.

finishInstallation() {
    showLogo
    printf "\n${GREEN}%s${NC}\n" "$(getMessage "finish")"
    printf "\n${YELLOW}%s${NC}\n" "$(getMessage "quit")"
    
    # Display summary of installed components
    printf "\n${CYAN} Installation Summary:${NC}\n"
    
    # Use safer variable checks and quoting
    if [[ "$firewall" == "yes" ]]; then
        printf " - Firewall installed (SSH port: %s)\n" "${ssh_port:-Unknown}"
    fi
    
    if [[ "$dotnet" == "yes" ]]; then
        printf " - .NET installed\n"
    fi
    
    printf " - Game binaries installed\n"
    
    # Display server information directly without asking
    printf "\n${CYAN} Server Information:${NC}\n"
    printf " - Installation Directory: %s\n" "${WORKDIR:-/opt/T6Server}"
    
    # Safely get server IP
    SERVER_IP=$(hostname -I | awk '{print $1}')
    printf " - Server IP: %s\n" "${SERVER_IP:-Unknown}"
    
    # Wait for user acknowledgment
    printf "\n Press any key to exit..."
    read -r 
    echo
    exit 0
}