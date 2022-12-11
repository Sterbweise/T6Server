

![alt text](https://img.shields.io/badge/Debian-10-red?logo=Debian)
![alt text](https://img.shields.io/badge/Debian-11-green?logo=Debian)
![alt text](https://img.shields.io/badge/Plutonium-T6-blue)

<img src="https://imgur.com/bBrx8Hf.png" alt="drawing" width="350"/>

# T6Server
All files needed for a simple installation and configuration of a T6 server on Debian.

📌 [Installation for Arch Linux](https://github.com/xr4zz/T6Server)

## Installation
1. Download files : 
   ```shell
   git clone https://github.com/Minami-xan/T6Server.git
   ```
2. Move to `T6Server` Folder. <pre>cd ~/T6Server/</pre>
3. Run the Installation Script `install.sh` . <pre>sudo env "HOME=$HOME" bash install.sh</pre>
4. **Installation Complete**

## Configuration
1. Move to `Plutonium` Folder. <pre>cd ~/T6Server/Plutonium/</pre>
2. Edit `T6Server.sh` with your information. <pre>nano T6Server.sh</pre>
3. Allow server port. <pre>sudo bash ~/T6Server/Scripts/allow_port.sh</pre>
**Configuration Complete**

## Launch Server
1. Move to `Plutonium` Folder. <pre>cd ~/T6Server/Plutonium</pre>
2. Launch Server. <pre>./T6Server.sh</pre>
   I advise you to use `tmux` or `screen` to open and manage multiple servers.

## Issues
### Wine display errors
   + Don't care of these errors, plutonium server doesn't have graphic support.

### Unable to load import '_BinkWaitStopAsyncThread@4' from module 'binkw32.dll'
   + Check your PAT variable in ./T6Server.sh. (It will be ping binkw32.dll dir)
   + Make sure to your user can read the file in all sub-dir of T6Server.

### Server don't appear in Plutonium Servers List
   + Check if your server port is open with UDP protocol. (Example: 4976)

### Connection with nix socket lost
   + Check your plutonium key validity
   + Check if your plutonium key are correctly write in T6Server.sh

### [DW][Auth] Handling authentication request
   + Check your plutonium key validity
   + Check if your plutonium key are correctly write in T6Server.sh

## Source
• **Topic by me:** https://forum.plutonium.pw/topic/12870/guide-debian-t6-server-on-linux-vps-dedicated-server <br>
• **Plutonium:** https://plutonium.pw <br>
• **IW4MAdmin by RaidMax:** https://github.com/RaidMax/IW4M-Admin <br>
• **Plutonium-Updater by mxbe:** https://github.com/mxve/plutonium-updater.rs <br>
