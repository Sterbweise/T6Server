FROM debian:bullseye-slim

# Métadonnées du projet
LABEL maintainer="Sterbweise"
LABEL description="Plutonium T6 Server Docker Container"

# Variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive
ENV T6_INSTALL_DIR=/opt/T6Server

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    git \
    unzip \
    ca-certificates \
    curl \
    software-properties-common \
    wine \
    wine64 \
    winetricks \
    && rm -rf /var/lib/apt/lists/*

# Créer le répertoire d'installation
RUN mkdir -p ${T6_INSTALL_DIR}
WORKDIR ${T6_INSTALL_DIR}

# Copier les scripts d'installation
COPY install.sh ${T6_INSTALL_DIR}/install.sh
COPY uninstall.sh ${T6_INSTALL_DIR}/uninstall.sh
COPY T6Server.sh ${T6_INSTALL_DIR}/T6Server.sh

# Rendre les scripts exécutables
RUN chmod +x ${T6_INSTALL_DIR}/install.sh
RUN chmod +x ${T6_INSTALL_DIR}/uninstall.sh
RUN chmod +x ${T6_INSTALL_DIR}/T6Server.sh

# Script d'entrée Docker
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Exposer le port du serveur
EXPOSE 21889/udp

# Point d'entrée
ENTRYPOINT ["/docker-entrypoint.sh"]