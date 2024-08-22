#!/bin/bash

# fr.sh - Fichier de langue française pour le serveur Plutonium Call of Duty: Black Ops II
# Version: 2.1.0
# Auteur: Sterbweise
# Dernière mise à jour: 21/08/2024

# Description:
# Ce script contient toutes les chaînes de caractères en français utilisées dans les scripts
# d'installation, de gestion et de désinstallation du serveur Plutonium Call of Duty: Black Ops II.
# Il fournit un support de localisation pour les utilisateurs francophones.

# Utilisation:
# Ce fichier est sourcé par d'autres scripts pour fournir une sortie de texte localisée.
# Il ne doit pas être exécuté directement.

# Note: Assurez-vous que ce fichier se trouve dans le répertoire .config/lang/ par rapport aux scripts principaux.

# Messages d'installation
# Ces messages sont affichés pendant le processus d'installation du serveur

select_language_fr="Sélectionnez votre langue :"
firewall_fr="Voulez-vous installer le pare-feu UFW (O/n) ?"
ssh_port_fr="Entrez le port SSH à ouvrir (par défaut : 22) :"
dotnet_fr="Voulez-vous installer Dotnet [Requis pour IW4Madmin] (O/n) ?"
dotnet_failed_install_fr="L'installation de .NET a échoué"
update_fr="Mise à jour du système"
firewall_install_fr="Installation du pare-feu et ouverture des ports."
bit_fr="Activation des paquets 32 bits"
wine_fr="Installation de Wine."
dotnet_install_fr="Installation de Dotnet."
binary_fr="Installation des fichiers binaires."
finish_fr="Installation terminée."
quit_fr="Appuyez sur CTRL+C pour quitter."

# Messages de désinstallation
# Ces messages sont affichés pendant le processus de désinstallation du serveur

confirm_uninstall_fr="Êtes-vous sûr de vouloir désinstaller ? Cela supprimera tous les composants installés par le script de configuration."
confirm_prompt_fr="Tapez 'o' pour confirmer : "
uninstall_cancelled_fr="Désinstallation annulée."
uninstall_binary_fr="Désinstallation des fichiers binaires du jeu."
uninstall_dotnet_fr="Désinstallation de Dotnet."
uninstall_wine_fr="Désinstallation de Wine."
remove_firewall_fr="Suppression du pare-feu."
cleanup_fr="Nettoyage."
uninstall_finish_fr="Désinstallation terminée."

# Note: Chaque variable contient un message spécifique utilisé à différentes étapes
# des processus d'installation et de désinstallation. Ces messages sont conçus pour
# guider l'utilisateur tout au long du processus et fournir des informations claires
# sur les actions en cours d'exécution.