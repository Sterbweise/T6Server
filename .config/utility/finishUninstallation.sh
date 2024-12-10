# Description:
# This script contains the finishUninstallation function, which is used to display
# a summary of the server uninstallation.

# Usage:
# This script is used to display a summary of the server uninstallation.

# Note:
# This script should be called after the server uninstallation is complete.

finishUninstallation() {
    showLogo
    printf "\n${COLORS[GREEN]}%s${COLORS[RESET]}\n" "$(getMessage "finish")"
    printf "\n${COLORS[YELLOW]}%s${COLORS[RESET]}\n" "$(getMessage "quit")"
    
    # Display summary of uninstalled components
    printf "\n${COLORS[CYAN]} Uninstallation Summary:${COLORS[RESET]}\n"
    
    if ! command -v ufw &> /dev/null ; then
        printf " - ${COLORS[GREEN]}✓${COLORS[RESET]} Firewall uninstalled\n"
    else
        printf " - ${COLORS[RED]}✕${COLORS[RESET]} Firewall still present\n"
    fi
    
    if ! command -v dotnet &> /dev/null ; then
        printf " - ${COLORS[GREEN]}✓${COLORS[RESET]} .NET Framework uninstalled\n"
    else
        printf " - ${COLORS[RED]}✕${COLORS[RESET]} .NET Framework still present\n"
    fi
    
    if ! command -v wine &> /dev/null ; then
        printf " - ${COLORS[GREEN]}✓${COLORS[RESET]} Wine uninstalled\n"
    else
        printf " - ${COLORS[RED]}✕${COLORS[RESET]} Wine still present\n"
    fi

    # Check if game directory exists
    if [ ! -d "${WORKDIR:-/opt/T6Server}" ]; then
        printf " - ${COLORS[GREEN]}✓${COLORS[RESET]} Game binaries removed\n"
    else
        printf " - ${COLORS[RED]}✕${COLORS[RESET]} Game binaries still present\n"
    fi
    
    # System cleanup information
    printf "\n${COLORS[CYAN]} Cleanup Information:${COLORS[RESET]}\n"
    printf " - Previous Installation Directory: %s\n" "${WORKDIR:-/opt/T6Server}"
    printf " - Operating System: %s %s\n" "${DISTRO^}" "$VERSION"

    # System Resources After Cleanup
    printf "\n${COLORS[CYAN]} System Resources After Cleanup:${COLORS[RESET]}\n"
    checkAndInstallCommand "free" "procps"
    TOTAL_RAM=$(free -h | awk '/^Mem:/ {print $2}')
    FREE_RAM=$(free -h | awk '/^Mem:/ {print $4}')
    DISK_SPACE=$(df -h "${WORKDIR:-/opt/T6Server}" | awk 'NR==2 {print $4}')
    
    printf " - Total RAM: %s\n" "$TOTAL_RAM"
    printf " - Available RAM: %s\n" "$FREE_RAM"
    printf " - Available Disk Space: %s\n" "$DISK_SPACE"
    
    # Wait for user acknowledgment
    printf "\n${COLORS[YELLOW]}Press any key to exit...${COLORS[RESET]}"
    stty sane
    read -r 
    echo
    exit 0
}