#!/bin/bash
_script="$(readlink -f ${BASH_SOURCE[0]})" 
# Delete last component from $_script
_mydir="$(dirname $_script)"
# Name of the server shown in the title of the terminal window
NAME="SERVER_NAME"
# Your Game Path (where there is binkw32.dll)
PAT=~/T6_Server/Server/Multiplayer
# Paste the server key from https://platform.plutonium.pw/serverkeys
KEY="YOURKEY"
# Name of the config file the server should use. (default: dedicated.cfg)
CFG=dedicated.cfg
# Port used by the server (default: 4976) -> Don't forget to allow server port in ufw fail2ban
PORT=4976
# Game Mode ( Multiplayer / Zombie ) -> ( t6mp / t6zm )
MODE=t6mp
# Plutonium game dir
INSTALLDIR=~/T6_Server/Plutonium

# Update your server game file
./plutonium-updater.exe -d "$INSTALLDIR"

# Server Start Region
echo -e '\033]2;'Plutonium - $NAME - Server restart'\007'
echo "Visit plutonium.pw | Join the Discord (plutonium) for NEWS and Updates!"
echo "Server "$NAME" will load $CFG and listen on port $PORT UDP!"
echo "To shut down the server close this window first!"
printf -v NOW '%(%F_%H:%M:%S)T' -1
echo ""$NOW" $NAME server started."

while true
do
wine .\\bin\\plutonium-bootstrapper-win32.exe $MODE $PAT -dedicated +start_map_rotate +set key $KEY +set net_port $PORT +set sv_config $CFG
printf -v NOW '%(%F_%H:%M:%S)T' -1
echo ""$NOW" WARNING: $NAME server closed or dropped... server restarting."
sleep 1
done