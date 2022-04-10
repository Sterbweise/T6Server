# LinuxT6Server
All files needed for a simple installation and configuration of a T6 server on linux (Debian 10)
![alt text](https://img.shields.io/badge/python-3-blue?logo=python)
![alt text](https://img.shields.io/badge/pypi%20package-22.0.4-green)

<img src="https://www.uca.fr/medias/photo/logo-uca-long-300dpi_1493730258077-png" alt="drawing" width="350"/>
<img src="https://stid.iut-clermont.fr/wp-content/uploads/sites/11/2019/04/Logo-Normal-700x381.png" alt="drawing" width="130"/>

# IRC Project
**L'Objectif été de créer un Serveur et un Client IRC**

## Installation
1. Télécharger les fichiers présents sur le gits : <pre>git clone https://gitlab.iut-clermont.uca.fr/kichandeze/IRC-Project.git</pre>
2. Déplacez-vous dans le Dossier `IRC Project`.
3. Lancer le Script Python `Server.py` pour démarrer le serveur.<br>
   <pre>python3 server.py</pre>
   _Toutefois si vous êtes sur **Linux**, il peut arriver que le fichier ne soit pas executable._<br> <pre>sudo chmod +x server.py
   python3 server.py</pre>
4. Ensuite lancer un ou plusieurs clients.
    <pre>python3 client.py</pre>
   _Rentrer votre pseudo et le client va se connecter automatiquement au serveur._
   <br><br>
5. **Testez**

## Commandes
<pre>
Commandes Principales du Serveur

    !info : Obtenir les informations du serveur.
    !ping : Testez votre connection.
    !whoami : Obtenir vos information de connection.
    !online : Nombre de client connecter.
    !channel [-option] [channel] : Commande channel
    !nickname: Pour Changer de Pseudo.
</pre>

<pre>
Commandes de Gestions de Salon

    -create : Crée un channel.
    Exemple: !channel -create [Nom] [Mot de Passe] [Nombre d'utilisateurs Max]
    
    -join : Pour rejoindre un channel.
    -list : Liste des Channels
    -info : Pour obtenir les information du channel.
    -delete : Supprimer le channel (Owner Uniquement).
</pre>