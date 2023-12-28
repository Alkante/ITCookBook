# Preseed et Kickstart


## Contexte

Les versions
- Live : Version bootable sans installation sur CD, usb, ... . Elle permet de tester l'os sans l'installer
- Live persistante : Comme Live mais elle garde les modifications. Cette version ne peut être utiliser avec un CD ou DVD, ce type de support ne permet pas l'enregistrement.
- install ext : Installation en mode text
- OEM : Installation standard avec destruction des comptes au redémarrage puis demande d'ajout d'utilisateur/password pour la première utilisation.


Vocubulaire :
- vesamenu.c32 : Afficheur de menu standard grub (avec image) écrit sous forme d'exécutable 32 bits.
- *linux.cfg (isolinux.cfg, pxelinux.cfg/setup.conf, ...) : Configuration des entrées du menu (spécifie l'utilisation du vesamenu)

Liste preseed:
- debian : https://preseed.einval.com/debian-preseed/

## Important
Un preseed peux-être utilisé avec n'importe qu'elle type d'installation, cependant, un kickstart ne fonctionne pas avec les version Live CD.


| Distribution | pressed | Verison non live disponible | kickstart |
|------------- |-------- |---------------------------- |---------- |
| Debian       | oui | oui        | non  |
| Ubuntu       | oui | oui        | oui  |
| LinuxMint    | oui | non        | non* |
| Centos       | oui | oui        |  oui |

*: non car il n'y a pas de version non live disponible

**Problème 1** :
Les versions LIVE CD/DVD ne peuvent pas utiliser les kickstarts.
Pour les versions de type ubuntu et dérivé, c'est le logiciel ubiquity qui prend le pas en mode interface graphique (et non texte)

**Solution 1** :
démarrer sur ubiquity via la commande de boot

**Problème 2** :
ubiquity surcharge quelques options du preseed sans pour autant les prendre dans le pressed fourni.

**Solution 2** :
Repasser en argument les quelques options de ubiquity directement dans la ligne de boot
C'est redondant mais cela fonctionne.


### Ubiquity preseed
Il y a deux façon de faire :
- Le mode url : ```url=http://my.server.com/preseed.cfg```
- le mode fichier (sur l'iso) : ```file=/cdrom/preseed.cfg```


### Ubiquity mode

| Opions | Description |
|------- |------------ |
| preseed/early_command=/path/to/script.sh | exécution d'une script avant l'installation |
| debug-ubiquity | Pass -d to ubiquity which enables debug mode. Communication with debconf is written to /var/log/installer/debug. |
| automatic-ubiquity | Pass --automatic to ubiquity which enables automatic mode. Questions that have been marked seen will be skipped and pages of the interface that ask no questions (because they are all skipped) will not be shown. Implies only-ubiquity (see below). |
| only-ubiquity | Run ubiquity in a stripped down environment (no GNOME). |
| noninteractive | Run ubiquity with the noninteractive frontend on VT1, do not start X. |
| automatic-oem-config | Run --automatic to oem-config which enables automatic end-user configuration. Questions that have been marked seen will be skipped and pages of the interface that ask no questions (because they are all skipped) will not be shown. This is only useful for automatic testing. |



### Ubiquity options

| Opions | Description |
|------- |------------ |
| ubiquity/summary | preseed empty to avoid the summary page.
| ubiquity/reboot  | automatically reboot when the installer completes. Be sure to add 'noprompt' to the kernel command line to also skip the "please remove the disc, close the tray (if any) and press ENTER to continue" usplash prompt. |
| ubiquity/failure_command |specify a command to be run should the install fail |
| ubiquity/success_command | similar to preseed/late_command. Specify a command to be run when the install completes successfully (runs outside of /target, but /target is mounted when the command is invoked).|
| languagechooser/language-name | choose among the available languages, eg English |
| countrychooser/shortlist | choose a country, territory or area, eg US |
| localechooser/supported-locales | choose other locales to be supported, eg en_US.UTF-8 |

Exemple de boot avec :
- CD/DVD live utilisant ubiquity
- Automatisé le lancement de ubiquity
- Passer les paramètres de ubiquity (options pressed surchargées)
- Indiquer un preseed à utiliser pour l'instalation

```conf
label unattented
  menu label ^Unattented install Linux Mint
  kernel /casper/vmlinuz
	append file=/cdrom/preseed/unattended.seed auto=true priority=critical ubiquity/reboot=true languagechooser/language-name=French countrychooser/shortlist=FR localechooser/supported-locales=fr_FR.UTF-8 boot=casper automatic-ubiquity initrd=/casper/initrd.lz quiet splash noprompt noshell --
  menu default
```


## Kickstart

### Interface graphique

```bash
apt-get install system-config-kickstart
```

```bash
system-config-kickstart
```


## Configurer boot

Editer ```isolinux/isolinux.cfg```

Les parametres utilisés
| Paramètre | Description|
|--- |--- |
| label MYLABEL | Label du menu |
| menu label ^MYTITLE | Définition du titre |
| kernel MYKERNEL | Définition du noyaux à utilisé |
| append MYOPTIONS | Définition de la mémoire initiale d'exécution ses options |





Désactiver le menu default
```bash
sed -i 's/^\s*menu\s*default.*$//' /isolinux/isolinux.cfg
```

Ajouter l'entrer en mode standard

```conf
label unattented
  menu label Unattented install Linux Mint
  kernel /casper/vmlinuz
  append  file=/cdrom/preseed/linuxmint.seed ks=/cdrom/ks.cfg boot=casper initrd=/casper/initrd.lz quiet splash --
menu default
```


default menu.c32
prompt 0
menu title mint automated install
timeout 600

label mintdefault
menu label seperate home partition
kernel /ubnkern
append initrd=/ubninit file=/cdrom/preseed/mint_seperatehome.seed boot=casper automatic-ubiquity quiet splash --

label mint1
menu label Everything in one partition
kernel /ubnkern
append initrd=/ubninit file=/cdrom/preseed/mint_allinone.seed boot=casper automatic-ubiquity quiet splash --



```conf
label linux
  menu label ^Install or upgrade an existing system
  menu default
  kernel vmlinuz
  append initrd=initrd.img ks=cdrom:/ks.cfg
```



```conf
label linux
  menu label ^Install or upgrade an existing system
  menu default
  kernel vmlinuz
  append initrd=initrd.img ks=cdrom:/ks.cfg
```
