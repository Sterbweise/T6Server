# T6 Operator - Plutonium Black Ops II Server Management Suite

![Version](https://img.shields.io/badge/Version-2.1.0-blue)
![Debian](https://img.shields.io/badge/Debian-10%20%7C%2011%20%7C%2012-brightgreen?logo=Debian)
![Plutonium T6](https://img.shields.io/badge/Plutonium-T6-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)
![GitHub repo size](https://img.shields.io/github/repo-size/Sterbweise/T6-Operator)
![GitHub stars](https://img.shields.io/github/stars/Sterbweise/T6-Operator)
![GitHub forks](https://img.shields.io/github/forks/Sterbweise/T6-Operator)
![GitHub issues](https://img.shields.io/github/issues/Sterbweise/T6-Operator)
![GitHub last commit](https://img.shields.io/github/last-commit/Sterbweise/T6-Operator)

<img src="https://imgur.com/bBrx8Hf.png" alt="Plutonium Logo" width="350"/>

T6 Operator is a comprehensive management suite for setting up and running Plutonium Call of Duty: Black Ops II servers on Debian-based systems. This project aims to simplify the process of installing, configuring, and managing T6 servers, making it accessible to both beginners and experienced server administrators.

## Table of Contents

- [T6 Operator - Plutonium Black Ops II Server Management Suite](#t6-operator---plutonium-black-ops-ii-server-management-suite)
  - [Table of Contents](#table-of-contents)
  - [🚀 Features](#-features)
  - [📋 Prerequisites](#-prerequisites)
  - [🛠️ Installation](#️-installation)
  - [⚙️ Configuration](#️-configuration)
  - [🚀 Launching the Server](#-launching-the-server)
  - [🛠️ Troubleshooting](#️-troubleshooting)
    - [Wine Display Errors](#wine-display-errors)
    - [Unable to Load Import from binkw32.dll](#unable-to-load-import-from-binkw32dll)
    - [Server Not Appearing in Plutonium Server List](#server-not-appearing-in-plutonium-server-list)
    - [Authentication Issues](#authentication-issues)
  - [📚 Documentation](#-documentation)
  - [🤝 Contributing](#-contributing)
  - [📄 License](#-license)
  - [🙏 Acknowledgements](#-acknowledgements)
  - [📞 Support](#-support)

## 🚀 Features

- Easy installation process
- Automated system updates and dependency management
- Firewall configuration with UFW
- Wine installation for running Windows applications
- .NET installation for IW4MAdmin support
- Localization support (English and French)
- Server binary installation and configuration
- User-friendly command-line interface

## 📋 Prerequisites

- Debian 10, 11, or 12 (64-bit)
- Root or sudo access
- Internet connection

## 🛠️ Installation

1. Navigate to the /opt directory:
   ```bash
   cd /opt
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/Sterbweise/T6Server.git
   ```

3. Navigate to the T6Server directory:
   ```bash
   cd T6Server
   ```

4. Make the installation script executable:
   ```bash
   chmod +x install.sh
   ```

5. Run the installation script:
   ```bash
   sudo ./install.sh
   ```

5. Follow the on-screen instructions to complete the installation. The script will guide you through:
   - Language selection
   - UFW firewall installation and configuration
   - SSH port configuration
   - .NET installation (optional, required for IW4MAdmin)
   - Wine installation
   - Game binary installation

## ⚙️ Configuration

After installation, you can configure your server by modifying the following files:

- `/opt/T6Server/Server/Multiplayer/server.cfg`: Main server configuration
  - `sv_hostname`: Your server's name
  - `sv_maxclients`: Maximum number of players
  - `g_password`: Server password (if desired)
  - `sv_privateClients`: Number of private slots
  - `sv_privatePassword`: Password for private slots

- `/opt/T6Server/Server/Multiplayer/playlists.cfg`: Playlist settings
  - Define your map rotations and game modes here

- `/opt/T6Server/Server/Multiplayer/t6r/data/gamesettings/`: Game mode-specific settings
  - Each file in this directory corresponds to a specific game mode
  - Modify these files to adjust game rules, score limits, etc.

For more advanced configuration:

- Modify the `T6Server.sh` file to adjust server launch parameters
- Configure IW4MAdmin if you've installed it (refer to IW4MAdmin documentation for details)

## 🚀 Launching the Server

1. Navigate to the T6Server directory:
   ```bash
   cd /opt/T6Server
   ```

2. Make the start script executable:
   ```bash
   chmod +x T6Server.sh
   ```

3. Start the server:
   ```bash
   ./T6Server.sh
   ```

For running multiple servers or background operation, consider using `tmux` or `screen`.

## 🛠️ Troubleshooting

### Wine Display Errors
- Issue: Error messages related to Wine display.
- Solution: These errors can be safely ignored, as the Plutonium server doesn't require graphical support.

### Unable to Load Import from binkw32.dll
- Issue: Error when loading binkw32.dll.
- Solution: 
  1. Check the `PAT` variable in `T6Server.sh`.
  2. Ensure file permissions are correct:
     ```bash
     chmod -R 755 /opt/T6Server
     ```

### Server Not Appearing in Plutonium Server List
- Issue: Your server is not visible to players.
- Solution:
  1. Verify that the server port (default: 4976) is open for UDP traffic.
  2. Properly configure your firewall:
     ```bash
     sudo ufw allow 4976/udp comment Plutonium-Server
     ```
  3. Check router configuration if behind NAT.

### Authentication Issues
- Issue: Authentication errors when starting the server.
- Solution:
  1. Verify the validity of your Plutonium key.
  2. Ensure the key is correctly placed in configuration files.
  3. Reinstall game binaries if the issue persists.

## 📚 Documentation

For more detailed information on server configuration, configuration options, and advanced features, please refer to our [Wiki](https://github.com/Sterbweise/T6Operator/wiki).

## 🤝 Contributing

Contributions are welcome! Feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- [Plutonium](https://plutonium.pw): For their amazing work on the T6 client and server
- [IW4MAdmin](https://github.com/RaidMax/IW4M-Admin): For powerful administration tools
- [plutonium-updater](https://github.com/mxve/plutonium-updater.rs): For keeping servers up-to-date

## 📞 Support

For support, you can contact me through the following channels:

- Email: [contact@sterbweise.dev](mailto:contact@sterbweise.dev)
- Telegram: [@SG991](https://t.me/SG991)

You can also open an issue on this repository for bug reports or feature requests.

---

Made with ❤️ by [Sterbweise](https://github.com/Sterbweise)
