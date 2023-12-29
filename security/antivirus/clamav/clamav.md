# Clamav

<!-- TOC -->

- [Clamav](#clamav)
  - [Modes](#modes)
  - [Instalation](#instalation)
  - [Commandes usuelles](#commandes-usuelles)
  - [Service installation](#service-installation)
    - [Configurer](#configurer)
    - [Check via cron et envoie d'email](#check-via-cron-et-envoie-demail)
    - [Tester](#tester)

<!-- /TOC -->


## Modes

## Instalation
For manual usage
```bash
apt-get install clamav
```

For automatique usage (daemon )
```bash
apt-get install clamav-daemon
```

Both install ```clamav-freshclam``` dependancies.

(optional) install GUI with ```clamtk``` package.

## Commandes usuelles
En tant que root :
| Commande | Description |
|--------- |------------ |
| ```freshclam ```| Mise à jour des descriptions des antivirus |
| ```clamscan -r /``` | Balayer les fichiers et sous fichier du repertoire **/** |
| ```clamscan --bell -r -i --log=/var/log/clamav/virus.log /mnt/D/```| Scanner la partition fat32 /mnt/D, activer la sonnerie et écrire les virus dans le fichier de log |


## Service installation

```bash
apt-get update && apt-get install clamav clamav-freshclam heirloom-mailx
service clamav-freshclam start
```

### Configurer
```bash
vim /etc/clamav/freshclam.conf
```
| Options | Description |
|-------- |------------ |
| ```Checks 24``` | 24 update de la base anti viral par jour |

Update manuel de la base anti viral
```bash
freshclam -v
```


### Check via cron et envoie d'email
Activer le scan via cron et la notification par email :
```bash
vim /root/clamscan_daily.sh
```

```
#!/bin/bash
LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log";
EMAIL_MSG="Please see the log file attached.";
EMAIL_FROM="clamav-daily@example.com";
EMAIL_TO="username@example.com";
DIRTOSCAN="/var/www /var/vmail";

for S in ${DIRTOSCAN}; do
 DIRSIZE=$(du -sh "$S" 2>/dev/null | cut -f1);

 echo "Starting a daily scan of "$S" directory.
 Amount of data to be scanned is "$DIRSIZE".";

 clamscan -ri "$S" >> "$LOGFILE";

 # get the value of "Infected lines"
 MALWARE=$(tail "$LOGFILE"|grep Infected|cut -d" " -f3);

 # if the value is not equal to zero, send an email with the log file attached
 if [ "$MALWARE" -ne "0" ];then
 # using heirloom-mailx below
 echo "$EMAIL_MSG"|mail -a "$LOGFILE" -s "Malware Found" -r "$EMAIL_FROM" "$EMAIL_TO";
 fi 
done

exit 0
```

```bash

chmod 0755 /root/clamscan_daily.sh
ln /root/clamscan_daily.sh /etc/cron.daily/clamscan_daily
```



### Tester

```bash
/root/clamscan_daily.sh
```