#!/bin/bash

## Update Region
echo "Update repository and Upgrade software..."
apt-get update && apt-get upgrade -y
## End Region

## Firewall Region
echo "Install firewall and allow 22 port..."
apt install -y ufw fail2ban && \
ufw allow 22/tcp && \
ufw default allow outgoing && \
ufw default deny incoming && \
ufw enable
## End Region

# Enable 32 bit packages
echo "Enable 32 bit packages..."
dpkg --add-architecture i386

## Wine Region
echo "Installing Wine..."
wget -nc https://dl.winehq.org/wine-builds/winehq.key
apt-key add winehq.key
rm winehq.key
apt install --install-recommends winehq-stable

# Add Variables to the environment at the end of ~/.bashrc
echo -e 'export WINEPREFIX=~/.wine\nexport WINEDEBUG=fixme-all\nexport WINEARCH=win64' >> ~/.bashrc

# Update our session
source ~/.bashrc

# Configure our wine environment
winecfg
## End Region

## Pre-Required for IW4MAdmin Region
echo "Installing Pre-Required for IW4MAdmin..."
#Installation .NET Core 3.1
wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

#Install the SDK
#The .NET SDK allows you to develop apps with .NET. If you install the .NET SDK, you don't need to install the corresponding runtime. To install the .NET SDK, run the following commands:

apt-get update; \
	apt-get install -y dotnet-sdk-3.1

#Install the runtime
#The ASP.NET Core Runtime allows you to run apps that were made with .NET that didn't provide the runtime. The following commands install the ASP.NET Core Runtime, which is the most compatible runtime for .NET. In your terminal, run the following commands:

apt-get update; \
	apt-get install -y aspnetcore-runtime-3.1

## End Region


## Create Shortcut
ln -s ~/T6_Server/Server/zone ~/T6_Server/Server/Zombie/zone
ln -s ~/T6_Server/Server/zone ~/T6_Server/Server/Multiplayer/zone

chmod +x ~/T6_Server/Plutonium/T6Server.sh
echo "Installation Complete"