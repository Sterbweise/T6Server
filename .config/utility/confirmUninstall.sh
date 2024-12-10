# Function to confirm uninstallation
# This provides a safety check before proceeding with uninstallation
confirmUninstall() {
    stty sane
    local uninstallDotnet=false
    local uninstallWine=false
    local disable_32bit=false
    local uninstallFirewall=false
    local uninstallGameBinaries=false

    # Display warning message
    printf "\n${COLORS[RED]}WARNING: This will completely remove T6 Server and its dependencies.${COLORS[RESET]}\n"
    printf "${COLORS[YELLOW]}Are you sure you want to continue? (y/N): ${COLORS[RESET]}"
    
    read -r confirm
    
    # Convert input to lowercase for case-insensitive comparison
    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
        printf "\n${COLORS[GREEN]}Uninstallation cancelled.${COLORS[RESET]}\n"
        exit 0
    fi

    # Prompt for specific component uninstallation
    printf "\n${COLORS[CYAN]}Select components to uninstall:${COLORS[RESET]}\n"
    
    # Dotnet uninstallation
    printf "Uninstall .NET Framework? [y/N]: "
    read -r dotnet_choice
    dotnet_choice=$(echo "$dotnet_choice" | tr '[:upper:]' '[:lower:]')
    [[ "$dotnet_choice" == "y" || "$dotnet_choice" == "yes" ]] && uninstallDotnet=true

    # Wine uninstallation
    printf "Uninstall Wine? [y/N]: "
    read -r wine_choice
    wine_choice=$(echo "$wine_choice" | tr '[:upper:]' '[:lower:]')
    [[ "$wine_choice" == "y" || "$wine_choice" == "yes" ]] && uninstallWine=true

    # Firewall uninstallation
    printf "Remove firewall configuration? [y/N]: "
    read -r firewall_choice
    firewall_choice=$(echo "$firewall_choice" | tr '[:upper:]' '[:lower:]')
    [[ "$firewall_choice" == "y" || "$firewall_choice" == "yes" ]] && uninstallFirewall=true

    # Game binaries uninstallation
    printf "Remove game binaries? [y/N]: "
    read -r binaries_choice
    binaries_choice=$(echo "$binaries_choice" | tr '[:upper:]' '[:lower:]')
    [[ "$binaries_choice" == "y" || "$binaries_choice" == "yes" ]] && uninstallGameBinaries=true

    # Disable 32-bit packages
    printf "Disable 32-bit packages? [y/N]: "
    read -r bit_choice
    bit_choice=$(echo "$bit_choice" | tr '[:upper:]' '[:lower:]')
    [[ "$bit_choice" == "y" || "$bit_choice" == "yes" ]] && disable_32bit=true

    # Export variables for use in other scripts
    export uninstallDotnet
    export uninstallWine
    export disable_32bit
    export uninstallFirewall
    export uninstallGameBinaries
}