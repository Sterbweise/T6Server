# Function to confirm installations
# This allows users to confirm installations of optional components
confirmInstallations() {
    local options=("firewall" "dotnet")
    local descriptions=("firewall" "dotnet")
    local variables=("firewall" "dotnet")

    for i in "${!options[@]}"; do
        local option="${options[$i]}"
        local description="${descriptions[$i]}"
        local variable="${variables[$i]}"

        # Reset terminal settings to a sane state to ensure proper input handling
        stty sane
        if [[ -z "${!variable}" ]]; then
            while true; do
                printf "\n${COLORS[YELLOW]}$(getMessage "$description") ${COLORS[RESET]}"
                read -r input

                # Convertir l'entrée en minuscules, gérer l'entrée vide
                input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

                case "$input" in
                    "" | "o" | "oui" | "y" | "yes")
                        declare "$variable=yes"
                        break
                        ;;
                    "n" | "non" | "no")
                        declare "$variable=no"
                        break
                        ;;
                    *)
                        echo "$(getMessage "invalid_input_yn")"
                        ;;
                esac
            done
        fi
    done

    # Ask for SSH port if firewall is to be installed
    if [[ "$firewall" == "yes" ]]; then
        while true; do
            printf "\n${COLORS[YELLOW]}$(getMessage "ssh_port")${COLORS[RESET]}\n"
            printf "${COLORS[LIGHT_RED]}$(getMessage "ssh_port_enter")${COLORS[RESET]}\n"
            printf ">>> "
            read -r ssh_port_input
            
            # Validation du port plus robuste
            if [[ -z "$ssh_port_input" ]]; then
                echo "$(getMessage "invalid_port")"
                continue
            fi

            if [[ "$ssh_port_input" =~ ^[1-9][0-9]{0,4}$ ]] && 
               [ "$ssh_port_input" -ge 1 ] && 
               [ "$ssh_port_input" -le 65535 ]; then
                ssh_port=$ssh_port_input
                break
            else
                echo "$(getMessage "invalid_port")"
            fi
        done
    fi
}