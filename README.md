
![alt text](https://img.shields.io/badge/Debian-10-red?logo=Debian)
![alt text](https://img.shields.io/badge/Plutonium-T6-blue)

<img src="https://imgur.com/bBrx8Hf.png" alt="drawing" width="350"/> <img src="https://i.imgur.com/TdpsBgH.png" alt="drawing" width="200"/>

# T6Server
All files needed for a simple installation and configuration of a T6 server on linux.

## Installation
1. Download files : <pre>git clone https://github.com/Minami-xan/T6Server.git </pre>
2. Move to `T6Server` Folder. <pre>cd ~/T6Server/</pre>
3. Run the Installation Script `install.sh` . <pre>sudo bash install.sh</pre>
4. Create shortcut for `zone` file. <pre>ln -s ~/T6Server/Server/zone ~/T6Server/Server/Zombie/zone
ln -s ~/T6Server/Server/zone ~/T6Server/Server/Multiplayer/zone</pre>
5. Make file executable `T6Server.sh`. <pre>chmod +x ~/T6Server/Plutonium/T6Server.sh</pre>
**Installation Complete**

## Configuration
1. Move to `Plutonium` Folder. <pre>cd ~/T6Server/Plutonium/</pre>
2. Edit `T6Server.sh` with your information. <pre>nano T6Server.sh</pre>
3. Allow server port. <pre>sudo bash ~/T6Server/Configuration/allow_port.sh</pre>
**Configuration Complete**

## Launch Server
1. Launch Server. <pre>sudo bash ~/T6Server/Plutonium/T6Server.sh</pre>
   I advise you to use `tmux` or `screen` to open and manage multiple servers.


## Source
• **Topic by me:** https://forum.plutonium.pw/topic/12870/guide-debian-t6-server-on-linux-vps-dedicated-server <br>
• **Plutonium:** https://plutonium.pw <br>
• **IW4MAdmin by RaidMax:** https://github.com/RaidMax/IW4M-Admin <br>
• **Plutonium-Updater by mxbe:** https://github.com/mxve/plutonium-updater.rs <br>