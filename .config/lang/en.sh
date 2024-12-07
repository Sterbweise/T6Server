#!/bin/bash

# en.sh - English Language File for Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Description:
# This script contains all the English language strings used in the Plutonium Call of Duty: Black Ops II
# server installation, management, and uninstallation scripts. It provides localization support
# for English-speaking users.

# Usage:
# This file is sourced by other scripts to provide localized text output. It should not be
# executed directly.

# Note: Ensure this file is in the .config/lang/ directory relative to the main scripts.

# Installation Messages
# These messages are displayed during the server installation process

# Utility Messages
selectLanguage_en="Select your language:"
update_en="Updating the system"
bit_en="Enabling 32-bit packages"
finish_en="Installation finished."
quit_en="Press CTRL+C to quit."
dependencies_install_en="Installing dependencies."

# Firewall Messages
firewall_en="Do you want to install UFW firewall (Y/n)?"
ssh_port_en="Enter the SSH port to open (default: 22):"
ssh_port_enter_en="If you cannot use ENTER, press the SPACE bar multiple times."
firewall_install_en="Firewall installation and port opening."

# Dotnet Messages
dotnet_en="Do you want to install Dotnet [Required for IW4Madmin] (Y/n)?"
dotnet_failed_install_en="Dotnet installation failed."
dotnet_install_en="Installing Dotnet."

# Wine Messages
wine_en="Installing Wine."

# Game Binary Messages
binary_en="Game Binary Installation."

# Uninstallation Messages
confirmUninstall_en="Are you sure you want to uninstall? This will remove all components installed by the setup script."
confirm_prompt_en="Type 'y' to confirm: "
uninstall_cancelled_en="Uninstallation cancelled."
uninstall_binary_en="Uninstalling game binaries."
uninstallDotnet_en="Uninstalling Dotnet."
uninstallWine_en="Uninstalling Wine."
remove_firewall_en="Removing firewall."
cleanup_en="Cleaning up."
uninstall_finish_en="Uninstallation completed."