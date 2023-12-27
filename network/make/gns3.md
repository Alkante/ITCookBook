# GNS3
## Prérequis
GNS3 utilise les ISOs des routeurs cisco pour simulé les routeurs, il vous faudra donc chercher sur internet les bonnes ISOs (.bin)
Site : http://srijit.com/working-cisco-ios-gns3/
J'ai utiliser la version 3725 : c3725-adventerprisek9-mz124-15.bin

## Installation
```bash
apt-get install gns3
gns3
```

## Configuration
Edit > Preferences

### FR :
Option "General" > onglet "General Settings" et sélectonnez "Français (fr)"

### Emplacment des ISO:
Option "General" > onglet "General Settings" > "Chemins"
-Projects directory : emplacement pour les futurs projets qui contiendra la topologies des équipements et les configurations
-OS images : Copier votre iso cisco précédement télécharger dans ce dossier

### Associer une ISO à un routeur :
Editer > Images IOS et hyperviseur
Dans "Image binaire" sélectionner votre fichier téléchargé : c3725-adventerprisek9-mz124-15.bin
Décompresser l'image binaire
Puis la platforme: c3700
Modele: 3725
Sauvegarder

### Interconnexion GNS3 et VM virtualbox
- Dans GNS3
Editer > Préférences > VirtualBox
Noter les port utiliser :
VBoxwrapper port: 11525 TCP
Port UDP de base: 20900 UDP

- Dans VirtualBox
Une fois votre VM créée :
Configuration > Réseau
Carte 1 :
-Mode : Accès par pont (utiliser pour le démarrage de la VM via gns3)

Carte 2 :
-Mode : Pilote générique
-Nom : UDPTunnel
-Propriétés de l'interface générique : vous devriez voir apparaitre les champs dest,dport et sport

- Dans GNS3
Editer > Préférences > VirtualBox > VirtualBox Guest
Affecter lui un "nom d'identification"
"Refresh VM List"
Puis séléctionner votre VM dans "VM List"
Sauvegarder

## Utilisation
### Création de votre architecture
Vous retrouvez a gauche les principaux équipements réseaux, routeur, switch , firewall, host
Pour établir vos lien

### Mise en route de larchitecture
Losrque l'on place un routeur celui-ci est éteint, pour le démarrer soit un clique droit dessus "Démarrer" ou alors le symbole "Play" dans la barre du haut qui va démarrer tous les équipements de votre architecture

### Sauvegarde de votre architecture
Sur tous les routeurs vous devez mettre la configuration en cours dans la configuration de démarrage:
Router# copy running-config startup-config
Puis sauvegarder votrre architecture

### Debug
Pour debug votre architecture vous pouvez placer un wireshark sur n'importe quel interface pour cela :
clique droit sur l'équipement capture
Dans la fenetre "Captures" a droite clique droit sur votre interface "start all captures" puis "Démarrer Wireshark"
