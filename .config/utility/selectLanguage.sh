# Function to select the language
# This allows users to choose their preferred language for script messages
selectLanguage() {
    while true; do
        printf "${YELLOW}$(getMessage "selectLanguage")${NC}\n"
        printf "[0] English\n"
        printf "[1] French\n\n"
        printf ">>> "
        read -n 1 -r language_input
        echo  # New line after input
        case $language_input in
            0)
                language=0
                break
                ;;
            1)
                language=1
                break
                ;;
            *)
                echo "Invalid input. Please enter 0 or 1."
                ;;
        esac
    done
    showLogo
}