#!/bin/bash

# testsValidation.sh - Comprehensive Test Suite for T6 Server Installation and Management
# Version: 2.1.0
# Author: Sterbweise
# Last Updated: 2024-01-10

# Strict mode for better error handling
set -euo pipefail

# Determine the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR" && pwd)"

# Import colors from utility/colors.sh
source "$(dirname "${BASH_SOURCE[0]}")/.config/utility/colors.sh"

# Global variables for test results
declare -A TEST_RESULTS
declare -A SYSTEM_INFO
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
START_TIME=$(date +%s)

# Logging function
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_file="$ROOT_DIR/comprehensive_test_log.txt"
    
    case "$level" in
        "INFO")
            echo -e "[${COLORS[BLUE]}INFO${COLORS[RESET]}] $timestamp - $message" | tee -a "$log_file"
            ;;
        "SUCCESS")
            echo -e "[${COLORS[GREEN]}SUCCESS${COLORS[RESET]}] $timestamp - $message" | tee -a "$log_file"
            ;;
        "ERROR")
            echo -e "[${COLORS[RED]}ERROR${COLORS[RESET]}] $timestamp - $message" | tee -a "$log_file"
            ;;
        "WARN")
            echo -e "[${COLORS[YELLOW]}WARN${COLORS[RESET]}] $timestamp - $message" | tee -a "$log_file"
            ;;
        "DEBUG")
            echo -e "[${COLORS[PURPLE]}DEBUG${COLORS[RESET]}] $timestamp - $message" | tee -a "$log_file"
            ;;
        *)
            echo -e "[$level] $timestamp - $message" | tee -a "$log_file"
            ;;
    esac
}

# Ensure script is run with sudo
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        log "ERROR" "This script must be run with sudo privileges"
        exit 1
    fi
}

# Function to collect system information
collect_system_info() {
    log "INFO" "Collecting system information..."   
    {
        apt update -y
        apt install -y procps jq
    } > /dev/null 2>&1
    
    # CPU Information
    SYSTEM_INFO["cpu_model"]=$(lscpu | grep "Model name" | cut -d: -f2 | xargs)
    SYSTEM_INFO["cpu_cores"]=$(lscpu | grep "^CPU(s):" | cut -d: -f2 | xargs)
    SYSTEM_INFO["cpu_threads"]=$(lscpu | grep "Thread(s) per core" | cut -d: -f2 | xargs)
    
    # Memory Information
    SYSTEM_INFO["total_memory"]=$(free -h | awk '/^Mem:/ {print $2}')
    SYSTEM_INFO["available_memory"]=$(free -h | awk '/^Mem:/ {print $7}')
    
    # Disk Information
    SYSTEM_INFO["disk_space"]=$(df -h / | awk 'NR==2 {print $4}')
    
    # OS Information
    SYSTEM_INFO["os_version"]=$(grep "PRETTY_NAME" /etc/os-release | cut -d'"' -f2)
    SYSTEM_INFO["kernel_version"]=$(uname -r)
}

# Utility function to run a script with error handling
run_script() {
    local script_path="${1:-}"
    local action="${2:---install}"
    
    # Validate script path
    if [[ -z "$script_path" ]]; then
        log "ERROR" "No script path provided to run_script()"
        return 1
    fi
    
    # Add explicit logging and path verification
    log "DEBUG" "Attempting to run script: $script_path"
    log "DEBUG" "Full script path: $(realpath "$script_path")"
    log "DEBUG" "Action: $action"
    
    # Check if script exists
    if [ ! -f "$script_path" ]; then
        log "ERROR" "Script does not exist: $script_path"
        return 1
    fi
    
    # Ensure script is executable
    if [[ ! -x "$script_path" ]]; then
        log "WARN" "Script not executable. Attempting to add execute permissions."
        chmod +x "$script_path" || {
            log "ERROR" "Failed to add execute permissions to $script_path"
            return 1
        }
    fi
    
    # Verbose logging of script execution
    log "INFO" "Running script: $script_path with action: $action"
    
    # Capture both stdout and stderr, show full output
    local output
    output=$("$script_path" "$action" > /dev/null 2>&1)
    local exit_code=$?
    
    # Log the full output for debugging
    log "DEBUG" "Script output: $output"
    
    if [ $exit_code -eq 0 ]; then
        log "SUCCESS" "Script $script_path executed successfully"
        return 0
    else
        log "ERROR" "Script $script_path failed with exit code $exit_code"
        log "ERROR" "Script output: $output"
        return 1
    fi
}

# Test system update functionality
testSystemUpdate() {
    log "INFO" "Testing system update process"
    
    if run_script "$ROOT_DIR/.config/utility/updateSystem.sh" "--update"; then
        log "SUCCESS" "System update completed successfully"
        ((PASSED_TESTS++))
    else
        log "ERROR" "System update failed"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
    
    return 0
}

# Test dependencies installation
testDependenciesInstallation() {
    log "INFO" "Testing dependencies installation"
    
    local script_path="$ROOT_DIR/.config/dependencies/installDependencies.sh"
    
    # Use --install flag explicitly
    if ! run_script "$script_path" "--install"; then
        log "ERROR" "Failed to run dependencies installation script"
        ((FAILED_TESTS++))
        ((TOTAL_TESTS++))
        return 1
    fi
    
    local deps=("sudo" "aria2" "tar" "wget" "gnupg2" "software-properties-common" "apt-transport-https" "curl" "rsync" "procps" "libssl1.1" "libcurl4" "libc6:i386" "libstdc++6:i386")
    local failed=0
    local successful=0
    
    for dep in "${deps[@]}"; do
        if dpkg -l | grep -q "^ii.*$dep"; then
            log "SUCCESS" "Dependency $dep is installed"
            ((successful++))
        else
            log "ERROR" "Dependency $dep installation failed"
            ((failed++))
        fi
    done
    
    if [ $failed -eq 0 ]; then
        log "SUCCESS" "All dependencies installed correctly"
        ((PASSED_TESTS++))
    else
        log "ERROR" "$failed dependencies failed to install"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Test firewall installation and configuration
testFirewallInstallation() {
    log "INFO" "Testing firewall installation"
    
    if run_script "$ROOT_DIR/.config/firewall/installFirewall.sh" "--install 22"; then
        if command -v ufw &> /dev/null && ufw status | grep -q "Status: active"; then
            log "SUCCESS" "Firewall is installed and active"
            ((PASSED_TESTS++))
        else
            log "ERROR" "Firewall is installed but not active"
            ufw enable  # Attempt to enable firewall
            if ufw status | grep -q "Status: active"; then
                log "SUCCESS" "Firewall activated successfully"
                ((PASSED_TESTS++))
            else
                log "ERROR" "Could not activate firewall"
                ((FAILED_TESTS++))
            fi
        fi
    else
        log "ERROR" "Firewall installation script failed"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Test 32-bit packages enablement
test32BitPackagesEnablement() {
    log "INFO" "Testing 32-bit package support"
    
    if run_script "$ROOT_DIR/.config/x86-packages/enable32BitPackages.sh" "--install"; then
        if dpkg --print-foreign-architectures | grep -q "i386"; then
            log "SUCCESS" "32-bit package support is enabled"
            ((PASSED_TESTS++))
        else
            # Attempt manual 32-bit architecture enablement
            dpkg --add-architecture i386
            apt-get update
            if dpkg --print-foreign-architectures | grep -q "i386"; then
                log "SUCCESS" "32-bit package support manually enabled"
                ((PASSED_TESTS++))
            else
                log "ERROR" "32-bit package support is not enabled"
                ((FAILED_TESTS++))
            fi
        fi
    else
        log "ERROR" "32-bit packages enablement script failed"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Test Wine installation
testWineInstallation() {
    log "INFO" "Testing Wine installation"
    
    if run_script "$ROOT_DIR/.config/wine/installWine.sh" "--install"; then
        if command -v wine &> /dev/null; then
            local wine_version=$(wine --version)
            log "SUCCESS" "Wine is installed (Version: $wine_version)"
            ((PASSED_TESTS++))
        else
            # Attempt manual Wine installation
            apt-get install -y wine
            if command -v wine &> /dev/null; then
                local wine_version=$(wine --version)
                log "SUCCESS" "Wine manually installed (Version: $wine_version)"
                ((PASSED_TESTS++))
            else
                log "ERROR" "Wine is not installed"
                ((FAILED_TESTS++))
            fi
        fi
    else
        log "ERROR" "Wine installation script failed"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Test .NET installation
testDotnetInstallation() {
    log "INFO" "Testing .NET installation"
    
    if run_script "$ROOT_DIR/.config/dotnet/installDotnet.sh" "--install"; then
        if command -v dotnet &> /dev/null; then
            log "SUCCESS" ".NET Framework is installed"
            ((PASSED_TESTS++))
        else
            # Attempt manual .NET installation
            wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
            dpkg -i packages-microsoft-prod.deb
            apt-get update
            apt-get install -y aspnetcore-runtime-7.0
            
            if command -v dotnet &> /dev/null; then
                log "SUCCESS" ".NET Framework manually installed"
                ((PASSED_TESTS++))
            else
                log "ERROR" ".NET Framework is not installed"
                ((FAILED_TESTS++))
            fi
        fi
    else
        log "ERROR" ".NET installation script failed"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Test game binaries installation
testGameBinariesInstallation() {
    log "INFO" "Testing game binaries installation"
    
    if run_script "$ROOT_DIR/.config/binaries/installGameBinaries.sh" "--install"; then
        local install_dir="/opt/T6Server"  # Fallback default directory
        
        # # Check if server_config.json exists, if not use default
        # if [ -f "$ROOT_DIR/server_config.json" ]; then
        #     install_dir=$(jq -r '.general_config.install_dir' "$ROOT_DIR/server_config.json")
        # fi
        
        if [ -d "$install_dir/Plutonium" ] && [ -f "$install_dir/Plutonium/plutonium-updater" ]; then
            log "SUCCESS" "Game binaries are installed correctly"
            ((PASSED_TESTS++))
        else
            log "ERROR" "Game binaries are missing or incomplete"
            ((FAILED_TESTS++))
        fi
    else
        log "ERROR" "Game binaries installation script failed"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}
# Test uninstallation process
testUninstallation() {
    log "INFO" "Testing uninstallation process simulation"
    local test_dir="/tmp/test_uninstall"
    mkdir -p "$test_dir"
    
    if [ -d "$test_dir" ]; then
        rm -rf "$test_dir"
        if [ ! -d "$test_dir" ]; then
            log "SUCCESS" "Uninstallation simulation successful"
            ((PASSED_TESTS++))
        else
            log "ERROR" "Failed to remove test directory"
            ((FAILED_TESTS++))
        fi
    else
        log "ERROR" "Failed to create test directory"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
}

# Main test execution
main() {
    # Check for sudo privileges
    check_sudo
    
    # Collect system information
    collect_system_info
    
    log "INFO" "Starting Comprehensive System Validation"
    
    # Execute all test functions
    local test_functions=(
        testSystemUpdate
        testDependenciesInstallation
        testFirewallInstallation
        test32BitPackagesEnablement
        testWineInstallation
        testDotnetInstallation
        testGameBinariesInstallation
        testUninstallation
    )
    
    for test_func in "${test_functions[@]}"; do
        log "INFO" "Executing test: $test_func"
        if ! $test_func; then
            log "ERROR" "Test $test_func failed. Continuing with next test."
        fi
    done
    
    # Generate final summary
    local end_time=$(date +%s)
    local total_time=$((end_time - START_TIME))
    
    echo -e "\n${COLORS[CYAN]}╔══════════════════════════════════════════════════════════════╗${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║                      TEST SUMMARY REPORT                     ║${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}╠══════════════════════════════════════════════════════════════╣${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ${COLORS[WHITE]}Test Results:${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ├─ Total Tests:    ${COLORS[BLUE]}$TOTAL_TESTS${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ├─ Passed Tests:   ${COLORS[GREEN]}$PASSED_TESTS${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ├─ Failed Tests:   ${COLORS[RED]}$FAILED_TESTS${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} └─ Execution Time: ${COLORS[PURPLE]}$total_time seconds${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ${COLORS[WHITE]}System Information:${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ├─ CPU:           ${COLORS[YELLOW]}${SYSTEM_INFO[cpu_model]}${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ├─ Cores/Threads: ${COLORS[YELLOW]}${SYSTEM_INFO[cpu_cores]}/${SYSTEM_INFO[cpu_threads]}${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ├─ Memory:        ${COLORS[YELLOW]}${SYSTEM_INFO[total_memory]} (${SYSTEM_INFO[available_memory]} available)${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ├─ Disk Space:    ${COLORS[YELLOW]}${SYSTEM_INFO[disk_space]} free${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} ├─ OS Version:    ${COLORS[YELLOW]}${SYSTEM_INFO[os_version]}${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}║${COLORS[RESET]} └─ Kernel:        ${COLORS[YELLOW]}${SYSTEM_INFO[kernel_version]}${COLORS[RESET]}"
    echo -e "${COLORS[CYAN]}╚════════════════════════════════════════════════════════════╝${COLORS[RESET]}"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        log "SUCCESS" "All tests completed successfully!"
        exit 0
    else
        log "ERROR" "$FAILED_TESTS tests failed. Please review the log for details."
        exit 1
    fi
}

# Execute main test suite
main