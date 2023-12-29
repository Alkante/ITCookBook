# Sendmail

## Install sendmail config sendmail.mc
```bash
apt-get install sendmail-bin sendmail-base sendmail sensible-mda

make -C /etc/mail
```

## filtrage des mails envoyés (seul vers exemple.com autorisé)
Dans  /etc/mail/sendmail.mc:
```
FEATURE(`access_db')dnl
FEATURE(`blacklist_recipients')dnl
vi /etc/mail/access
To:exemple.com RELAY
To:exemple.al RELAY
To:localdomain RELAY
To:ac  ERROR: domaine exemple uniquement!
To:ad  ERROR: domaine exemple uniquement!
To:ae  ERROR: domaine exemple uniquement!
To:aero  ERROR: domaine exemple uniquement!
To:af  ERROR: domaine exemple uniquement!
To:ag  ERROR: domaine exemple uniquement!
makemap hash /etc/mail/access.db < /etc/mail/access
make -C /etc/mail
/etc/init.d/sendmail reload
```

## tuning ranger
Timeout.initial	[5m] The timeout waiting for a response on the initial connect. --------------> 1m

Timeout.queuereturn	[5d] The timeout before a message is returned as undeliverable -------> 3d

Timeout.hoststatus	[30m] How long information about host statuses will be maintained before it is considered stale and the host should be retried. This applies both within a single queue run and to persistent information (see below).						---------------> 2h

```
define(`confTO_CONNECT', `1m')dnl
define(`confTO_QUEUERETURN', `2m')dnl
define(`confTO_HOSTSTATUS', `2h')dnl
```

## choose smtp relay

#### simple
```
define(`SMART_HOST', `your-smtp-server')
make -C /etc/mail
```

#### choose smtp relay with auth
```
cd /etc/mail/
mkdir auth ; chmod 700 auth
echo  'AuthInfo:mail.swcp.com "U:USERNAME" "P:PASSWORD"' >> auth/client-info
cd auth
makemap hash client-info < client-info
chmod 600 client-info*
cd ..
```
dans sendmail.mc
```
define(`SMART_HOST',`mail.swcp.com')dnl
define(`RELAY_MAILER_ARGS', `TCP $h 587')
define(`confAUTH_MECHANISMS', `EXTERNAL GSSAPI DIGEST-MD5 CRAM-MD5 LOGIN PLAIN')dnl
FEATURE(`authinfo',`hash /etc/mail/auth/client-info')dnl
make
/etc/init.d/sendmail restart
```

## configure as smtp relay
```
DAEMON_OPTIONS(`Family=inet,  Name=MTA-v4, Port=smtp, Addr=0.0.0.0')dnl
```
allow relay for clients: /etc/mail/local-host-names mettre la machine autorisee dans la liste


## configure auth mechanism
verifier support sasl
```
sendmail -d0.1 -bv root | grep SASL
```
config sasl
```
apt-get install sasl2-bin
```
dans /etc/default/saslauthd
```
START=yes
echo ?pwcheck_method: saslauthd? > /usr/lib/sasl2/Sendmail.conf
/etc/init.d/saslauthd restart
```
ajouter conf
```
TRUST_AUTH_MECH(`GSSAPI DIGEST-MD5 PLAIN LOGIN')dnl
define(`confAUTH_MECHANISMS',`GSSAPI KERBEROS_V4 DIGEST-MD5 CRAM-MD5 PLAIN LOGIN')dnl
```

## sendMail mailqueue
#### forcer le renvoi immédiat des mails
```
sendmail -OTimeout.hoststatus=0m -q -v
```
#### purge queue
```
cd /var/spool/mqueue
ls | xargs /usr/share/sendmail/qtool.pl -d
grep "Connection refused by vm1.exemple.com" * | xargs rm
for i in `grep -l voila.fr *`; do rm *${i:1}; done
```

## debug sendmail return path
```
sendmail -bt
/tryflags ES
/try esmtp root
/try esmtp root@localhost
/try esmtp root@localhost.localdomain
/try esmtp root@your.host.name
```

cname causes sendmail to accept CNAME records as canonical. (false par defaut)
```
-ODontExpandCnames=true
define(`confDONT_EXPAND_CNAMES',`true')dnl
```
si app1.exemple.com est un CNAME vers vm1.exemple.com, alors:
- par défaut : DontExpandCnames=false -> app1.exemple.com devient vm1.exemple.com
- sinon si   : DontExpandCnames=true --> app1.exemple.com reste app1.exemple.com
#mais si app1.exemple.com est dans le fichier hosts, la directive DNS ne joue pas, alors app1.exemple.com peut devenir autre chose
#il faut alors
-> mettre ```FEATURE(`nocanonify')dnl```
-> ET disable masquerade (ou choisir le domaine de masquerade)


## X-Authentication-Warning
```
echo "FEATURE(\`use_ct_file')dnl" >> /etc/mail/submit.mc
echo "www-data" >> /etc/mail/trusted-users
make -C /etc/mail
/etc/init.d/sendmail reload
```

## Block mail except exemple.com
- Dans sendmail.mc mettre : ```FEATURE(`mailertable')```
- Dans : /etc/mail/mailertable
```
exemple.com   smtp:smtp.exemple.com
.        error:nohost Mail to external domain is prohibited
```
- bash :
```
cd /etc/mail
makemap hash /etc/mail/mailertable < /etc/mail/mailertable
make
/etc/init.d/sendmail reload
```
