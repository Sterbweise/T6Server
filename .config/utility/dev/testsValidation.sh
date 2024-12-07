#!/bin/bash

# testsValidation.sh - Test suite for T6 Server Installation and Management Scripts
# Version: 1.0.0
# Author: Sterbweise
# Last Updated: 01/09/2024

# Function to log messages
logMessage() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a test_log.txt
}

# Import necessary configurations and functions
logMessage "Importing necessary configurations and functions"
DEFAULT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$DEFAULT_DIR/.config/config.sh"
source "$DEFAULT_DIR/.config/function.sh" --debug


# Function to run all tests
runAllTests() {
    logMessage "Starting all tests"
    testSystemUpdate
    testDependenciesInstallation
    testFirewallInstallation
    test32BitPackagesEnablement
    testWineInstallation
    testDotnetInstallation
    testGameBinariesInstallation
    testUninstallation
    logMessage "All tests completed"
}

# Test system update
testSystemUpdate() {
    logMessage "Testing system update..."
    updateSystem
    if [[ $? -eq 0 ]]; then
        logMessage "System update test passed."
    else
        logMessage "System update test failed. Exit code: $?"
    fi
}

# Test dependencies installation
testDependenciesInstallation() {
    logMessage "Testing dependencies installation..."
    installDependencies
    if command -v wget &> /dev/null && command -v gpg &> /dev/null && command -v curl &> /dev/null; then
        logMessage "Dependencies installation test passed. wget, gpg, and curl are available."
    else
        logMessage "Dependencies installation test failed. Missing one or more dependencies."
        command -v wget &> /dev/null || logMessage "wget is not installed."
        command -v gpg &> /dev/null || logMessage "gpg is not installed."
        command -v curl &> /dev/null || logMessage "curl is not installed."
    fi
}

# Test firewall installation
testFirewallInstallation() {
    logMessage "Testing firewall installation..."
    installFirewall 22
    if command -v ufw &> /dev/null; then
        logMessage "Firewall installation test passed. ufw is available."
        ufw status | tee -a test_log.txt
    else
        logMessage "Firewall installation test failed. ufw is not installed."
    fi
}

# Test 32-bit packages enablement
test32BitPackagesEnablement() {
    logMessage "Testing 32-bit packages enablement..."
    enable32BitPackages
    if dpkg --print-foreign-architectures | grep -q i386; then
        logMessage "32-bit packages enablement test passed. i386 architecture is enabled."
    else
        logMessage "32-bit packages enablement test failed. i386 architecture is not enabled."
    fi
    dpkg --print-foreign-architectures | tee -a test_log.txt
}

# Test Wine installation
testWineInstallation() {
    logMessage "Testing Wine installation..."
    installWine
    if command -v wine &> /dev/null; then
        logMessage "Wine installation test passed. Wine version:"
        wine --version | tee -a test_log.txt
    else
        logMessage "Wine installation test failed. Wine is not installed."
    fi
}

# Test .NET installation
testDotnetInstallation() {
    logMessage "Testing .NET installation..."
    installDotnet
    if command -v dotnet &> /dev/null; then
        logMessage "Dotnet installation test passed. Dotnet version:"
        dotnet --info | tee -a test_log.txt
    else
        logMessage "Dotnet installation test failed. Dotnet is not installed."
    fi
}

# Test game binaries installation
testGameBinariesInstallation() {
    logMessage "Testing game binaries installation..."
    installGameBinaries 
    if [[ -f "$WORKDIR/Plutonium/plutonium-updater" ]]; then
        logMessage "Game binaries installation test passed. plutonium-updater found."
        ls -l "$WORKDIR/Plutonium" | tee -a test_log.txt
    else
        logMessage "Game binaries installation test failed. plutonium-updater not found."
        logMessage "Contents of $WORKDIR:"
        ls -R "$WORKDIR" | tee -a test_log.txt
    fi
}

# Test uninstallation
testUninstallation() {
    logMessage "Testing uninstallation process..."
    uninstallGameBinaries 
    uninstallDotnet
    uninstallWine
    uninstallFirewall
    if [[ ! -d "$WORKDIR/Server" && ! -d "$WORKDIR/Plutonium" ]]; then
        logMessage "Uninstallation test passed. Server and Plutonium directories removed."
    else
        logMessage "Uninstallation test failed. One or more directories still exist:"
        ls -l "$WORKDIR" | tee -a test_log.txt
    fi
}

# Run all tests
runAllTests

logMessage "Test log contents:"
cat test_log.txt