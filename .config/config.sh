#!/bin/bash

# Work directory
WORKDIR="/opt/T6Server"

# Detect the current distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
else
    DISTRO="debian"
    VERSION="10"
fi

# Color codes
YELLOW='\033[1;33m'
GREY='\033[1;37m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'  # No Color

# Global variables
language=0
firewall=""
ssh_port=22
dotnet=""



# Source language files
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source "$SCRIPT_DIR/lang/en.sh"
source "$SCRIPT_DIR/lang/fr.sh"