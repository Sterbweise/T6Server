#!/bin/bash

# File: function.sh
# Description: Script to import all function files from the .config directory and its subdirectories
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Function to import all function files
importFunctions() {
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
    local current_file="$(basename "${BASH_SOURCE[0]}")"
    declare -A imported

    while IFS= read -r -d '' func_file; do
        local rel_path="${func_file#$SCRIPT_DIR/}"
        # Skip files in the dev directory
        if [[ "$rel_path" =~ ^utility/dev/ ]]; then
            continue
        fi
        if [[ "$rel_path" != "$current_file" && -z "${imported[$rel_path]}" ]]; then
            if [[ "$1" == "--debug" ]]; then
                echo "Importing: $rel_path"  # Debug output
            fi
            imported[$rel_path]=1
            source "$func_file" --import
        fi
    done < <(find "$SCRIPT_DIR" -type f -name "*.sh" -print0)
}

# Execute the import function only if it hasn't been run before
if [[ -z "$FUNCTIONS_IMPORTED" ]]; then
    FUNCTIONS_IMPORTED=1
    importFunctions "$1"
fi
