# DIG
## get a list of yahoo's mail servers
```bash
dig yahoo.com MX +noall +answer
```

## get a list of yahoo's servers
```bash
dig yahoo.com ANY +noall +answer
```

## servr mail en interrogeant un dns particulier
```bash
dig @208.67.220.220 exemple.com mx
```

## reverse DNS lookup
```bash
dig -x 130.117.44.35
```

## Verifier les dns des vhosts
```bash
for i in `grep -h Server /etc/apache2/sites-enabled/*|egrep -v "^[[:blank:]]*#" | sed 's/ServerAlias//g' | sed 's/ServerName//g' | sed 's/^[[:blank:]]*//g'`;do
   dig +nocmd $i +noall +answer >> vhost.log; echo >> vhost.log
done
```

## vérification SRV
```bash
dig SRV _xmpp-server._tcp.exemple.com
```
