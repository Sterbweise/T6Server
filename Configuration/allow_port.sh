#!/bin/bash
echo "Enter the port you want to allow (Exemple: 4976)"
read -p 'Port Number: ' port
echo "Name of your port (Exemple: T6Server)"
read -p 'Name: ' name
ufw allow $port comment $name && \
if [ $? -eq 0 ]; then
    echo "The port $port has been opened"
    ufw reload
    if [ $? -eq 0 ]; then
        echo "The firewall has reloaded"
    else
        echo "[Error] The firewall could not be reloaded"
    fi
else
    echo "[Error] The port could not be opened"
fi