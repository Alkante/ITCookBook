# nftables
https://wiki.debian.org/nftables
https://wiki.archlinux.org/index.php/Nftables
https://wiki.gentoo.org/wiki/Nftables/Examples
https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes
https://wiki.nftables.org/wiki-nftables/index.php/Main_Page

Note : sur buster, shorewall fonctionne avec nftables

## Installation
```bash
apt install nftables
```
## conf
```bash
cat /etc/nftables.conf
```
```
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
	chain input {
		type filter hook input priority 0;
	}
	chain forward {
		type filter hook forward priority 0;
	}
	chain output {
		type filter hook output priority 0;
	}
}
```
```bash
systemctl enable nftables.service
```
Exemples:
```bash
cd /usr/share/doc/nftables/examples/
```

##conf exemple basique ssh http https

```bash
nano /etc/nftables.rules
```
```
#!/sbin/nft -f
# https://wiki.gentoo.org/wiki/Nftables/Examples#Typical_workstation_.28combined_IPv4_and_IPv6.29
flush ruleset

define my_clients = { 192.168.56.1, 192.168.56.2 }

# inet == ipv4 et ipv6
table inet filter {
	chain input {
		type filter hook input priority 0; policy drop;
		ct state invalid counter drop comment "early drop of invalid packets"
		ct state {established, related} counter accept comment "accept all connections related to connections made by us"

		# accèpte le localhost
		iif lo accept comment "accept loopback"
		iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"
		iif != lo ip6 daddr ::1/128 counter drop comment "drop connections to loopback not coming from loopback"

		# ping
		ip protocol icmp counter accept comment "accept all ICMP types"
		ip6 nexthdr icmpv6 counter accept comment "accept all ICMP types"

		tcp dport ssh counter accept comment "accept SSH"
		tcp dport http accept comment "accept http sans counter"
		tcp dport https counter accept comment "accept https"
		tcp dport 8080 counter accept comment "accept 8080 pour tout le monde"

        tcp dport 8081 ip saddr { 192.168.56.1, 192.168.56.2 } accept comment "accept 8081 pour 192.168.56.1"
        # ou
        #tcp dport 8081 ip saddr $my_clients accept comment "accept 8081 pour 192.168.56.1"


		# peut s'écrire aussi :
		# tcp dport {ssh, http, https, 8080} accept

		counter comment "count dropped packets"
	}

	chain forward {
		type filter hook forward priority 0; policy drop;
		counter comment "count dropped packets"
	}

	# If you're not counting packets, this chain can be omitted.
	chain output {
		type filter hook output priority 0; policy accept;
		counter comment "count accepted packets"
	}
}
```
Test des règles :
```bash
nft -c -f /etc/nftables.rules
# si pas d'erreur
nft -f /etc/nftables.rules; sleep 30; nft flush ruleset
# Si ça merde, un reboot rétablie les règles.
# liste des règles
nft list ruleset
# on applique définitivement les règles
cp /etc/nftables.rules /etc/nftables.conf
nft -f /etc/nftables.conf
```

Note :  
les «counter» sont visibles lorsque l'on utilise ```nft list ruleset```


## conf exemple (shorewall) converti en nftables

/etc/nftables.conf
```
#!/sbin/nft -f
flush ruleset

define BACKUP = 10.502.0.1
#dom0 client1
define DOM0_phy0001 = 10.502.0.230
define DOM0_phy0002 = 10.502.0.22
define DOM0_phy0003 = 10.502.0.134
define DOM0_phy0004 = 10.502.0.72
define DOM0_phy0005 = 10.502.0.96

define DOM0_GRP = {$DOM0_phy0001,$DOM0_phy0002,$DOM0_phy0003,$DOM0_phy0004,$DOM0_phy0005}

define DOMU_vps01 = 10.502.0.130
define DOMU_vps02 = 10.502.0.134
define DOMU_vps03 = 10.502.0.63
define DOMU_vps04 = 10.502.0.197
define DOMU_vps05 = 10.502.0.167
define DOMU_vps06 = 10.502.0.251
define DOMU_GRP = {$DOMU_vps01,$DOMU_vps02,$DOMU_vps03,$DOMU_vps04,$DOMU_vps05,$DOMU_vps06}

#IP ENTREPRISE
define IP_ENT = {192.168.0.1,192.168.0.254}
#client1
define IP_CLIENT1 = {172.16.0.1}
#client2
define IP_CLIENT2 = {172.16.1.1,172.16.2.1}

table inet filter {
	chain input {
		type filter hook input priority 0; policy drop;
		ct state invalid counter drop comment "early drop of invalid packets"
		ct state {established, related} counter accept comment "accept all connections related to connections made by us"

		# accèpte le localhost
		iif lo accept comment "accept loopback"
		iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"
		iif != lo ip6 daddr ::1/128 counter drop comment "drop connections to loopback not coming from loopback"

		tcp dport {http, https} accept comment "Site web"

		tcp dport {ftp,ssh,5432,60000-61000} ip saddr $IP_ENT accept comment "ENTREPRISE"
		ip protocol icmp ip saddr $IP_ENT accept comment "Alkante ICMP"

		tcp dport {ssh,9102,9103} ip saddr $BACKUP accept comment "bacula"
		ip protocol icmp ip saddr $BACKUP accept comment "bacula ICMP"

		tcp dport {ssh} ip saddr $DOM0_GRP accept comment "dom0"
		ip protocol icmp ip saddr $DOM0_GRP accept comment "dom0 ICMP"

		tcp dport {ssh} ip saddr $DOMU_GRP accept comment "domU"
		ip protocol icmp ip saddr $DOMU_GRP accept comment "domU ICMP"

		tcp dport {ftp,ssh,5432,60000-61000} ip saddr $IP_CLIENT1 accept comment "client1"
		ip protocol icmp ip saddr $IP_CLIENT1 accept comment "client1 ICMP"

		tcp dport {ftp,ssh,5432,60000-61000} ip saddr $IP_CLIENT2 accept comment "client2"
		ip protocol icmp ip saddr $IP_CLIENT2 accept comment "client2 ICMP"

		counter comment "count dropped packets"
	}

	chain forward {
		type filter hook forward priority 0; policy drop;
		counter comment "count dropped packets"
	}

	chain output {
		type filter hook output priority 0; policy drop; #drop très dangeureux si les règles qui suivent sont mauvaises !
		# recommandation :
		# utiliser «policy accepte» + ajout de «counter» aux règles qui suivent pour vérifer qu'elles sont bonnes
		# (si pas de paquet alors il y a une erreur)

		counter comment "count accepted packets"

		tcp dport {53,ssh,http,https,smtp} counter accept
		udp dport {53,123} counter accept

		tcp sport {53,ssh,http,https,smtp} counter accept
		udp sport {53,123} counter accept
	}
}
```

https://wiki.nftables.org/wiki-nftables/index.php/Load_balancing
