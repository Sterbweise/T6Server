FROM debian:bullseye-slim

# Install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Copy the entire T6Server project into the container
COPY . /opt/T6Server

WORKDIR /opt/T6Server

# Debug: Listez le contenu du répertoire pour vérifier l'emplacement du script
RUN ls -la .config/utility/dev/

# Copiez explicitement le script
COPY .config/utility/dev/testsValidation.sh /opt/T6Server/testsValidation.sh

# Make sure scripts are executable
RUN chmod +x /opt/T6Server/testsValidation.sh

# Utilisez bash pour exécuter le script
CMD ["/bin/bash", "./testsValidation.sh"]