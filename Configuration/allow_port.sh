#!/bin/bash
echo "Enter the port you want to allow (Exemple: 4976)"
read -p 'Port Number: ' $port
echo "Name of your port (Exemple: T6Server)"
read -p 'Name: ' $name
ufw allow $port comment $name && \
ufw reload
echo "The port $port has been opened"
echo "The firewall has reloaded"