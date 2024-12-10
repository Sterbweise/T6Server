# Function to select the language
# This allows users to choose their preferred language for script messages
selectLanguage() {
    # Reset terminal settings to a sane state to ensure proper input handling
    stty sane
    while true; do
        printf "${COLORS[YELLOW]}$(getMessage "selectLanguage")${COLORS[RESET]}\n"
        printf "[0] English\n"
        printf "[1] French\n"
        printf "[2] Spanish\n"
        printf "[3] Chinese\n\n"
        printf ">>> "
        read -r language_input
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
            2)
                language=2
                break
                ;;
            3)
                language=3
                break
                ;;
            *)
                echo "Invalid input. Please enter 0, 1, 2, or 3."
                ;;
        esac
    done
}