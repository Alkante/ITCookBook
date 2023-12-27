# Fail2ban ipv6
De base fail2ban n'est pas compatible avec IPv6
Il existe un patch pour résoudre ce problème

## Info
Version de fail2ban utilisé 0.8.13
Vous pouvez trouver les infos du patch sur d'autre version à l'adresse suivante :
http://crycode.de/wiki/Fail2Ban#IPv6

## Installation de fail2ban
```bash
apt-get install fail2ban
```

### Installation du patch ipv6
#### Téléchargement du patch :
```bash
wget http://thanatos.trollprod.org/sousites/fail2banv6/fail2ban-ipv6.tar.bz2
```
J'ai utilisé cette version du patch mais elle n'est pas destiné a la version 0.8.13 de fail2ban
```bash
mkdir fail2ban6
tar xvjf fail2ban-ipv6.tar.bz2 -C fail2ban6/
```

#### Mise en place du patch
```bash
cd /usr/share/fail2ban/server
cp filter.py filter.py.old
cp failregex.py failregex.py.old
```

#### Application du patch avec la commande
* Test du patch
```bash
patch -p0 --dry-run < /root/fail2ban6/patchfilter.patch
patch -p0 --dry-run < /root/fail2ban6/regex.patch
```
* Application
```bash
patch -p0 < /root/fail2ban6/patchfilter.patch
patch -p0 < /root/fail2ban6/regex.patch
```

#### Application du patch à la main
/!\ Dans mon cas le patch ne fonctionnait pas j'ai donc du faire les changements à la main
Fichier : /usr/share/fail2ban/server/filter.py:
```
=========================================================
 	IP_CRE = re.compile("^(?:\d{1,3}\.){3}\d{1,3}$")
+	IP_CRE6 = re.compile("^(?:[0-9:A-Fa-f]{3,})$")

	.
	.
	.

 		if match:
 			return match
 		else:
-			return None
+			match = DNSUtils.IP_CRE6.match(text)
+			if match:
+				""" Right Here, we faced to a ipv6
+				"""
+				return match
+			else:
+				return None
 	searchIP = staticmethod(searchIP)

 	#@staticmethod
 	def isValidIP(string):
 		""" Return true if str is a valid IP
+		We Consider that logfiles didn't make errors ;)
 		"""
-		s = string.split('/', 1)
-		try:
-			socket.inet_aton(s[0])
-			return True
-		except socket.error:
-			return False
+		return True
 	isValidIP = staticmethod(isValidIP)
=========================================================

Fichier /usr/share/fail2ban/server/failregex.py:
=========================================================
-		regex = regex.replace("<HOST>", "(?:::f{4,6}:)?(?P<host>[\w\-.^_]+)")
+		regex = regex.replace("<HOST>", "(?:::f{4,6}:)?(?P<host>[\w\-.^_:]+)")
=========================================================
```

#### Ajout des fichiers
```bash
cp /root/fail2ban6/ip64tables.sh /usr/bin/
chmod 755 /usr/bin/ip64tables.sh
cp /root/fail2ban6/iptables46-multiport.conf /etc/fail2ban/action.d/
chmod 644 /etc/fail2ban/action.d/iptables46-multiport.conf
```

#### Configuration
Fichier : /etc/fail2ban/jail.conf
```bash
[ssh-ip6tables]
enabled = true
filter  = sshd
logpath  = /var/log/auth.log
maxretry = 6
action   = iptables46-multiport[name=SSH, port=22, protocol=tcp]
           sendmail-whois[name=SSH, dest=root, sender=fail2ban@mail.com]
```

Redémarrez le service
```bash
service fail2ban restart
```

##### Visualisation
Les logs :
```bash
tail -f /var/log/fail2ban.log
```

Ip6tables :
```bash
watch -n 1 'ip6tables -t filter -L fail2ban-SSH -nv'
```

##### Bannir les prefix
Fichier /etc/fail2ban/action.d/iptables46-multiport.conf
Ajouter apres '<ip>' un '/64' aux deux lignes suivantes :
```bash
actionban = ip64tables.sh -D fail2ban-<name> -s <ip>/64 -j DROP
actionunban = ip64tables.sh -D fail2ban-<name> -s <ip>/64 -j DROP
```

#### Problème rencontrer
* Error in FilterPyinotif callback: 'module' object has no attribute '_strptime_time'
Ajouter dans le fichier /usr/share/fail2ban/server/filter.py, la ligne suivante en début :
```
import datetime
```
* Unable to find a corresponding IP address for 127.0.01/8: Temporary failure in name resolution
Il s'agit d'un WARNING mais cela engendre un gros décalage du bannisement de l'adresse IP
Pour résoudre ce problème il faut dans le fichier /etc/fail2ban/jail.conf simplement supprimer le '/8' et avoir donc à la place de :
```
[DEFAULT]
ignoreip = 127.0.0.1/8
```
On a :
```
[DEFAULT]
ignoreip = 127.0.0.1
```
Il semble qu'ajouter la localhost ipv6 (::1) ne soit pas une bonne idée car fail2ban ne reconnait pas la famille de cette adresse.
