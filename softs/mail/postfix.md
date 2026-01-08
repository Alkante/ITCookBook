# Postfix
## replace sendmail par postfix
```bash
/etc/init.d/sendmail stop
apt-get -y remove --purge sendmail sendmail-base sendmail-bin sendmail-cf
rm -rf /etc/mail
```

## Install postfix
Install avec profil "internet site" (simple daemon qui envoi des mails)
```
echo postfix postfix/main_mailer_type select "Internet Site" | debconf-set-selections
echo postfix postfix/mailname select `hostname -f` | debconf-set-selections
apt-get -y install postfix
sed -i 's/^inet_interfaces.*$/inet_interfaces = loopback-only/
```
#### choose remote smtp relay
```bash
sed -i 's/^relayhost.*$/relayhost = smtp.exemple.com:25/' /etc/postfix/main.cf
/etc/init.d/postfix restart
```

## test envoi
```bash
echo -e "From: etiquette@exemple.com\nSubject: subject\ntest" |  sendmail -v -freturnpath@astrollendro.exemple.com p.nom@exemple.com
```

## mailq
#### flush postfix mailqueue
To remove all mail from the queue, enter:
```bash
postsuper -d ALL
```
To remove all mails in the deferred queue, enter:
```bash
postsuper -d ALL deferred
```

Pour supprimer les mails d'un expéditeur
```bash
postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /bounces@exemple\.com/ { print $1 }' | tr -d '*!' | postsuper -d -
```
#### forcer le traitement de la queue
```bash
postqueue -f
```

## divers
450 4.1.7  Sender address rejected: unverified address
- http://www.backscatterer.org/?target=sendercallouts
- http://www.postfix.org/ADDRESS_VERIFICATION_README.html#probe_routing

## postconf
#### par défaut
affiche les clés / valeurs (= arg -p)
postconf -p smtpd_recipient_restrictions

#### postmap
## test database:
```bash
postmap -q info@exemple.com hash:/etc/postfix/virtual
```

## Debug mail dans Docker

Selon [la documentation officielle](https://www.postfix.org/MAILLOG_README.html), la fonctionnalité n'est disponible qu'à partir de Postfix version 3.4 (Stretch a la version 3.1) :

```bash
postfix stop && postconf maillog_file=/var/log/postfix.log && postfix start
tail -f /var/log/postfix.log
```
