#!/bin/bash

# Configuration
SERVER_IP="127.0.0.1"  # Replace with your server IP
RCON_PORT="28960"      # Replace with your RCON port
RCON_PASSWORD="your_password"  # Replace with your RCON password

# Function to send RCON commands
send_rcon_command() {
    echo "$(echo -e "\xff\xff\xff\xffrcon ${RCON_PASSWORD} $1" | nc -u -w 1 ${SERVER_IP} ${RCON_PORT})"
}

# Get the number of players
get_player_count() {
    local response=$(send_rcon_command "status")
    # Extract player count (adjust according to exact response format)
    echo "$response" | grep -oP '\d+(?= players)' || echo "0"
}

# Check server uptime
get_server_uptime() {
    local pid=$(pgrep -f "t6_server")  # Adjust according to exact process name
    if [ -n "$pid" ]; then
        echo $(($(date +%s) - $(date +%s -r "/proc/$pid")))
    else
        echo "0"
    fi
}

# Main program
main() {
    # Get player count
    PLAYER_COUNT=$(get_player_count)
    
    # Get uptime in seconds
    UPTIME=$(get_server_uptime)
    
    # 2 hours in seconds
    TWO_HOURS=$((2 * 60 * 60))
    
    echo "Connected players: $PLAYER_COUNT"
    echo "Server uptime: $UPTIME seconds"
    
    # Check restart conditions
    if [ "$PLAYER_COUNT" -eq 0 ] && [ "$UPTIME" -gt "$TWO_HOURS" ]; then
        echo "Restart conditions met. Restarting server..."
        
        # Graceful server shutdown via RCON
        send_rcon_command "quit"
        
        # Wait for server to stop
        sleep 10
        
        # Restart server (adjust according to your configuration)
        /path/to/your/startup/script/server_start.sh
        
        echo "Server restarted successfully."
    else
        echo "Restart conditions not met. Server continues running."
    fi
}

# Execute main program
main