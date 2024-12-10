# Function to display a showProgressIndicator while a process is running
# This provides visual feedback to the user during long-running operations
showProgressIndicator() {
    local pid=$!
    local message="$1"
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    local start_time=$(date +%s)

    # Set TERM to a default value if not set
    if [[ -z "$TERM" ]]; then
        export TERM=xterm
    fi

    # Check if tput is available
    if command -v tput > /dev/null; then
        tput civis  # Hide cursor
    fi

    while kill -0 $pid 2>/dev/null; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        printf "\r [${spin:i++%${#spin}:1}] ${message} (${elapsed}s)"
        sleep 0.1
    done

    # Check if tput is available
    if command -v tput > /dev/null; then
        tput cnorm  # Show cursor
    fi

    printf "\r [${COLORS[GREEN]}✔${COLORS[RESET]}] ${message} (${elapsed}s)\n"
}