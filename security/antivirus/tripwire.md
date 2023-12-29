# Tripwire

Tripwire est un logiciel de contrôle d'intégrité, permettant de s'assurer que les fichiers sensibles sur un ordinateur ne sont pas modifiés

<!-- TOC -->

- [Tripwire](#tripwire)
    - [Install](#install)
- [Flow d'utilisation](#flow-dutilisation)
    - [Installation et configuration](#installation-et-configuration)
    - [Initialisation](#initialisation)
    - [Check](#check)

<!-- /TOC -->


## Install
```bash
apt-get install Tripwire
```

Configurer le fichier /etc/tripwire/twpol.txt
| Var          | Description  | Régles utilisées |
|------------- |------------ |------------ |
| $(Device)  | Device ex: /dev| +pugs-intldamcCMSH |
| $(Dynamic) | fichiers qui ne changent pas souvent mais sont accédés souvent (les fichiers de conf)|  +pinugtd-sacmbCMSH |
| $(Growing) | fichiers qui grossissent, mais qui ne doivent pas changer de propriétaire (les logs)|  +pinugtdl-sacmbCMSH |
| $(IgnoreAll) | ignore tout | -pinusgslamctdbCMSH |
| $(IgnoreNone) | Tout vérifier | +pinusgsamctdbCMSH-l |
| $(ReadOnly) | fichier en lecture seule (les binaires par exemple) | +pinugsmtdbCM-acSH |


| Régle | La vérification effectuée |
|------ |-------------------------- |
| p | Permission sur le fichier ou répertoire |
| i | Inode |
| n | Nombre de liens |
| u | id du propriétaire |
| g | id du groupe |
| t | type de fichier |
| s | taille du fichier |
| l | Autorise la taille du fichier à augmenter |
| d | device number du disque où est le fichier |
| b | Nombre de blocs alloués |
| a | heure du dernier accès |
| m | heure de la modification du fichier |
| c | heure de modification de l'inode |
| C | CRC 32 du fichier |
| M | MD5 du fichier |
| S | SHA du fichier |
| H | Haval (signature 128 bits) du fichier |





# Flow d'utilisation

```text
Installer    
Configurer
```

## Installation et configuration

```bash
apt-get install tripwire
dpkg-reconfigure tripwire
```
Yes pour la création de la clef du site
Yes pour la création de la clef local
Vous aurrez **site.key**, **test-local.key**


Modifier les fichier **twcfg.txt** et **twpol.txt**


## Initialisation
```bash
tripwire --init
```


## Check
```bash
tripwire --check
```
