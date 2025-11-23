#!/bin/bash

# File: colors.sh
# Description: ANSI color codes for terminal text formatting
# Version: 1.0.0
# Author: Sterbweise
# Last Updated: 07/12/2024

# Text formatting codes
declare -A COLORS=(
    # Regular colors
    [YELLOW]='\033[1;33m'
    [GREY]='\033[1;37m'
    [PURPLE]='\033[0;35m'
    [GREEN]='\033[0;32m'
    [BLUE]='\033[0;34m'
    [RED]='\033[0;31m'
    [CYAN]='\033[0;36m'
    [MAGENTA]='\033[0;35m'
    [WHITE]='\033[1;37m'
    [BLACK]='\033[0;30m'
    [ORANGE]='\033[0;33m'
    
    # Light/Bold colors
    [LIGHT_BLACK]='\033[1;30m'
    [LIGHT_RED]='\033[1;31m'
    [LIGHT_GREEN]='\033[1;32m'
    [LIGHT_YELLOW]='\033[1;33m'
    [LIGHT_BLUE]='\033[1;34m'
    [LIGHT_PURPLE]='\033[1;35m'
    [LIGHT_CYAN]='\033[1;36m'
    [LIGHT_WHITE]='\033[1;37m'
    
    # Background colors
    [BG_BLACK]='\033[40m'
    [BG_RED]='\033[41m'
    [BG_GREEN]='\033[42m'
    [BG_YELLOW]='\033[43m'
    [BG_BLUE]='\033[44m'
    [BG_PURPLE]='\033[45m'
    [BG_CYAN]='\033[46m'
    [BG_WHITE]='\033[47m'
    
    # Special formatting
    [BOLD]='\033[1m'
    [UNDERLINE]='\033[4m'
    [REVERSED]='\033[7m'
    [RESET]='\033[0m'
)

# Export colors for use in other scripts
export COLORS