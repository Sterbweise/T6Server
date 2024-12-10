#!/bin/bash
# Plutonium Multi-Server Management Script
# Comprehensive server management for Call of Duty: Black Ops II

# Color codes for enhanced readability
declare -A COLORS=(
    [reset]='\033[0m'
    [red]='\033[0;31m'
    [green]='\033[0;32m'
    [yellow]='\033[0;33m'
    [blue]='\033[0;34m'
)

# Display detailed help information
display_help() {
    echo -e "${COLORS[blue]}Plutonium Server Management Script${COLORS[reset]}"
    echo ""
    echo "${COLORS[green]}USAGE:${COLORS[reset]}"
    echo "  $0 [OPTION]"
    echo ""
    echo "${COLORS[green]}OPTIONS:${COLORS[reset]}"
    echo "  ${COLORS[yellow]}start${COLORS[reset]}               Start all configured servers"
    echo "  ${COLORS[yellow]}monitor${COLORS[reset]}             Continuously monitor server resources"
    echo "  ${COLORS[yellow]}--help${COLORS[reset]}              Display this detailed help information"
    echo "  ${COLORS[yellow]}--install-dependencies${COLORS[reset]}  Install all required dependencies"
    echo ""
    echo "${COLORS[green]}CONFIGURATION:${COLORS[reset]}"
    echo "  - Configuration file: server_config.json"
    echo "  - Supports multiple server configurations"
    echo "  - Monitors server resources"
    echo "  - Automatic server restart on failure"
    echo ""
    echo "${COLORS[green]}SERVER CONFIGURATION OPTIONS:${COLORS[reset]}"
    echo "  - Server ID"
    echo "  - Server Name"
    echo "  - Port"
    echo "  - Game Mode (t6mp, t6zm)"
    echo "  - Mods"
    echo "  - Authentication Key"
    echo "  - Custom Configuration"
    echo "  - Additional Launch Parameters"
    echo "  - Resource Limits"
    echo ""
    echo "${COLORS[green]}MONITORING FEATURES:${COLORS[reset]}"
    echo "  - CPU Usage Monitoring"
    echo "  - Memory Usage Monitoring"
    echo "  - Automatic Server Restart"
    echo "  - Configurable Update Interval"
    echo "  - Log Rotation"
    echo ""
    echo "${COLORS[green]}EXAMPLE USAGE:${COLORS[reset]}"
    echo "  ${COLORS[yellow]}./start_server_and_monitoring.sh start${COLORS[reset]}       # Start all servers"
    echo "  ${COLORS[yellow]}./start_server_and_monitoring.sh monitor${COLORS[reset]}     # Monitor servers"
    echo "  ${COLORS[yellow]}./start_server_and_monitoring.sh --help${COLORS[reset]}      # Show help"
    echo ""
    echo "${COLORS[green]}DEPENDENCIES:${COLORS[reset]}"
    echo "  - wine"
    echo "  - jq"
    echo "  - ps"
    echo "  - awk"
    echo ""
    echo "${COLORS[red]}WARNING:${COLORS[reset]} Ensure you have replaced 'YOURKEY' in server_config.json"
}

# Install dependencies for different Linux distributions
install_dependencies() {
    echo "${COLORS[blue]}Detecting Linux Distribution...${COLORS[reset]}"
    
    # Detect the distribution
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo "${COLORS[red]}Unable to detect distribution. Please install dependencies manually.${COLORS[reset]}"
        exit 1
    fi

    echo "${COLORS[green]}Installing dependencies for $DISTRO${COLORS[reset]}"

    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo dpkg --add-architecture i386
            wget -nc https://dl.winehq.org/wine-builds/winehq.key
            sudo apt-key add winehq.key
            sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
            sudo apt update
            sudo apt install -y --install-recommends winehq-stable jq
            ;;
        fedora)
            sudo dnf install -y wine jq
            ;;
        centos|rhel)
            sudo yum install -y epel-release
            sudo yum install -y wine jq
            ;;
        arch)
            sudo pacman -S --noconfirm wine jq
            ;;
        *)
            echo "${COLORS[red]}Unsupported distribution. Please install dependencies manually.${COLORS[reset]}"
            exit 1
            ;;
    esac

    # Post-installation Wine configuration
    echo "${COLORS[blue]}Configuring Wine...${COLORS[reset]}"
    wine wineboot
    
    # Optional: Install recommended Windows dependencies
    echo "${COLORS[blue]}Installing recommended Windows dependencies...${COLORS[reset]}"
    winetricks vcrun2019 dotnet48

    echo "${COLORS[green]}Dependencies installed successfully!${COLORS[reset]}"
}

# Check system dependencies
check_dependencies() {
    local dependencies=("wine" "jq" "ps" "awk")
    local missing_deps=()

    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${COLORS[red]}Missing dependencies:${COLORS[reset]} ${missing_deps[*]}"
        return 1
    fi
}

# Build server launch parameters dynamically
build_server_params() {
    local server_config="$1"
    local params=""

    # Core server settings
    params+="+set dedicated 1 +set net_port $(echo "$server_config" | jq -r '.port')"
    params+=" +set sv_hostname \"$(echo "$server_config" | jq -r '.name')\""
    params+=" +set gamemode $(echo "$server_config" | jq -r '.mode')"

    # Additional parameters from JSON
    local additional_params=$(echo "$server_config" | jq -r '.additional_params')
    
    # Add each additional parameter
    for param in $(echo "$additional_params" | jq -r 'to_entries[] | "\(.key) \(.value)"'); do
        params+=" +set $param"
    done

    # Configuration and mods
    local config=$(echo "$server_config" | jq -r '.config')
    local mods=$(echo "$server_config" | jq -r '.mods')
    
    if [ -n "$config" ] && [ "$config" != "null" ]; then
        params+=" +exec $config"
    fi

    if [ -n "$mods" ] && [ "$mods" != "null" ]; then
        params+=" +set fs_game $mods"
    fi

    # Server authentication key
    local key=$(echo "$server_config" | jq -r '.key')
    if [ -n "$key" ] && [ "$key" != "null" ]; then
        params+=" +set sv_authkey $key"
    fi

    echo "$params"
}

# Start a specific server
start_server() {
    local server_config="$1"
    local config_file="$2"
    
    # Get executable and installation directory from general config
    local executable=$(jq -r '.general_config.executable_path' "$config_file")
    local install_dir=$(jq -r '.general_config.install_dir' "$config_file")
    
    local server_id=$(echo "$server_config" | jq -r '.id')
    local server_params=$(build_server_params "$server_config")
    
    # Change to installation directory
    cd "$install_dir"
    
    # Launch server
    echo -e "${COLORS[green]}Starting server $server_id${COLORS[reset]}"
    wine "$executable" $server_params &
}

# Monitor server resources and status
monitor_servers() {
    local config_file="$1"
    local servers=$(jq -c '.servers[]' "$config_file")
    local monitoring_config=$(jq -c '.monitoring_config' "$config_file")

    for server in $servers; do
        local server_id=$(echo "$server" | jq -r '.id')
        local pid=$(pgrep -f "$server_id")

        if [ -z "$pid" ]; then
            echo -e "${COLORS[yellow]}Server $server_id is not running. Restarting...${COLORS[reset]}"
            start_server "$server" "$config_file"
        else
            # Resource monitoring
            local max_cpu=$(echo "$server" | jq -r '.resource_limits.max_cpu_percent')
            local max_memory=$(echo "$server" | jq -r '.resource_limits.max_memory_mb')

            local current_cpu=$(ps -p "$pid" -o %cpu | tail -1)
            local current_memory=$(ps -p "$pid" -o rss= | awk '{print $1 / 1024}')

            if (( $(echo "$current_cpu > $max_cpu" | bc -l) )) || 
               (( $(echo "$current_memory > $max_memory" | bc -l) )); then
                echo -e "${COLORS[red]}Server $server_id exceeds resource limits. Restarting...${COLORS[reset]}"
                kill "$pid"
                start_server "$server" "$config_file"
            fi
        fi
    done

    # Get update interval from monitoring config
    local update_interval=$(echo "$monitoring_config" | jq -r '.update_interval')
    sleep "$update_interval"
}

# Logging function
log_event() {
    local config_file="$1"
    local message="$2"
    local log_dir=$(jq -r '.monitoring_config.log_directory' "$config_file")
    local max_log_files=$(jq -r '.monitoring_config.max_log_files' "$config_file")

    # Ensure log directory exists
    mkdir -p "$log_dir"

    # Rotate logs if necessary
    local log_files=$(find "$log_dir" -type f -name "server_log_*.txt" | sort)
    local log_count=$(echo "$log_files" | wc -l)
    
    if [ "$log_count" -ge "$max_log_files" ]; then
        echo "$log_files" | head -n $((log_count - max_log_files + 1)) | xargs rm
    fi

    # Write log
    local timestamp=$(date "+%Y%m%d_%H%M%S")
    echo "[${timestamp}] ${message}" >> "${log_dir}/server_log_${timestamp}.txt"
}

# Main script execution
main() {
    local config_file="./server_config.json"

    case "$1" in
        "--help")
            display_help
            exit 0
            ;;
        "--install-dependencies")
            install_dependencies
            exit 0
            ;;
        "start")
            check_dependencies || exit 1
            jq -c '.servers[]' "$config_file" | while read -r server; do
                start_server "$server" "$config_file"
            done
            ;;
        "monitor")
            check_dependencies || exit 1
            while true; do
                monitor_servers "$config_file"
            done
            ;;
        *)
            echo "Usage: $0 [start|monitor|--help|--install-dependencies]"
            exit 1
            ;;
    esac
}

# Execute main script
main "$@"