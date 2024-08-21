#!/bin/bash

# Configuration variables
readonly SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
readonly SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
readonly SERVER_NAME="SERVER_NAME"
readonly GAME_PATH="/opt/T6Server/Server/Multiplayer"
readonly SERVER_KEY="YOURKEY"
readonly CONFIG_FILE="dedicated.cfg"
readonly SERVER_PORT=4976
readonly GAME_MODE="t6mp"
readonly INSTALL_DIR="/opt/T6Server/Plutonium"

# Update server files
update_server() {
    ./plutonium-updater -d "$INSTALL_DIR"
}

# Start server
start_server() {
    local timestamp
    printf -v timestamp '%(%F_%H:%M:%S)T' -1
    
    echo -e '\033]2;Plutonium - '"$SERVER_NAME"' - Server restart\007'
    echo "Visit plutonium.pw | Join the Discord (plutonium) for NEWS and Updates!"
    echo "Server $SERVER_NAME will load $CONFIG_FILE and listen on port $SERVER_PORT UDP!"
    echo "To shut down the server close this window first!"
    echo "$timestamp $SERVER_NAME server started."

    while true; do
        wine .\\bin\\plutonium-bootstrapper-win32.exe "$GAME_MODE" "$GAME_PATH" -dedicated +start_map_rotate +set key "$SERVER_KEY" +set net_port "$SERVER_PORT" +set sv_config "$CONFIG_FILE" 2>/dev/null
        
        printf -v timestamp '%(%F_%H:%M:%S)T' -1
        echo "$timestamp WARNING: $SERVER_NAME server closed or dropped... server restarting."
        sleep 1
    done
}

# Main execution
update_server
start_server