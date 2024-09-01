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

        if [[ -z "${!variable}" ]]; then
            while true; do
                printf "\n${YELLOW}$(getMessage "$description")${NC}\n"
                printf ">>> "
                read -n 1 -r input
                echo  # New line after input
                case $input in
                    [yYoO])
                        declare "$variable=yes"
                        break
                        ;;
                    [nN])
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
            printf "\n${YELLOW}$(getMessage "ssh_port")${NC}\n"
            printf "${LIGHT_RED}$(getMessage "ssh_port_enter")${NC}\n"
            printf ">>> "
            read -r ssh_port_input
            if [[ "$ssh_port_input" =~ ^[0-9]+$ ]] && [ "$ssh_port_input" -ge 1 ] && [ "$ssh_port_input" -le 65535 ]; then
                ssh_port=$ssh_port_input
                break
            else
                echo "$(getMessage "invalid_port")"
            fi
        done
    fi
}