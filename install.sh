#!/bin/bash
## Update Region
echo "[1/7] Set last version of your system"
{
apt update && apt upgrade -y
} > /dev/null 2>&1
## End Region

## Firewall Region
echo "[2/7] Install firewall and allow 22 port..."
{
apt install -y ufw fail2ban && \
ufw allow 22/tcp && \
ufw default allow outgoing && \
ufw default deny incoming && \
ufw enable
} > /dev/null 2>&1
## End Region

# Enable 32 bit packages
echo "[3/7] Enable 32 bit packages..."
{
dpkg --add-architecture i386 && \
apt-get update -y && \
apt-get install wget gnupg2 software-properties-common apt-transport-https curl -y
} > /dev/null 2>&1

## Wine Region
echo "[4/7] Installing Wine..."
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
} > /dev/null 2>&1
## End Region

## Pre-Required for IW4MAdmin Region
echo "[5/7] Installing Pre-Required for IW4MAdmin..."
{
#Installation .NET Core 3.1
wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

#Install the SDK
#The .NET SDK allows you to develop apps with .NET. If you install the .NET SDK, you don't need to install the corresponding runtime. To install the .NET SDK, run the following commands:

apt-get update; \
	apt-get install -y dotnet-sdk-3.1
	apt-get install -y dotnet-sdk-6.0

#Install the runtime
#The ASP.NET Core Runtime allows you to run apps that were made with .NET that didn't provide the runtime. The following commands install the ASP.NET Core Runtime, which is the most compatible runtime for .NET. In your terminal, run the following commands:

apt-get update; \
	apt-get install -y aspnetcore-runtime-3.1
	apt-get install -y aspnetcore-runtime-6.0
} > /dev/null 2>&1
## End Region

echo "[6/7] Game Binary Installation"
{
cd ~/T6Server/Plutonium
wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
tar xfv plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
rm plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
chmod +x plutonium-updater
} > /dev/null 

{
echo "[7/7] Installation Complete"
} > /dev/null 