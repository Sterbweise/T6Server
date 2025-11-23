#!/bin/bash
set -euo pipefail

# Chemin du répertoire d'installation
T6_INSTALL_DIR="/opt/T6Server"

# Fonction de log
log() {
    echo "[T6 Server Docker] $1"
}

# Vérifier si les variables d'environnement sont définies
if [[ -z "${SERVER_NAME:-}" ]]; then
    log "AVERTISSEMENT : SERVER_NAME non défini, utilisation du nom par défaut"
    export SERVER_NAME="Serveur Docker T6"
fi

if [[ -z "${SERVER_KEY:-}" ]]; then
    log "ERREUR : SERVER_KEY est requis"
    exit 1
fi

# Modifier le script T6Server.sh avec les variables d'environnement
sed -i "s/readonly SERVER_NAME=.*/readonly SERVER_NAME=\"${SERVER_NAME}\"/" ${T6_INSTALL_DIR}/T6Server.sh
sed -i "s/readonly SERVER_KEY=.*/readonly SERVER_KEY=\"${SERVER_KEY}\"/" ${T6_INSTALL_DIR}/T6Server.sh

# Options supplémentaires si définies
if [[ -n "${SERVER_PORT:-}" ]]; then
    sed -i "s/readonly SERVER_PORT=.*/readonly SERVER_PORT=${SERVER_PORT}/" ${T6_INSTALL_DIR}/T6Server.sh
fi

if [[ -n "${GAME_MODE:-}" ]]; then
    sed -i "s/readonly GAME_MODE=.*/readonly GAME_MODE=\"${GAME_MODE}\"/" ${T6_INSTALL_DIR}/T6Server.sh
fi

# Lancer l'installation
log "Lancement de l'installation du serveur T6"
cd ${T6_INSTALL_DIR}
sudo bash install.sh --non-interactive

# Démarrer le serveur
log "Démarrage du serveur T6"
exec sudo bash T6Server.sh