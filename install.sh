#!/bin/bash
clear
# Sudoer permission
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo env "HOME='$HOME'" $0 $*"
    exit 1
fi

# Colors Section
YELLOW='\033[1;33m'
GREY='\033[1;37m'
PURPUL='\033[0;35m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'


# Function Progress
Spinner (){ 
pid=$!
spin='-\|/'
i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r [${spin:$i:1}] $1"
  sleep .1
done
printf "\r [${GREEN}\xE2\x9C\x94${NC}] $1 \n"
}

# Home Section
logo(){
printf "${RED}
  _______ __     _____                            _____           _        _ _           
 |__   __/ /    / ____|                          |_   _|         | |      | | |          
    | | / /_   | (___   ___ _ ____   _____ _ __    | |  _ __  ___| |_ __ _| | | ___ _ __ 
    | || \'_ \   \___ \ / _ \ \'__\ \ / / _ \ \'__|   | | | \'_ \/ __| __/ _\` | | |/ _ \ \'__|
    | || (_) |  ____) |  __/ |   \ V /  __/ |     _| |_| | | \__ \ || (_| | | |  __/ |   
    |_| \___/  |_____/ \___|_|    \_/ \___|_|    |_____|_| |_|___/\__\__,_|_|_|\___|_|   
 ${NC}                                                                                        
                         ╔══════════════════════════════╗
                         ║      Made by ${BLUE}Sterbweise${NC}      ║
                         ╠══════════════════════════════╣
                         ║ ${PURPUL}\e]8;;https://github.com/Sterbweise\e\\Github\e]8;;\e\\\\${NC} | ${RED}\e]8;;https://www.youtube.com/channel/UCRWfp6bi0-wlhaRe2YQ2dwQ\e\\Youtube\e]8;;\e\\\\${NC} | ${GREY}\e]8;;https://forum.plutonium.pw/user/minami\e\\Plutonium\e]8;;\e\\\\${NC} ║
                         ╚══════════════════════════════╝ \n \n"
}

logo
# Languages Selection
printf "
${YELLOW}Select your languages : ${NC}
[0] English
[1] French
\n
"
read -p '>>> ' languages
clear
logo
# Choices Section
mfirewall=('Do you want install UFW firewall (Y/n) ?' 'Voulez-vous installer le pare-feu UFW (O/n) ?')
printf "${YELLOW}${mfirewall[$languages]}${NC}\n"
read -p '>>> ' firewall

mdotnet=('Do you want install Dotnet [Required for IW4Madmin] (Y/n) ?' 'Voulez-vous installer Dotnet [Requis pour IW4Madmin] (O/n) ?')
printf "\n\n${YELLOW}${mdotnet[$languages]}${NC}\n"
read -p '>>> ' dotnet
stty igncr
clear
logo

# Update Systeme
mupdate=('Updating the system' 'Mise a jours du systeme')
{
apt update
} > /dev/null 2>&1 &
Spinner "${mupdate[$languages]}"

# Setup Firewall
if [ "$firewall" = 'y' ] || [ "$firewall" = '' ] || [ "$firewall" = 'Y' ] || [ "$firewall" = 'o' ] || [ "$firewall" = 'O' ] ; then
  mfirewall2=('Firewall installation and ssh port opening.' 'Installation du pare-feu et ouverture du port ssh.') 
  {
    apt install ufw fail2ban -y && \
    ufw allow 22/tcp && \
    ufw default allow outgoing && \
    ufw default deny incoming && \
    ufw -f enable
  } > /dev/null 2>&1 &
  Spinner "${mfirewall2[$languages]}"
fi

# Enable 32 bit packages
mbit=('Enabling 32-bit packages' 'Activation des paquets 32 bits')
{
  dpkg --add-architecture i386 && \
  apt-get update -y && \
  apt-get install wget gnupg2 software-properties-common apt-transport-https curl -y
} > /dev/null 2>&1 &
Spinner "${mbit[$languages]}"

## Installing Wine
mwine=('Installing Wine.' 'Installation de Wine.')
{
  wget -nc https://dl.winehq.org/wine-builds/winehq.key
  apt-key add winehq.key && \
  apt-add-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main'
  rm winehq.key
  apt update -y
  apt install --install-recommends winehq-stable -y

  # Add Variables to the environment at the end of ~/.bashrc
  echo -e 'export WINEPREFIX=~/.wine\nexport WINEDEBUG=fixme-all\nexport WINEARCH=win64' >> ~/.bashrc
  echo -e 'export DISPLAY=:0' >> ~/.bashrc
  source ~/.bashrc
  winecfg
} > /dev/null 2>&1 &
Spinner "${mwine[$languages]}"

# Dotnet Installation
if [ $dotnet == 'y' ] || [ $dotnet == '' ] || [ $dotnet == 'Y' ] || [ $dotnet == 'o' ] || [ $dotnet == 'O' ] ; then
  mdotnet2=('Installing Dotnet.' 'Installation de Dotnet.')
  {
    #Dotnet Package
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    #Install the SDK
    apt-get install -y dotnet-sdk-3.1
    apt-get install -y dotnet-sdk-6.0

    #Install the runtime
    apt-get install -y aspnetcore-runtime-3.1
	  apt-get install -y aspnetcore-runtime-6.0
  } > /dev/null 2>&1 &
  Spinner "${mdotnet2[$languages]}"
fi

mbinary=('Game Binary Installation.' 'Installation des fichiers binaires.')
{
  # Shortcut Zone
  ln -s $HOME/T6Server/Server/zone $HOME/T6Server/Server/Zombie/zone
  ln -s $HOME/T6Server/Server/zone $HOME/T6Server/Server/Multiplayer/zone

  # Download plutonium-updater
  cd $HOME/T6Server/Plutonium/
  wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
  tar xfv plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
  rm plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
  chmod +x plutonium-updater

 # Make executable script
  chmod +x $HOME/T6Server/Plutonium/T6Server.sh
} > /dev/null 2>&1 &
  Spinner "${mbinary[$languages]}"

mfinish=('Installation finished.' 'Installation terminee.')
mquit=('ENTER to quit.' 'ENTER pour quitter.')
printf "\n${GREEN}${mfinish[$languages]}${NC}\n"
printf "\n${mquit[$languages]}"
stty -igncr
read
exit