# Function to get a message in the selected language
# This supports localization of the script's output
getMessage() {
    local key="${1}_en"
    [[ $language -eq 1 ]] && key="${1}_fr"
    echo "${!key}"
}