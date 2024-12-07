#!/bin/bash

# Configuration de sécurité pour les serveurs T6
setupSecurityConfig() {
    cat > "$WORKDIR/Server/Multiplayer/t6/data/security.json" << EOF
{
    "sv_kickBareGUID": true,
    "sv_requiresteam": true,
    "sv_steamRequired": true,
    "sv_securityLevel": 23,
    "sv_disableGameContent": false,
    "sv_allowDof": true,
    "sv_allowAimAssist": true
}
EOF
} 