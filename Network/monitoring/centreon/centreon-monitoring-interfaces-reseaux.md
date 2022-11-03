# Monitoring des interfaces des équipements réseaux sur Centreon en SNMP

(ça doit aussi fonctionner pour les serveurs qui auraient le service SNMP démarré)



## Prérequis

SNMP utilisable sur les pollers Centreon :
- package **perl-Net-SNMP.noarch** et **perl-Config-IniFiles.noarch** installés
- script **check_centreon_snmp_traffic_nagvis** déployé sur les pollers (script stocké dans git pkg_nagios)

SNMP activé sur les équipements
Host présent sur Centreon, avec sa communauté SNMP et sa version configurées dans les paramètres du host

Le script **check_centreon_snmp_traffic_nagvis** est basé sur le script **check_centreon_snmp_traffic** fourni par Centreon avec les différences suivantes :

l535-536 : décommenter les deux lignes suivantes :
    $in_perfparse_traffic_str =~ s/\./,/g;
    $out_perfparse_traffic_str =~ s/\./,/g;

l554 : remplacer le printf des perfdatas par le suivant :
    printf("|inUsage=$in_usage%%;$warning;$critical outUsage=$out_usage%%;$warning;$critical traffic_in=".$in_perfparse_traffic_str."Bits/s;$warningBit;$criticalBit;0;$speed_card traffic_out=".$out_perfparse_traffic_str."Bits/s;$warningBit;$criticalBit;0;$speed_card\n");

## Commandes de check Centreon

Il existe plusieurs commandes de check pour s'adapter aux différents cas :
- l'interface remonte sa vitesse max (IF-MIB::ifSpeed) (cas général) ou au contraire ne la remonte pas (cas des interfaces OpenVPN sur PFSense, ou possibilité si débit du lien < ifSpeed, pour un accès Internet par exemple)
- l'interface supporte les compteurs SNMP 64 bits (**IF-MIB::ifHCInOctets** et **IF-MIB::ifHCOutOctets**) (cas général) ou non (cas de certains types d'interfaces sur PFSense)
- l'équipement switch expose des valeurs IF-MIB::ifDescr différentes pour chaque interface (cas général) ou non (switches Netgear, pour lesquels on doit se baser sur le IF-MIB::ifName pour choisir l'interface à superviser)

|Commande| Compteurs 64 bits |  Possibilité de set ifSpeed | Choix interface par ifName ou ifDescr |
|--- | --- | --- | ---|
| check_snmp_traffic_nagvis         | Oui               | non                        | ifDescr                               |
| check_snmp_traffic_nagvis_netgear | Oui               | non                        | ifName                                |
| check_snmp_traffic_nagvis_vpn     | Non               | oui                        | ifDescr                               |

Toutes les commandes Centreon se basent sur le même script Perl "check_snmp_traffic_nagvis", il est possible d'en créer d'autres si besoin.
Options utilisées :
-T pour set ifSpeed
--64-bits pour les compteurs en 64 bits
-o ifName pour utiliser ifName pour choisir son interface


## Procédure

avec snmpwalk vérifier le nom exact de l'interface (ça dépend des constructeurs):

`snmpwalk -v 2c -c SNMP_COMMUNITY IP_ADDRESS 1.3.6.1.2.1.2.2.1.2`

ou

`snmpwalk -v 2c -c SNMP_COMMUNITY IP_ADDRESS IF-MIB::ifDescr`


### Exemple TP-Link :

    iso.3.6.1.2.1.2.2.1.2.1 = STRING: "Vlan-interface1"
    iso.3.6.1.2.1.2.2.1.2.100 = STRING: "Vlan-interface100"
    iso.3.6.1.2.1.2.2.1.2.32769 = STRING: "port-channel 1"
    iso.3.6.1.2.1.2.2.1.2.49152 = STRING: "AUX0"
    iso.3.6.1.2.1.2.2.1.2.49153 = STRING: "gigabitEthernet 1/0/1 : copper"
    iso.3.6.1.2.1.2.2.1.2.49154 = STRING: "gigabitEthernet 1/0/2 : copper"
    iso.3.6.1.2.1.2.2.1.2.49155 = STRING: "gigabitEthernet 1/0/3 : copper"
    [...]


### Exemple Netgear :

    IF-MIB::ifDescr.1 = STRING: Ethernet Interface
    IF-MIB::ifDescr.2 = STRING: Ethernet Interface
    IF-MIB::ifDescr.3 = STRING: Ethernet Interface
    IF-MIB::ifDescr.4 = STRING: Ethernet Interface
    IF-MIB::ifDescr.5 = STRING: Ethernet Interface
    IF-MIB::ifDescr.6 = STRING: Ethernet Interface
    IF-MIB::ifDescr.7 = STRING: Ethernet Interface
    [...]

=> Nouvelle recherche avec le ifName pour Netgear :

`snmpwalk -v 2c -c SNMP_COMMUNITY IP_ADDRESS IF-MIB::ifName`

    IF-MIB::ifName.1 = STRING: 1/g1
    IF-MIB::ifName.2 = STRING: 1/g2
    IF-MIB::ifName.3 = STRING: 1/g3
    IF-MIB::ifName.4 = STRING: 1/g4
    IF-MIB::ifName.5 = STRING: 1/g5
    IF-MIB::ifName.6 = STRING: 1/g6
    IF-MIB::ifName.7 = STRING: 1/g7
    [...]


Ajouter un service qui utilise la bonne commande de check (cf plus haut)
Paramètres :
- nom de l'interface (entre "" si il y a un espace dans le nom)
- pourcentage de trafic qui déclenche un warning
- pourcentage de trafic qui déclenche un critical

Générer la configuration Centreon sur les pollers/le central


## Résultats :

Plusieurs cas lors du lancement du script :
- Buffer in creation ... : génération des fichiers cache (dans **/var/lib/centreon/plugins/**), le check devrait passer up et afficher le traffic au prochain poll
- no output from plugin : Centreon n'arrive pas à lancer le script de check, vérifier les modules perl / les permissions Unix / le tester à la main
- Erreur liés aux fichiers temporaires /var/centreon/centplugins/traffic_cache_xxx ou traffic_ifxxx) : vérifier les permissions Unix des fichiers ou les supprimer pour que le script les recrée au prochain poll
- interface must be down / speed 0 : l'équipement ne renvoie pas de valeur "ifSpeed", utiliser une commande qui permet de la set à la main
- le traffic reste à 0 bps / alors qu'il y a du trafic : vérifier le nom de l'interface dans la configuration du service / tenter de lancer le script à la main


## Si besoin de lancer le script à la main

Le lancer en tant que centreon-engine pour éviter les soucis de droits Unix sur les fichiers de cache.
Adapter les options (-T, -o ifName, ...) suivant le type de matériel et d'interface comme indiqué plus haut

`sudo su centreon-engine -`

`/usr/lib/nagios/plugins/check_centreon_snmp_traffic_nagvis -H IP_ADDRESS -v 2 -C SNMP_COMMUNITY --64-bits -no ifName -ri "0/24" -w 80 -c 90`


## Ajout dans NagVis :

Pour ajouter un lien dans Nagvis :
- ouvrir une Weathermap existante ou en créer une nouvelle
- ajouter une shape : **Menu Edit Map => Add Special => Shape**, cliquer sur la map, choisir l'icon et cliquer sur save
- ajouter une autre shape à l'autre extrémité du lien
- ajouter une line : 
Menu **Edit Map => Add Line => Service**
Cliquer sur la map du côté destination (device connecté au device pollé)
Cliquer sur la map du côté source (device dont on polle l'interface)

Dans la boite de dialogue :
- Onglet General : choisir le host et le service centreon
- Onglet Appearance : choisir **view_type = line** et choisir le line_type parmis les 3 suivants :

    `---%---><---%--- `: affiche le pourcentage d'utilisation du lien

    `---BW--><---BW--` : affiche la bande passante utilisée en bps

    `---%+BW><---%+BW `: affiche le pourcentage d'utilisation et la bande passante


Définir les options suivantes :
- line_label_show : yes
- line_label_in : traffic_in
- line_label_out: traffic_out
(Facultatif : **line_label_pos_in** et **line_label_pos_out** pour décaler les labels sur la ligne)
(Facultatif : **line_width** pour rendre un lien en plus gros, pour un LAG par exemple)

Onglet Label : mettre **label_show** à yes permet de mettre un label textuel sur un lien (utile quand il y a plusieurs liens entre deux devices)
Si besoin de ce label alors prévoir le background #FFFFFF, et éventuellement un décalage (+x ou -x dans les champs label_x et label_y)

Cliquer sur save
Si besoin **clic droit => unlock** pour modifier des paramètres ou déplacer les extrémités, puis **clic droit => lock**