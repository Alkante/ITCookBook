# Fail2Ban
Fail2ban est un logiciel anti brute force intervenant qui est couplé à iptables mais peut aussi être couplé à Shorewall.
Il permet de banir les personnes échouant plusieurs fois lors de leurs tentative de connexion.
Il fonctionne en regardant les log dans /var/log/ et peut être configurer pour protéger l'authentification de plusieur programme comme ssh, proftpd, ssh et autres.

<!-- ------------------------ Installation -------------------------- -->
## Installation

### Installer Fail2Ban
```bash
apt-get install fail2ban
```

### Vérifier que Fail2Ban est démarré automatiquement
```bash
pgrep -a fail2ban
```

### Les .conf sont général et overide par les .local7
```bash
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```


<!-- ------------------------ Shorewall with fail2ban -------------------------- -->

## Shorewall with fail2ban

### Configurer l'action de ban

###### Automatique
```bash
sed -i 's/^\([ \t]*banaction[ \t]*=[ \t]*iptables-multiport[ \t]*\)$/#\1\nbanaction = shorewall/g' /etc/fail2ban/jail.local
```

###### Manuel
```bash
editor /etc/fail2ban/jail.local
```
```text conf
#banaction = iptables-multiport
banaction = shorewall
```

### Ban default timer = 10min

### Option : Parametrage des options de banissement

###### Automatique
```bash
sed -i 's/^\([ \t]*blocktype[ \t]*=[ \t]*reject[ \t]*\)$/#\1\nblocktype = drop/g' /etc/fail2ban/action.d/shorewall.conf
```
###### Manuel
```bash
editor /etc/fail2ban/action.d/shorewall.conf
```
```text conf
#blocktype = reject
blocktype = drop
```

### Blacklist
###### Automatiquement
```bash
sed -i 's/^\([ \t]*BLACKLIST[ \t]*=.*\)$/#\1\nBLACKLIST="ALL"/g' /etc/shorewall/shorewall.conf
```
###### Manuellement
```bash
editor /etc/shorewall/shorewall.conf
```
```text conf
#BLACKLIST="NEW,INVALID,UNTRACKED"
BLACKLIST="ALL"
```

### Relancer fail2ban et shorewall
```bash
service fail2ban restart
service shorewall restart
```

<!-- ------------------------ Administration -------------------------- -->

## Administration

### Status
```bash
fail2ban-client status
```

### Status sur le ssh
```bash
fail2ban-client status ssh
```

### Voir les ip banni dans shorewall
```bash
iptables -L dynamic
```

### Voir les ip banni via fail2ban-client
```bash
fail2ban-client status
```

### Débanir via fail2ban
```bash
fail2ban-client set ssh-iptables unbanip 192.168.1.101
```

### Banir une ip manuellement
```bash
fail2ban-client set JAIL unbanip IP
```

### Accès manuel via le firewall iptables
l'accès directement via iptables se fait à vos risques car en fonction des versions les chaines iptables changent de noms.
#### Afficher les ip bani
```bash
iptables -L fail2ban-SSH --line-numbers
```
#### Débannir une IP en suppriment la règle(numéro) correspondante
```bash
iptables -D fail2ban-ssh 2
```

### Voir les logs
```bash
tail -f /var/log/fail2ban.log
```

<!-- ------------------------ Support pour d'autre programme -------------------------- -->

## Support pour d'autre programme

### Supprot de mumble-serveur
```text conf
[mumble-server]
enabled = true
port = 64738
filter = mumble-server
logpath = /var/log/mumble-server/mumble-server.log
maxretry = 2
```

### Support de proftpd
```text conf
[proftpd]
enabled  = true
port     = ftp,ftp-data,ftps,ftps-data
filter   = proftpd
logpath  = /var/log/auth.log
maxretry = 2
```

<!-- ------------------------ Tricks -------------------------- -->

## Tricks
### Liste (ordonnée, unique et count) des logins utilisées ayant echouées à l'authentification ssh
```bash
egrep sshd /var/log/auth.log |egrep Invalid |awk '{print $8}' |sort |uniq -c
```
