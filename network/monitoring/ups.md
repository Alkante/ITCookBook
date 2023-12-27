# Manage UPS with nut
(Voir le markdown dans Atom Ctrl+shift+m)

Super tuto pour apprendre à gérer le service nut :
- https://wiki.debian-fr.xyz/Configurer_et_surveiller_un_onduleur_avec_NUT

En cas d'ajout d'un UPS :
- Créer une entrée DNS "upsXX.exemple.fr" qui pointe vers le serveur branché
```
# Exemple sur dns1
samba-tool dns add dns1.exemple.fr exemple.fr ups01 CNAME phy01.exemple.fr
```

<details>
  <summary>Debian SERVEUR (Pour le serveur branché sur l'UPS)</summary>

## Debian (Pour le serveur branché sur l'UPS)
### Package
Install package
```
apt install -y nut
```

### Get info about UPS
Vérifier si l'ups bien détecté et voir le modéle :
```
dmesg|grep usb
# ...
#[1636240.083617] usb 1-2: Product: Eaton 5P
#[1636240.085651] usb 1-2: Manufacturer: EATON
```

Dans /usr/share/nut/driver.list vérifier le driver compatible avec notre ups
```
# Format:
# =======
# <manufacturer>        <device type>   <support level> <model name>    <model extra>   <driver [parameters]>
"Eaton"                 "ups"           "5"             "5P"             "USB port"     "usbhid-ups"
```

Autoriser l'accès au port usb (car monté par défaut uniquement pour root)
```
lsusb|grep UPS
#Bus 001 Device 003: ID 0463:ffff MGE UPS Systems UPS

chown root:nut /dev/bus/usb/001/003
#crw-rw-r-- 1 root nut 189, 2 oct.  17 07:00 /dev/bus/usb/001/003
```

### Configure
Backup des fichiers
```
cp /etc/nut/upsmon.conf /etc/nut/upsmon.conf.backup
cp /etc/nut/nut.conf /etc/nut/nut.conf.backup
cp /etc/nut/ups.conf /etc/nut/ups.conf.backup
cp /etc/nut/upsd.conf /etc/nut/upsd.conf.backup
cp /etc/nut/upsd.users /etc/nut/upsd.users.backup
cp /etc/nut/upssched.conf /etc/nut/upssched.conf.backup
```

#### Fichier /etc/nut/ups.conf
```
echo "maxretry = 3

[eaton]
driver = usbhid-ups
port = auto
desc = 'Eaton ups'" > /etc/nut/ups.conf
```

Test connexion
```
upsdrvctl start
```

Exemple de sortie si ok
```
Network UPS Tools - UPS driver controller 2.7.4
Network UPS Tools - Generic HID driver 0.41 (2.7.4)
USB communication driver 0.33
Using subdriver: MGE HID 1.39
```

#### Fichier /etc/nut/nut.conf
```
echo "MODE=netserver" > /etc/nut/nut.conf
```

#### Fichier /etc/nut/upsd.conf
```
echo "LISTEN 0.0.0.0 3493
ACL all 0.0.0.0/0
ACL localhost 127.0.0.1/32
ACL localnet 192.168.0.0/19
ACL localnet 192.168.32.0/19
ACCEPT localhost
ACCEPT localnet
REJECT all" > /etc/nut/upsd.conf
```

#### Fichier /etc/nut/upsd.users
```
echo "[admin]
password = passwordXXXX
allowfrom = localhost
upsmon master
actions = SET
instcmds = ALL

[user]
    password = passwordYYYY
    allowfrom = localnet
    upsmon slave" > /etc/nut/upsd.users
```

#### Fichier /etc/nut/upsmon.conf
```
echo "MONITOR eaton@ups01.exemple.fr 1 admin passwordXXXX master
SHUTDOWNCMD "/sbin/shutdown -h now"
HOSTSYNC 15
POWERDOWNFLAG /etc/nut/killpower
FINALDELAY 5
NOTIFYCMD /sbin/upssched
NOTIFYMSG ONBATT "%s is on battery"
NOTIFYMSG ONLINE "%s is back online"
NOTIFYMSG LOWBATT "%s has a low battery!"
NOTIFYMSG SHUTDOWN "System is being shutdown!"

NOTIFYFLAG ONLINE SYSLOG+EXEC
NOTIFYFLAG ONBATT SYSLOG+EXEC
NOTIFYFLAG LOWBATT SYSLOG+EXEC
NOTIFYFLAG FSD SYSLOG+WALL+EXEC
NOTIFYFLAG COMMOK SYSLOG+EXEC
NOTIFYFLAG COMMBAD SYSLOG+EXEC
NOTIFYFLAG SHUTDOWN SYSLOG+EXEC
NOTIFYFLAG REPLBATT SYSLOG+EXEC
NOTIFYFLAG NOCOMM SYSLOG+EXEC" > /etc/nut/upsmon.conf
```

#### Fichier /etc/nut/upssched.conf
```
echo "LOCKFN /var/lib/nut/upssched.lock
PIPEFN /var/lib/nut/upssched.pipe
CMDSCRIPT /bin/upssched-cmd
AT ONBATT * START-TIMER onbatt1 13
AT ONLINE * CANCEL-TIMER onbatt1
#AT ONBATT * START-TIMER earlyshutdown 30
#AT ONLINE * CANCEL-TIMER earlyshutdown
AT ONBATT * START-TIMER onbattwarn 30
AT ONLINE * CANCEL-TIMER onbattwarn" > /etc/nut/upssched.conf
```

#### Service init
```
systemctl enable nut-monitor.service
systemctl start nut-monitor.service
systemctl enable nut-server.service
systemctl start nut-server.service
```

### Test que tout fonctionne
```
upsc -l
upsc eaton@ups01.exemple.fr
```
</details>

<details>
  <summary>Debian CLIENT</summary>

## Debian CLIENT
### Package
Install package
```
apt install -y nut
```

### Configure
Backup des fichiers
```
cp /etc/nut/upsmon.conf /etc/nut/upsmon.conf.backup
cp /etc/nut/nut.conf /etc/nut/nut.conf.backup
```

#### Fichier /etc/nut/nut.conf
```
echo "MODE=netclient" > /etc/nut/nut.conf
```

#### Fichier /etc/nut/upsmon.conf
```
echo "MONITOR eaton@upsXX.exemple.fr 1 user passwordYYYY slave
SHUTDOWNCMD "/sbin/shutdown -h now"
NOTIFYFLAG COMMOK SYSLOG
NOTIFYFLAG COMMBAD SYSLOG" > /etc/nut/upsmon.conf
```

#### Service init
```
systemctl enable nut-monitor.service
systemctl start nut-monitor.service
systemctl stop nut-server.service
systemctl disable nut-server.service
```

### Test que tout fonctionne
```
upsc eaton@upsXX.exemple.fr
```
</details>

[comment]: <> (Centos PARTS)

<details>
  <summary>Centos SERVEUR (Pour le serveur branché sur l'UPS)</summary>

## Centos SERVEUR (Pour le serveur branché sur l'UPS)
Globalement pareil que debian mais directory différent
### Package
Sur centos 7 dans /etc/yum.repos.d/epel.repo l'url du repo a changé
```
#baseurl = https://download.fedoraproject.org/pub/epel/$releasever/$basearch/
baseurl = https://dl.fedoraproject.org/pub/epel/$releasever/$basearch/
```

Install package
```
yum install nut
```

### Configuration
Reprendre Debian Serveur et changé "/etc/nut/" par "/etc/ups/"

</details>

<details>
  <summary>Centos CLIENT</summary>

## Centos CLIENT
Globalement pareil que debian mais directory différent
### Package
Sur centos 7 dans /etc/yum.repos.d/epel.repo l'url du repo a changé
```
#baseurl = https://download.fedoraproject.org/pub/epel/$releasever/$basearch/
baseurl = https://dl.fedoraproject.org/pub/epel/$releasever/$basearch/
```

Install package
```
yum install nut
```

### Configure
Backup des fichiers
```
cp /etc/ups/upsmon.conf /etc/ups/upsmon.conf.backup
cp /etc/ups/nut.conf /etc/ups/nut.conf.backup
```

#### Fichier /etc/nut/nut.conf
```
echo "MODE=netclient" > /etc/ups/nut.conf
```

#### Fichier /etc/nut/upsmon.conf
```
echo "MONITOR eaton@upsXX.exemple.fr 1 user passwordYYYY slave
SHUTDOWNCMD "/sbin/shutdown -h now"
NOTIFYFLAG COMMOK SYSLOG
NOTIFYFLAG COMMBAD SYSLOG" > /etc/ups/upsmon.conf
```

#### Service init
```
systemctl enable nut-monitor.service
systemctl start nut-monitor.service
systemctl stop nut-server.service
systemctl disable nut-server.service
```

### Test que tout fonctionne
```
upsc eaton@upsXX.exemple.fr
```
</details>
