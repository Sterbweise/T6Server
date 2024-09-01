# Function to confirm uninstallation
# This provides a safety check before proceeding with uninstallation
confirmUninstall() {
    local uninstallDotnet=false
    local uninstallWine=false
    local disable_32bit=false
    local uninstallFirewall=false
    local uninstallGameBinaries =false

    while true; do
        printf "${YELLOW}$(getMessage "uninstall_options")${NC}\n"
        printf "[1] $(getMessage "uninstallDotnet") [%s]\n" "$(if $uninstallDotnet; then echo "Y"; else echo "N"; fi)"
        printf "[2] $(getMessage "uninstallWine") [%s]\n" "$(if $uninstallWine; then echo "Y"; else echo "N"; fi)"
        printf "[3] $(getMessage "disable_32bit") [%s]\n" "$(if $disable_32bit; then echo "Y"; else echo "N"; fi)"
        printf "[4] $(getMessage "uninstallFirewall") [%s]\n" "$(if $uninstallFirewall; then echo "Y"; else echo "N"; fi)"
        printf "[5] $(getMessage "uninstallGameBinaries ") [%s]\n" "$(if $uninstallGameBinaries ; then echo "Y"; else echo "N"; fi)"
        printf "${RED}[6] $(getMessage "uninstall_selected")${NC}\n"
        printf "[0] $(getMessage "cancel")\n\n"
        printf "$(getMessage "select_option") "
        read -n 1 -r option
        echo  # New line after input
        case $option in
            1)
                uninstallDotnet=!$uninstallDotnet
                ;;
            2)
                uninstallWine=!$uninstallWine
                ;;
            3)
                disable_32bit=!$disable_32bit
                ;;
            4)
                uninstallFirewall=!$uninstallFirewall
                ;;
            5)
                uninstallGameBinaries =!$uninstallGameBinaries 
                ;;
            6)
                printf "${RED}$(getMessage "confirmUninstall_selected")${NC}\n"
                printf "$(getMessage "confirm_prompt") "
                read -n 1 -r confirm
                echo  # New line after input
                if [[ "$confirm" =~ ^[yYoO]$ ]]; then
                    if $uninstallDotnet; then uninstallDotnet; fi
                    if $uninstallWine; then uninstallWine; fi
                    if $disable_32bit; then disable_32bit; fi
                    if $uninstallFirewall; then uninstallFirewall; fi
                    if $uninstallGameBinaries ; then uninstallGameBinaries ; fi
                    break
                fi
                ;;
            0)
                printf "${YELLOW}$(getMessage "uninstall_cancelled")${NC}\n"
                exit 0
                ;;
            *)
                echo "$(getMessage "invalid_input")"
                ;;
        esac
    done
}