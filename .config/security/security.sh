#!/bin/bash

# Security configuration for T6 servers based on Plutonium.pw specifications
setupSecurityConfig() {
    cat > "$WORKDIR/Server/Multiplayer/t6/data/security.json" << EOF
{
    "sv_kickBareGUID": true,
    "sv_requiresteam": true,
    "sv_steamRequired": true,
    "sv_securityLevel": 23,
    "sv_disableGameContent": false,
    "sv_allowDof": true,
    "sv_allowAimAssist": true,
    "sv_enforceDLC": false,
    "sv_allowDlc": 4,
    "sv_voiceQuality": 5,
    "sv_floodProtect": 4,
    "sv_maxPing": 800,
    "sv_maxRate": 25000,
    "sv_minPing": 0,
    "sv_pure": true,
    "sv_maxclients": 18,
    "sv_timeout": 240,
    "sv_zombies": false,
    "sv_hostname": "Plutonium T6 Server",
    "sv_privateClients": 0,
    "sv_privatePassword": "",
    "sv_voice": true,
    "sv_voiceCodec": "speex"
}
EOF
}