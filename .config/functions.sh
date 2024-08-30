#!/bin/bash

# functions.sh - Plutonium Call of Duty: Black Ops II Server Functions
# Version: 2.1.0
# Author: Sterbweise
# Last Updated: 30/08/2024

# Description:
# This script contains essential functions used by the Plutonium Call of Duty: Black Ops II
# server installation, management, and uninstallation scripts. It provides utility functions
# for user interface, system operations, and server-specific tasks.

# Usage:
# This file is sourced by other scripts and should not be executed directly.

# Note: Ensure this file is in the same directory as the main scripts that use these functions.

# Function to display the logo
# This function prints a stylized ASCII art logo for the T6 Server Installer
logo() {
    printf "${RED}


                                   .        ,;                            ,;           
                ${WHITE}j,${RED}                ;W      f#i j.                        f#i j.         
 GEEEEEEEL     ${WHITE}L#,${RED}               f#E    .E#t  EW,                     .E#t  EW,        
 ,;;L#K;;.    ${WHITE}D#D${RED}              .E#f    i#W,   E##j       t      .DD. i#W,   E##j       
    t#E     ${WHITE}.K#f${RED}              iWW;    L#D.    E###D.     EK:   ,WK. L#D.    E###D.     
    t#E    ${WHITE}:W#i${RED}              L##Lffi:K#Wfff;  E#jG#W;    E#t  i#D :K#Wfff;  E#jG#W;    
    t#E   ${WHITE};##Dfff.${RED}          tLLG##L i##WLLLLt E#t t##f   E#t j#f  i##WLLLLt E#t t##f   
    t#E   ${WHITE};##${BLACK}Lt${WHITE}##,${RED}            ,W#i   .E#L     E#t  :K#E: E#tL#i    .E#L     E#t  :K#E: 
    t#E    ${WHITE}:W#;##,${RED}           j#E.      f#E:   E#KDDDD###iE#WW,       f#E:   E#KDDDD###i
    t#E     ${WHITE}.E###,${RED}         .D#j         ,WW;  E#f,t#Wi,,,E#K:         ,WW;  E#f,t#Wi,,,
    t#E       ${WHITE}G##,${RED}        ,WK,           .D#; E#t  ;#W:  ED.           .D#; E#t  ;#W:  
     fE        ${WHITE}f#,${RED}        EG.              tt DWi   ,KK: t               tt DWi   ,KK: 
      :         ${WHITE}t:${RED}        ,                                                            
    ${NC}
      ╔═══════════════════════════════════════════════════════════════════════════╗
      ║  ${RED}Name:${GREY} T6 Server Installer${NC}                                                ║
      ║  ${YELLOW}Version:${GREY} 2.1.0${NC}                                                           ║
      ║  ${PURPLE}Author:${GREY} Sterbweise${NC}                                                       ║
      ║  ${GREEN}Last Updated:${GREY} 21/08/2024${NC}                                                 ║
      ╠═══════════════════════════════════════════════════════════════════════════╣
      ║                       ${LIGHT_BLUE}\e]8;;https://github.com/Sterbweise\aGithub\e]8;;\a${NC} | ${RED}\e]8;;https://youtube.com/@Sterbweise\aYoutube\e]8;;\a${NC} | ${ORANGE}\e]8;;https://plutonium.pw\aPlutonium\e]8;;\a${NC}                        ║
      ╚═══════════════════════════════════════════════════════════════════════════╝\n\n"
}

# Function to display a spinner while a process is running
# This provides visual feedback to the user during long-running operations
spinner() { 
    pid=$!
    spin='-\|/'
    i=0
    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        printf "\r [${spin:$i:1}] $1"
        sleep .1
    done
    printf "\r [${GREEN}\xE2\x9C\x94${NC}] $1\n"
}

# Function to get a message in the selected language
# This supports localization of the script's output
get_message() {
    local key="${1}_en"
    [[ $language -eq 1 ]] && key="${1}_fr"
    echo "${!key}"
}

# Function to clear the screen and show the logo
# This improves the user interface by providing a clean, branded display
clear_and_show_logo() {
    stty igncr
    clear
    logo
}

# Function to select the language
# This allows users to choose their preferred language for script messages
select_language() {
    while true; do
        printf "${YELLOW}$(get_message "select_language")${NC}\n"
        printf "[0] English\n"
        printf "[1] French\n\n"
        printf ">>> "
        read -n 1 -r language_input
        echo  # New line after input
        case $language_input in
            0)
                language=0
                break
                ;;
            1)
                language=1
                break
                ;;
            *)
                echo "Invalid input. Please enter 0 or 1."
                ;;
        esac
    done
    clear_and_show_logo
}

# Function to update the system
# This ensures the system is up-to-date before proceeding with installations
update_system() {
    {
        # Check if an update is needed
        if ! apt-get update --dry-run 2>&1 | grep -q "0 packages can be upgraded"; then
            apt-get update
        else
            # If no update is needed, sleep for a moment to allow the spinner to show
            sleep 2
        fi
    } > /dev/null 2>&1 &
    spinner "$(get_message "update")"
}

# Function to confirm uninstallation
# This provides a safety check before proceeding with uninstallation
confirm_uninstall() {
    while true; do
        printf "${RED}$(get_message "confirm_uninstall")${NC}\n"
        printf "$(get_message "confirm_prompt") "
        read -n 1 -r confirm
        echo  # New line after input
        if [[ "$confirm" =~ ^[yYoO]$ ]]; then
            break
        elif [[ "$confirm" =~ ^[nN]$ ]]; then
            printf "${YELLOW}$(get_message "uninstall_cancelled")${NC}\n"
            exit 0
        else
            echo "Invalid input. Please enter Y/y/O/o for Yes, or N/n for No."
        fi
    done
}

## INSTALLATION FUNCTIONS

# Function to install dependencies
# This installs necessary software that doesn't require special package repositories
install_dependencies() {
    {
        apt-get install -y sudo wget gnupg2 software-properties-common apt-transport-https curl
    } > /dev/null 2>&1 &
    spinner "$(get_message "dependencies_install")"
    
    # Verify installation
    if ! command -v wget &> /dev/null || ! command -v gpg &> /dev/null || ! command -v curl &> /dev/null || ! dpkg -s software-properties-common &> /dev/null || ! dpkg -s apt-transport-https &> /dev/null
    then
        printf "${RED}Error:${NC} Dependencies installation failed.\n"
        printf "Attempting reinstallation...\n"
        apt-get install -y wget gnupg software-properties-common apt-transport-https curl
        if ! command -v wget &> /dev/null || ! command -v gpg &> /dev/null || ! command -v curl &> /dev/null || ! dpkg -s software-properties-common &> /dev/null || ! dpkg -s apt-transport-https &> /dev/null
        then
            printf "${RED}Error:${NC} Reinstallation failed. Please check your internet connection and try again.\n"
            exit 1
        fi
    fi
}

# Function to install firewall
# This sets up UFW and fail2ban for improved server security
install_firewall() {
    local ssh_port="$1"
    {
        # Check if UFW is already installed
        if ! command -v ufw &> /dev/null; then
            apt install ufw -y
        fi

        # Check if fail2ban is already installed
        if ! command -v fail2ban-client &> /dev/null; then
            apt install fail2ban -y
        fi

        # Configure UFW
        ufw allow "$ssh_port"/tcp
        ufw default allow outgoing
        ufw default deny incoming
        ufw -f enable
    } > /dev/null 2>&1 &
    spinner "$(get_message "firewall_install")"
    
    # Verify installation
    if ! command -v ufw &> /dev/null || ! command -v fail2ban-client &> /dev/null
    then
        printf "${RED}Error:${NC} Firewall installation failed.\n"
        printf "Attempting reinstallation...\n"
        {
            apt install ufw fail2ban -y
            ufw allow "$ssh_port"/tcp
            ufw default allow outgoing
            ufw default deny incoming
            ufw -f enable
        } > /dev/null 2>&1 &
        spinner "$(get_message "firewall_reinstall")"
        
        if ! command -v ufw &> /dev/null || ! command -v fail2ban-client &> /dev/null
        then
            printf "${RED}Error:${NC} Reinstallation failed. Please check your internet connection and try again.\n"
            exit 1
        fi
    fi
}

# Function to install Dotnet
# This installs the .NET SDK and runtime required for the server
install_dotnet() {
    {
        # Check if dotnet is already installed
        if ! command -v dotnet &> /dev/null; then
            # Try to get the package for the current distribution
            PACKAGE_URL="https://packages.microsoft.com/config/$DISTRO/$VERSION/packages-microsoft-prod.deb"
            if ! wget -q --method=HEAD $PACKAGE_URL; then
                # If the package doesn't exist, fall back to Debian 10
                PACKAGE_URL="https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb"
            fi

            # Download and install Microsoft keys and repository
            if [ ! -f /etc/apt/trusted.gpg.d/microsoft.asc.gpg ] || [ ! -f /etc/apt/sources.list.d/microsoft-prod.list ]; then
                wget -q https://packages.microsoft.com/keys/microsoft.asc -O microsoft.asc
                cat microsoft.asc | gpg --dearmor -o microsoft.asc.gpg

                if [ "$VERSION_ID" = "12" ]; then
                    # For Debian 12
                    wget -q https://packages.microsoft.com/config/$ID/$VERSION_ID/prod.list -O microsoft-prod.list
                    mv microsoft-prod.list /etc/apt/sources.list.d/microsoft-prod.list
                    SIGNED_BY_PATH=$(grep -oP "(?<=signed-by=).*(?=\])" /etc/apt/sources.list.d/microsoft-prod.list)
                    mv microsoft.asc.gpg "$SIGNED_BY_PATH"
                else
                    # For other versions
                    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
                    wget -q https://packages.microsoft.com/config/$ID/$VERSION_ID/prod.list -O /etc/apt/sources.list.d/microsoft-prod.list
                    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
                    chown root:root /etc/apt/sources.list.d/microsoft-prod.list
                fi

                rm -f microsoft.asc
            fi

            # Update packages
            apt-get update

            # Install .NET based on Debian version
            if [ "$VERSION_ID" = "12" ] || [ "$VERSION_ID" = "11" ]; then
                if ! dpkg -s aspnetcore-runtime-8.0 &> /dev/null; then
                    apt-get install -y aspnetcore-runtime-8.0
                fi
            elif [ "$VERSION_ID" = "10" ]; then
                if ! dpkg -s aspnetcore-runtime-7.0 &> /dev/null; then
                    apt-get install -y aspnetcore-runtime-7.0
                fi
            else
                printf "${RED}Error:${NC} Unsupported Debian version.\n"
                exit 1
            fi

            # Clean apt cache
            apt-get clean
            apt-get autoremove -y
        fi
    } > /dev/null 2>&1 &
    spinner "$(get_message "dotnet_install")"
    
    # Verify installation
    if ! command -v dotnet &> /dev/null
    then
        printf "${RED}Error:${NC} Dotnet installation failed.\n"
        printf "Attempting reinstallation...\n"
        if [ "$VERSION_ID" = "12" ]; then
            apt-get install -y aspnetcore-runtime-8.0
        elif [ "$VERSION_ID" = "11" ]; then
            apt-get install -y aspnetcore-runtime-8.0
        elif [ "$VERSION_ID" = "10" ]; then
            apt-get install -y aspnetcore-runtime-7.0
        else
            printf "${RED}Error:${NC} Unsupported Debian version.\n"
            exit 1
        fi
        if ! command -v dotnet &> /dev/null
        then
            printf "${RED}Error:${NC} Reinstallation failed. Please check your internet connection and try again.\n"
            exit 1
        fi
    fi
}

# Function to enable 32-bit packages
# This is necessary for running 32-bit applications on 64-bit systems
enable_32bit_packages() {
    {
        if ! dpkg --print-foreign-architectures | grep -q i386; then
            dpkg --add-architecture i386
            apt-get update -y
        fi
    } > /dev/null 2>&1 &
    spinner "$(get_message "bit")"
    
    # Verify installation
    if ! dpkg --print-foreign-architectures | grep -q i386; then
        printf "${RED}Error:${NC} 32-bit package activation failed.\n"
        printf "Attempting reactivation...\n"
        dpkg --add-architecture i386
        apt-get update -y
        if ! dpkg --print-foreign-architectures | grep -q i386; then
            printf "${RED}Error:${NC} Reactivation failed. Please check your system and try again.\n"
            exit 1
        fi
    fi
}

# Function to install Wine
# This installs Wine, which is necessary for running Windows applications on Linux
install_wine() {
    {
        # Add Wine repository key if not already added
        if [ ! -f /etc/apt/keyrings/winehq-archive.key ]; then
            sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
        fi

        # Add Wine repository sources based on Debian version
        SOURCES_FILE="/etc/apt/sources.list.d/winehq.sources"
        if [ ! -f "$SOURCES_FILE" ]; then
            if [ "$VERSION" = "12" ]; then
                SOURCES_URL="https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources"
            elif [ "$VERSION" = "11" ]; then
                SOURCES_URL="https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources"
            elif [ "$VERSION" = "10" ]; then
                SOURCES_URL="https://dl.winehq.org/wine-builds/debian/dists/buster/winehq-buster.sources"
            else
                echo "Unsupported Debian version. Defaulting to Bookworm sources."
                SOURCES_URL="https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources"
            fi
            sudo wget -O "$SOURCES_FILE" "$SOURCES_URL"
        fi
        # Update package list and install Wine if not already installed
        if ! dpkg -l | grep -q winehq-stable; then
            apt update -y
            apt install --install-recommends winehq-stable -y
        fi

        # Add Wine environment variables if not already added
        if ! grep -q "WINEPREFIX" ~/.bashrc; then
            echo 'export WINEPREFIX=~/.wine' >> ~/.bashrc
        fi
        if ! grep -q "WINEDEBUG" ~/.bashrc; then
            echo 'export WINEDEBUG=-all' >> ~/.bashrc
        fi
        if ! grep -q "WINEARCH" ~/.bashrc; then
            echo 'export WINEARCH=win64' >> ~/.bashrc
        fi
        if ! grep -q "WINEESYNC" ~/.bashrc; then
            echo 'export WINEESYNC=1' >> ~/.bashrc
        fi
        if ! grep -q "WINEFSYNC" ~/.bashrc; then
            echo 'export WINEFSYNC=1' >> ~/.bashrc
        fi
        if ! grep -q "WINEDLLOVERRIDES" ~/.bashrc; then
            echo 'export WINEDLLOVERRIDES="mscoree,mshtml="' >> ~/.bashrc
        fi
        
        # Apply changes to current session
        source ~/.bashrc
        
        # Run Wine configuration if not already configured
        if [ ! -d "$WINEPREFIX" ]; then
            winecfg
        fi
    } > /dev/null 2>&1 &
    spinner "$(get_message "wine")"
    
    # Verify installation
    if ! command -v wine &> /dev/null
    then
        printf "${RED}Error: Wine installation failed.${NC}\n"
        printf "Attempting reinstallation...\n"
        apt install --install-recommends winehq-stable -y
        if ! command -v wine &> /dev/null
        then
            printf "${RED}Error: Reinstallation failed. Please check your internet connection and try again.${NC}\n"
            exit 1
        fi
    fi
}

# Function to install game binaries
# This sets up the necessary files and directories for the Plutonium T6 server
install_game_binaries() {
    {
        # Create necessary directories if they don't exist
        mkdir -p "$WORKDIR/Server/Multiplayer/main" \
                 "$WORKDIR/Server/Multiplayer/t6r/data/gamesettings" \
                 "$WORKDIR/Server/Zombie/main" \
                 "$WORKDIR/Server/Zombie/t6r/data/gamesettings"

        # Clone T6ServerConfigs repository if not already present
        if [ ! -d "/tmp/T6ServerConfigs" ]; then
            git clone https://github.com/xerxes-at/T6ServerConfigs.git /tmp/T6ServerConfigs
        fi

        # Move default gamesettings files for Zombie and Multiplayer modes
        if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)" ]; then
            # For Zombie mode
            if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/ZM" ]; then
                mkdir -p "$WORKDIR/Server/Zombie/t6r/data/gamesettings/default"
                rsync -a --delete "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/ZM/" "$WORKDIR/Server/Zombie/t6r/data/gamesettings/default/"
            fi

            # For Multiplayer mode
            if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/MP" ]; then
                mkdir -p "$WORKDIR/Server/Multiplayer/t6r/data/gamesettings/default"
                rsync -a --delete "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/MP/" "$WORKDIR/Server/Multiplayer/t6r/data/gamesettings/default/"
            fi
        fi

        # Copy files to their respective locations
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated.cfg" "$WORKDIR/Server/Multiplayer/main/"
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/restricted.cfg" "$WORKDIR/Server/Multiplayer/t6r/data/"
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated_zm.cfg" "$WORKDIR/Server/Zombie/main/"
        
        # Copy MP recipes to Multiplayer t6r/data directory
        if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/recipes/mp" ]; then
            mkdir -p "$WORKDIR/Server/Multiplayer/t6r/data/recipes"
            rsync -a --delete "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/recipes/mp/" "$WORKDIR/Server/Multiplayer/t6r/data/recipes/"
        fi

        # Copy gamesettings files to their respective locations
        for file in /tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/*; do
            if [[ $(basename "$file") == zm_* ]]; then
                rsync -a "$file" "$WORKDIR/Server/Zombie/t6r/data/gamesettings/"
            else
                rsync -a "$file" "$WORKDIR/Server/Multiplayer/t6r/data/gamesettings/"
            fi
        done

        # Clean up
        rm -rf /tmp/T6ServerConfigs
        
        # Create symbolic links if they don't exist
        ln -sfn "$WORKDIR/Ressources/.sources/binkw32.dll" "$WORKDIR/Server/Zombie/binkw32.dll"
        ln -sfn "$WORKDIR/Ressources/.sources/codlogo.bmp" "$WORKDIR/Server/Zombie/codlogo.bmp"
        ln -sfn "$WORKDIR/Ressources/.sources/binkw32.dll" "$WORKDIR/Server/Multiplayer/binkw32.dll"
        ln -sfn "$WORKDIR/Ressources/.sources/codlogo.bmp" "$WORKDIR/Server/Multiplayer/codlogo.bmp"
        ln -sfn "$WORKDIR/Ressources/.sources/zone" "$WORKDIR/Server/Zombie/zone"
        ln -sfn "$WORKDIR/Ressources/.sources/zone" "$WORKDIR/Server/Multiplayer/zone"

        # Download and extract plutonium-updater if not already present
        if [ ! -f "$WORKDIR/Plutonium/plutonium-updater" ]; then
            cd "$WORKDIR/Plutonium/" || exit
            wget -O plutonium-updater.tar.gz https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
            tar xfv plutonium-updater.tar.gz
            rm plutonium-updater.tar.gz
            chmod +x plutonium-updater
        fi

        # Make T6Server.sh executable
        chmod +x "$WORKDIR/Plutonium/T6Server.sh"
    } > /dev/null 2>&1 &
    spinner "$(get_message "binary")"
    
    # Verify installation
}

## UNINSTALLATION FUNCTIONS

# Function to uninstall game binaries
uninstall_game_binaries() {
    if [ -d "$WORKDIR" ]; then
        {
            rm -rf "$WORKDIR"
        } > /dev/null 2>&1 &
        spinner "$(get_message "uninstall_binary")"
    else
        echo "$(get_message "workdir_not_found")"
    fi
}

uninstall_dotnet() {
    {
        # Check if .NET packages are installed before attempting to remove
        if dpkg -l | grep -qE "aspnetcore-runtime-8.0|aspnetcore-runtime-7.0"; then
            if [ "$VERSION_ID" = "12" ] || [ "$VERSION_ID" = "11" ]; then
                apt-get remove -y aspnetcore-runtime-8.0
            elif [ "$VERSION_ID" = "10" ]; then
                apt-get remove -y aspnetcore-runtime-7.0
            fi
        fi

        # Remove Microsoft repository list file if it exists
        if [ -f /etc/apt/sources.list.d/microsoft-prod.list ]; then
            rm /etc/apt/sources.list.d/microsoft-prod.list
        fi

        # Update package list only if changes were made
        if [ $? -eq 0 ]; then
            apt-get update
        fi
    } > /dev/null 2>&1 &
    spinner "$(get_message "uninstall_dotnet")"
}

uninstall_wine() {
    {
        # Check if Wine is installed before attempting to remove
        if dpkg -l | grep -q winehq-stable; then
            apt-get remove --purge winehq-stable -y
        fi

        # Remove Wine repository based on Debian version if it exists
        if [ -f /etc/apt/sources.list.d/wine.list ]; then
            rm /etc/apt/sources.list.d/wine.list
        fi

        # Remove Wine repository key if it exists
        if [ -f /etc/apt/trusted.gpg.d/winehq.asc ]; then
            rm /etc/apt/trusted.gpg.d/winehq.asc
        fi

        # Remove Wine environment variables from .bashrc
        sed -i '/WINEPREFIX/d' ~/.bashrc
        sed -i '/WINEDEBUG/d' ~/.bashrc
        sed -i '/WINEARCH/d' ~/.bashrc
        sed -i '/WINEESYNC/d' ~/.bashrc
        sed -i '/WINEFSYNC/d' ~/.bashrc
        sed -i '/WINEDLLOVERRIDES/d' ~/.bashrc

        # Remove Wine prefix directory if it exists
        if [ -d "$HOME/.wine" ]; then
            rm -rf "$HOME/.wine"
        fi

        # Update package list
        apt-get update
    } > /dev/null 2>&1 &
    spinner "$(get_message "uninstall_wine")"
}

# Remove Firewall
remove_firewall() {
    {
        # Check if ufw is installed before attempting to disable
        if command -v ufw >/dev/null 2>&1; then
            ufw disable
        fi

        # Check if ufw or fail2ban are installed before attempting to remove
        if dpkg -l | grep -qE "ufw|fail2ban"; then
            apt-get remove --purge ufw fail2ban -y
        fi

        # Clean up any leftover configuration files
        apt-get autoremove -y
        apt-get autoclean
    } > /dev/null 2>&1 &
    spinner "$(get_message "remove_firewall")"
}

ask_installations() {
    # Ask about firewall installation
    if [[ -z "$firewall" ]]; then
        while true; do
            printf "\n${YELLOW}$(get_message "firewall")${NC}\n"
            printf ">>> "
            read -n 1 -r firewall_input
            echo  # Pour aller à la ligne après l'entrée
            case $firewall_input in
                [yYoO])
                    firewall="yes"
                    break
                    ;;
                [nN])
                    firewall="no"
                    break
                    ;;
                *)
                    echo "Invalid input. Please enter Y/y/O/o for Yes, or N/n for No."
                    ;;
            esac
        done
    fi

    # Ask for SSH port if firewall is to be installed
    if [[ "$firewall" == "yes" ]]; then
        while true; do
            printf "\n${YELLOW}$(get_message "ssh_port")${NC}\n"
            printf "${LIGHT_RED}$(get_message "ssh_port_enter")${NC}\n"
            printf ">>> "
            read -n 5 ssh_port_input
            echo  # Pour aller à la ligne après l'entrée
            if [[ "$ssh_port_input" =~ ^[0-9]+$ ]] && [ "$ssh_port_input" -ge 1 ] && [ "$ssh_port_input" -le 65535 ]; then
                ssh_port=$ssh_port_input
                break
            else
                echo "Invalid input. Please enter a number between 1 and 65535."
            fi
        done
    fi

    # Ask about Dotnet installation
    if [[ -z "$dotnet" ]]; then
        while true; do
            printf "\n${YELLOW}$(get_message "dotnet")${NC}\n"
            printf ">>> "
            read -n 1 -r dotnet_input
            echo  # Pour aller à la ligne après l'entrée
            case $dotnet_input in
                [yYoO])
                    dotnet="yes"
                    break
                    ;;
                [nN])
                    dotnet="no"
                    break
                    ;;
                *)
                    echo "Invalid input. Please enter Y/y/O/o for Yes, or N/n for No."
                    ;;
            esac
        done
    fi
}

finish_installation() {
    printf "\n${GREEN}$(get_message "finish")${NC}\n"
    printf "\n$(get_message "quit")"
    read -r
    echo
    exit 0
}
