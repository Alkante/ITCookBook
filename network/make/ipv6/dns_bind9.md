# Bind9 ipv6
Meme fichier de configuration qu'en IPv4
Une ipv6 doit etre désigné avec l'alias AAAA

## Configuration
### Fichier db.exemple.fr :
```
$TTL	604800
@	IN	SOA	ns.exemple.fr root.exemple.fr (
		    10			; Serial
			604800		; Refresh
			86400		; Retry
			2419200		; Expire
			604800 )	; Negative Cache TTL
;
@	IN	NS	ns

pfsense	IN	A	192.168.0.254
pfsense IN	AAAA	fd00:5881:9000::ffff

vm-1	IN	A	192.168.0.101
vm-1	IN	AAAA	fd00:5881:9000::101

ns		IN	A	192.168.0.253
ns		IN	AAAA	fd00:5881:9000::dddd
```

### Fichier named.conf.local
```
zone "exemple.fr" IN {
	type master;
	file "/etc/bind/db.exemple.fr";
	allow-query { any; };
};
```

## Reverse DNS
### Fichier db.0.0.0.0.0.0.0.9.1.8.8.5.0.0.d.f.ip6.arpa
```bash
$ORIGIN 0.0.0.0.0.0.0.9.1.8.8.5.0.0.d.f.ip6.arpa.
$TTL 1h	; Default TTL
@	IN	SOA	ns.exemple.fr. admin.exemple.com. (
	2016030701     ; serial
	3H             ; refresh
	1H             ; retry
	1W             ; expiry
	1D )           ; minimum
;
NS	ns.exemple.fr.
IN	NS	ns.exemple.fr.

f.f.f.f.0.0.0.0.0.0.0.0.0.0.0.0    IN    PTR    pfsense.exemple.fr.
1.0.1.0.0.0.0.0.0.0.0.0.0.0.0.0	   IN    PTR    vm-1.exemple.fr.
```


### Fichier named.conf.local
```bash
zone "0.0.0.0.0.0.0.0.0.0.0.0.1.0.d.f.ip6.arpa" IN {
	type master;
	file "/etc/bind/db.0.0.0.0.0.0.0.0.0.0.0.0.1.0.d.f.ip6.arpa";
};
```
