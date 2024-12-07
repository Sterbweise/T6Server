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
    
    if command -v ufw &> /dev/null ; then
        printf " ${GREEN}⬤${NC} Firewall installed (SSH port: %s)\n" "${ssh_port:-22}"
    else
        printf " ${RED}⬤${NC} Firewall not installed (${ORANGE}Optional${NC})\n"
    fi
    
    if command -v dotnet &> /dev/null ; then
        printf " ${GREEN}⬤${NC} .NET Framework installed\n"
    else
        printf " ${RED}⬤${NC} .NET Framework not installed (${ORANGE}Optional${NC})\n"
    fi
    
    printf " ${GREEN}⬤${NC} Game binaries installed\n"
    
    if command -v wine &> /dev/null ; then
        printf " ${GREEN}⬤${NC} Wine installed\n"
    else
        printf " ${RED}⬤${NC} Wine not installed (${ORANGE}Optional${NC})\n"
    fi
    
    # Display server information directly without asking
    printf "\n${CYAN} Server Information:${NC}\n"
    printf " - Installation Directory: %s\n" "${WORKDIR:-/opt/T6Server}"
    printf " - Operating System: %s %s\n" "${DISTRO^}" "$VERSION"
    
    # Network Information
    LOCAL_IP=$(hostname -I | awk '{print $1}')
    PUBLIC_IP=$(curl -s --max-time 5 https://api.ipify.org || echo "Unknown")
    HOSTNAME=$(hostname)
    
    printf " - Hostname: %s\n" "$HOSTNAME"
    printf " - Local IP: %s\n" "${LOCAL_IP:-Unknown}"
    printf " - Public IP: %s\n" "${PUBLIC_IP}"
    
    # System Resources
    TOTAL_RAM=$(free -h | awk '/^Mem:/ {print $2}')
    FREE_RAM=$(free -h | awk '/^Mem:/ {print $4}')
    CPU_INFO=$(lscpu | grep "Model name" | cut -d ':' -f2 | xargs)
    DISK_SPACE=$(df -h "${WORKDIR:-/opt/T6Server}" | awk 'NR==2 {print $4}')
    
    printf " - CPU: %s\n" "$CPU_INFO"
    printf " - Total RAM: %s\n" "$TOTAL_RAM"
    printf " - Available RAM: %s\n" "$FREE_RAM"
    printf " - Available Disk Space: %s\n" "$DISK_SPACE"
    
    # Network Ports Status
    printf " - Network Ports Status:\n"
    if command -v netstat &> /dev/null; then
        printf "   ⚬ SSH Port (%s): %s\n" "${ssh_port:-22}" \
            "$(netstat -tuln | grep ":${ssh_port:-22}" > /dev/null && echo "${GREEN}Open${NC}" || echo "${RED}Closed${NC}")"
    fi
    
    # Wait for user acknowledgment
    printf "\n Press any key to exit..."
    stty sane
    read -r 
    echo
    exit 0
}