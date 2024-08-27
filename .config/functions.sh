#!/bin/bash

# functions.sh - Plutonium Call of Duty: Black Ops II Server Functions
# Version: 2.1.0
# Author: Sterbweise
# Last Updated: 21/08/2024

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
        apt update
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

# Function to install firewall
# This sets up UFW and fail2ban for improved server security
install_firewall() {
    local ssh_port="$1"
    {
        apt install ufw fail2ban -y
        ufw allow "$ssh_port"/tcp
        ufw default allow outgoing
        ufw default deny incoming
        ufw -f enable
    } > /dev/null 2>&1 &
    spinner "$(get_message "firewall_install")"
    
    # Verify installation
    if ! command -v ufw &> /dev/null || ! command -v fail2ban-client &> /dev/null
    then
        printf "${RED}Error: Firewall installation failed.${NC}\n"
        printf "Attempting reinstallation...\n"
        apt install ufw fail2ban -y
        if ! command -v ufw &> /dev/null || ! command -v fail2ban-client &> /dev/null
        then
            printf "${RED}Error: Reinstallation failed. Please check your internet connection and try again.${NC}\n"
            exit 1
        fi
    fi
}

# Function to install Dotnet
# This installs the .NET SDK and runtime required for the server
install_dotnet() {
    {
        # Try to get the package for the current distribution
        PACKAGE_URL="https://packages.microsoft.com/config/$DISTRO/$VERSION/packages-microsoft-prod.deb"
        if ! wget -q --method=HEAD $PACKAGE_URL; then
            # If the package doesn't exist, fall back to Debian 10
            PACKAGE_URL="https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb"
        fi

        wget $PACKAGE_URL -O packages-microsoft-prod.deb
        dpkg -i packages-microsoft-prod.deb
        rm packages-microsoft-prod.deb

        apt-get update
        apt-get install -y dotnet-sdk-3.1 dotnet-sdk-6.0 aspnetcore-runtime-3.1 aspnetcore-runtime-6.0

        # Verify installation
        dotnet --version || echo "Dotnet installation failed"

        # Clean apt cache
        apt-get clean
        apt-get autoremove -y
    } > /dev/null 2>&1 &
    spinner "$(get_message "dotnet_install")"
    
    # Verify installation
    if ! command -v dotnet &> /dev/null
    then
        printf "${RED}Error: Dotnet installation failed.${NC}\n"
        printf "Attempting reinstallation...\n"
        apt-get install -y dotnet-sdk-3.1 dotnet-sdk-6.0 aspnetcore-runtime-3.1 aspnetcore-runtime-6.0
        if ! command -v dotnet &> /dev/null
        then
            printf "${RED}Error: Reinstallation failed. Please check your internet connection and try again.${NC}\n"
            exit 1
        fi
    fi
}

# Function to enable 32-bit packages
# This is necessary for running 32-bit applications on 64-bit systems
enable_32bit_packages() {
    {
        dpkg --add-architecture i386
        apt-get update -y
        apt-get install wget gnupg2 software-properties-common apt-transport-https curl -y
    } > /dev/null 2>&1 &
    spinner "$(get_message "bit")"
    
    # Verify installation
    if ! dpkg --print-foreign-architectures | grep -q i386
    then
        printf "${RED}Error: 32-bit package activation failed.${NC}\n"
        printf "Attempting reactivation...\n"
        dpkg --add-architecture i386
        apt-get update -y
        if ! dpkg --print-foreign-architectures | grep -q i386
        then
            printf "${RED}Error: Reactivation failed. Please check your system and try again.${NC}\n"
            exit 1
        fi
    fi
}

# Function to install Wine
# This installs Wine, which is necessary for running Windows applications on Linux
install_wine() {
    {
        # Add Wine repository key
        wget -nc https://dl.winehq.org/wine-builds/winehq.key
        sudo mv winehq.key /etc/apt/trusted.gpg.d/winehq.asc
        
        # Add Wine repository based on Debian version
        if [ "$VERSION" = "11" ] || [ "$VERSION" = "10" ]; then
            echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" | tee -a /etc/apt/sources.list.d/wine.list > /dev/null
        elif [ "$VERSION" = "12" ]; then
            echo "deb https://dl.winehq.org/wine-builds/debian/ bookworm main" | tee -a /etc/apt/sources.list.d/wine.list > /dev/null
        else
            echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" | tee -a /etc/apt/sources.list.d/wine.list > /dev/null
        fi
        # Update package list and install Wine
        apt update -y
        apt install --install-recommends winehq-stable -y

        # Add Wine environment variables
        echo 'export WINEPREFIX=~/.wine' >> ~/.bashrc
        echo 'export WINEDEBUG=fixme-all' >> ~/.bashrc
        echo 'export WINEARCH=win64' >> ~/.bashrc
        echo 'export DISPLAY=:0' >> ~/.bashrc
        
        # Apply changes to current session
        source ~/.bashrc
        
        # Run Wine configuration
        winecfg
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
        # Download T6ServerConfigs repository
        git clone https://github.com/xerxes-at/T6ServerConfigs.git /tmp/T6ServerConfigs

        # Create necessary directories
        mkdir -p "$WORKDIR/Server/Multiplayer/main" \
                 "$WORKDIR/Server/Multiplayer/t6r/data/gamesettings" \
                 "$WORKDIR/Server/Zombie/main" \
                 "$WORKDIR/Server/Zombie/t6r/data/gamesettings"

        # Move default gamesettings files for Zombie and Multiplayer modes
        if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)" ]; then
            # For Zombie mode
            if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/ZM" ]; then
                mkdir -p "$WORKDIR/Server/Zombie/t6r/data/gamesettings/default"
                cp -r "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/ZM"/* "$WORKDIR/Server/Zombie/gamesettings/default/"
            fi

            # For Multiplayer mode
            if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/MP" ]; then
                mkdir -p "$WORKDIR/Server/Multiplayer/t6r/data/gamesettings/default"
                cp -r "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/MP"/* "$WORKDIR/Server/Multiplayer/gamesettings/default/"
            fi
        fi

        # Copy files to their respective locations
        # Copy dedicated.cfg to Multiplayer main directory
        cp /tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated.cfg "$WORKDIR/Server/Multiplayer/main/"
        cp /tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/restricted.cfg "$WORKDIR/Server/Multiplayer/t6r/data/"
        cp /tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated_zm.cfg "$WORKDIR/Server/Zombie/main/"
        
        # Copy MP recipes to Multiplayer t6r/data directory
        if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/recipes/mp" ]; then
            mkdir -p "$WORKDIR/Server/Multiplayer/t6r/data/recipes"
            cp -r "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/recipes/mp" "$WORKDIR/Server/Multiplayer/t6r/data/recipes/"
        fi
        # Copy gamesettings files to their respective locations
        for file in /tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/*; do
            if [[ $(basename "$file") == zm_* ]]; then
                cp "$file" "$WORKDIR/Server/Zombie/t6r/data/gamesettings/"
            else
                cp "$file" "$WORKDIR/Server/Multiplayer/t6r/data/gamesettings/"
            fi
        done

        # Clean up
        rm -rf /tmp/T6ServerConfigs
        
        # Create symbolic links
        ln -s "$WORKDIR/Ressources/.sources/binkw32.dll" "$WORKDIR/Server/Zombie"
        ln -s "$WORKDIR/Ressources/.sources/codlogo.bmp" "$WORKDIR/Server/Zombie"

        ln -s "$WORKDIR/Ressources/.sources/binkw32.dll" "$WORKDIR/Server/Multiplayer"
        ln -s "$WORKDIR/Ressources/.sources/codlogo.bmp" "$WORKDIR/Server/Multiplayer"

        ln -s "$WORKDIR/Ressources/.sources/zone" "$WORKDIR/Server/Zombie/zone"
        ln -s "$WORKDIR/Ressources/.sources/zone" "$WORKDIR/Server/Multiplayer/zone"

        # Download and extract plutonium-updater
        cd "$WORKDIR/Plutonium/" || exit
        wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
        tar xfv plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
        rm plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
        chmod +x plutonium-updater

        # Make T6Server.sh executable
        chmod +x "$WORKDIR/Plutonium/T6Server.sh"
    } > /dev/null 2>&1 &
    spinner "$(get_message "binary")"
    
    # Verify installation
}

## UNINSTALLATION FUNCTIONS

# Function to uninstall game binaries
uninstall_game_binaries() {
    {
        rm -rf "$WORKDIR"
    } > /dev/null 2>&1 &
    spinner "$(get_message "uninstall_binary")"
}

uninstall_dotnet() {
    {
        apt-get remove -y dotnet-sdk-3.1 dotnet-sdk-6.0 aspnetcore-runtime-3.1 aspnetcore-runtime-6.0
        rm /etc/apt/sources.list.d/microsoft-prod.list
        apt-get update
    } > /dev/null 2>&1 &
    spinner "$(get_message "uninstall_dotnet")"
}

uninstall_wine() {
    {
        apt-get remove --purge winehq-stable -y
        apt-add-repository --remove 'deb https://dl.winehq.org/wine-builds/debian/ buster main'
        apt-get update
    } > /dev/null 2>&1 &
    spinner "$(get_message "uninstall_wine")"
}

# Remove Firewall
remove_firewall() {
    {
        ufw disable
        apt-get remove --purge ufw fail2ban -y
    } > /dev/null 2>&1 &
    spinner "$(get_message "remove_firewall")"
}

ask_installations() {
    # Ask about firewall installation
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

    # Ask for SSH port if firewall is to be installed
    if [[ "$firewall" == "yes" ]]; then
        while true; do
            printf "\n${YELLOW}$(get_message "ssh_port")${NC}\n"
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
}

finish_installation() {
    printf "\n${GREEN}$(get_message "finish")${NC}\n"
    printf "\n$(get_message "quit")"
    read -r
    echo
    exit 0
}
