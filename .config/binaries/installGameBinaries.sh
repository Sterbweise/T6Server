#!/bin/bash

# File: game-binaries-install.sh
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
        # Create necessary directories if they don't exist
        mkdir -p "$WORKDIR/Server/Multiplayer/main" \
                 "$WORKDIR/Server/Multiplayer/t6/data/gamesettings" \
                 "$WORKDIR/Server/Zombie/main" \
                 "$WORKDIR/Server/Zombie/t6/data/gamesettings" \
                 "$WORKDIR/Server/Multiplayer/t6/data/stats" \
                 "$WORKDIR/Server/Multiplayer/t6/data/playlists" \
                 "$WORKDIR/Server/Zombie/t6/data/stats" \
                 "$WORKDIR/Server/Zombie/t6/data/playlists"

        # Clone T6ServerConfigs repository, overwriting if it already exists
        rm -rf /tmp/T6ServerConfigs
        git clone https://github.com/xerxes-at/T6ServerConfigs.git /tmp/T6ServerConfigs

        # Move default gamesettings files for Zombie and Multiplayer modes
        if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)" ]; then
            # For Zombie mode
            if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/ZM" ]; then
                mkdir -p "$WORKDIR/Server/Zombie/t6/data/gamesettings/default"
                rsync -a --delete "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/ZM/" "$WORKDIR/Server/Zombie/t6/data/gamesettings/default/"
            fi

            # For Multiplayer mode
            if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/MP" ]; then
                mkdir -p "$WORKDIR/Server/Multiplayer/t6/data/gamesettings/default"
                rsync -a --delete "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/MP/" "$WORKDIR/Server/Multiplayer/t6/data/gamesettings/default/"
            fi
        fi

        # Copy files to their respective locations
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated.cfg" "$WORKDIR/Server/Multiplayer/main/"
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/restricted.cfg" "$WORKDIR/Server/Multiplayer/t6/data/"
        rsync -a "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated_zm.cfg" "$WORKDIR/Server/Zombie/main/"
        
        # Copy MP recipes to Multiplayer t6/data directory
        if [ -d "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/recipes/mp" ]; then
            mkdir -p "$WORKDIR/Server/Multiplayer/t6/data/recipes"
            rsync -a --delete "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/recipes/mp/" "$WORKDIR/Server/Multiplayer/t6/data/recipes/"
        fi

        # Copy gamesettings files to their respective locations
        for file in /tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/*; do
            if [[ $(basename "$file") == zm_* ]]; then
                rsync -a "$file" "$WORKDIR/Server/Zombie/t6/data/gamesettings/"
            else
                rsync -a "$file" "$WORKDIR/Server/Multiplayer/t6/data/gamesettings/"
            fi
        done

        # Clean up
        rm -rf /tmp/T6ServerConfigs

        
        
        # Download required files from torrent
        aria2c --dir=/tmp --seed-time=0 --select-file=$(aria2c -S pluto_t6_full_game.torrent | grep -E "zone/|codlogo.bmp|binkw32.dll" | cut -d'|' -f1 | tr '\n' ',') pluto_t6_full_game.torrent

        # Create the binaries directory if it doesn't exist
        mkdir -p "$WORKDIR/Ressources/binaries"

        mv /tmp/pluto_t6_full_game/zone "$WORKDIR/Ressources/binaries/zone"
        mv /tmp/pluto_t6_full_game/codlogo.bmp "$WORKDIR/Ressources/binaries/codshowLogo.bmp"
        mv /tmp/pluto_t6_full_game/binkw32.dll "$WORKDIR/Ressources/binaries/binkw32.dll"

        rm -rf /tmp/pluto_t6_full_game

        # Create symbolic links to the downloaded files for both Zombie and Multiplayer
        for dir in Zombie Multiplayer; do
            ln -sfn "$WORKDIR/Ressources/zone" "$WORKDIR/Server/$dir/zone"
            # Download and link other required files
            ln -sfn "$WORKDIR/Ressources/binkw32.dll" "$WORKDIR/Server/$dir/binkw32.dll"
            ln -sfn "$WORKDIR/Ressources/codshowLogo.bmp" "$WORKDIR/Server/$dir/codshowLogo.bmp"
        done

        # Download and extract plutonium-updater if not already present
        if [ ! -f "$WORKDIR/Plutonium/plutonium-updater" ]; then
            cd "$WORKDIR/Plutonium/" || exit
            wget -q -O plutonium-updater.tar.gz https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
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
        printf "${RED}Error:${NC} Game binaries installation failed.\n"
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
