# Function to update the system
# This ensures the system is up-to-date before proceeding with installations
updateSystem() {
    {
        # Check if an update is needed
        if ! apt-get update --dry-run 2>&1 | grep -q "0 packages can be upgraded"; then
            apt-get update
        else
            # If no update is needed, sleep for a moment to allow the showProgressIndicator to show
            sleep 2
        fi
    } > /dev/null 2>&1 &
    showProgressIndicator "$(getMessage "update")"
}