#!/bin/bash

# File: installGameBinaries.sh
# Description: Script to install game binaries for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--install" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to install game binaries
installGameBinaries () {
    {
        # Create directory structure for Plutonium
        mkdir -p "$WORKDIR/Plutonium/storage/t6/"{gamesettings,playlists,stats}

        # Create directory structure for Multiplayer
        mkdir -p "$WORKDIR/Server/Multiplayer/main/"{configs,scripts,mods}

        # Create directory structure for Zombie
        mkdir -p "$WORKDIR/Server/Zombie/main/"{configs,scripts,mods}

        # Create logs directories
        mkdir -p "$WORKDIR/logs/"{mp,zm}

        # Clone T6ServerConfigs repository
        rm -rf /tmp/T6ServerConfigs
        checkAndInstallCommand "git" "git"
        git clone https://github.com/xerxes-at/T6ServerConfigs.git /tmp/T6ServerConfigs

        # Install rsync if not present
        checkAndInstallCommand "rsync" "rsync"

        # Handle gamesettings defaults
        if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)" ]; then
            mkdir -p "$WORKDIR/Plutonium/storage/t6/gamesettings/default"
            rsync -a --delete "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/MP/" "$WORKDIR/Plutonium/storage/t6/gamesettings/default"
        fi

        # Copy configuration files
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated.cfg" "$WORKDIR/Server/Multiplayer/main"
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/restricted.cfg" "$WORKDIR/Server/Multiplayer/main/config"
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated_zm.cfg" "$WORKDIR/Server/Zombie/main"

        # Handle MP recipes
        if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/recipes/mp" ]; then
            mkdir -p "$WORKDIR/Plutonium/storage/t6/recipes"
            rsync -a --delete "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/recipes/mp/" "$WORKDIR/Plutonium/storage/t6/data/recipes/"
        fi

        # Copy gamesettings files
        for file in /tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/*; do
            rsync -a "$file" "$WORKDIR/Plutonium/storage/t6/gamesettings/"
        done

        # Clean up T6ServerConfigs
        rm -rf /tmp/T6ServerConfigs

        # Download required files from torrent
        checkAndInstallCommand "aria2c" "aria2"
        # Clean up any existing pluto_t6_full_game files/directories in /tmp
        rm -rf /tmp/pluto_t6_full_game*
        aria2c --dir=/tmp --seed-time=0 --console-log-level=error --summary-interval=1 --select-file=$(aria2c -S "$WORKDIR/Resources/sources/pluto_t6_full_game.torrent" | grep -E "zone/|binkw32.dll" | cut -d'|' -f1 | tr '\n' ',') "$WORKDIR/Resources/sources/pluto_t6_full_game.torrent"

        # Move downloaded files to Resources
        mkdir -p "$WORKDIR/Resources/binaries"
        rsync -a "/tmp/pluto_t6_full_game/zone" "$WORKDIR/Resources/binaries/"
        rsync -a "/tmp/pluto_t6_full_game/binkw32.dll" "$WORKDIR/Resources/binaries/binkw32.dll"

        # Clean up downloaded files
        rm -rf /tmp/pluto_t6_full_game

        # Create symbolic links
        for dir in Zombie Multiplayer; do
            ln -sfn "$WORKDIR/Resources/binaries/zone" "$WORKDIR/Server/$dir/zone"
            ln -sfn "$WORKDIR/Resources/binaries/binkw32.dll" "$WORKDIR/Server/$dir/binkw32.dll"
        done

        # Setup Plutonium updater
        if [ ! -f "$WORKDIR/Plutonium/plutonium-updater" ]; then
            cd "$WORKDIR/Plutonium/" || exit
            checkAndInstallCommand "wget" "wget"
            wget -q -O plutonium-updater.tar.gz https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
            checkAndInstallCommand "tar" "tar"
            tar xf plutonium-updater.tar.gz plutonium-updater
            rm plutonium-updater.tar.gz
            chmod +x plutonium-updater
        fi

        # Make T6Server.sh executable
        chmod +x "$WORKDIR/Plutonium/T6Server.sh"
    } > /dev/null 2>&1 &
    showProgressIndicator "$(getMessage "binary")"
    
    # Verify installation
    if [ ! -f "$WORKDIR/Plutonium/plutonium-updater" ]; then
        printf "${COLORS[RED]}Error:${COLORS[RESET]} Game binaries installation failed.\n"
        printf "You can try running the installation script separately by executing:\n"
        printf "cd .config/binaries && ./installGameBinaries.sh\n"
    fi
}

# Run the installation function if --install is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--install" ]; then
    installGameBinaries
else
    echo "Usage: $0 [--install] | [--import]"
    echo "This script installs game binaries. Use --install or no argument to proceed with installation."
fi
