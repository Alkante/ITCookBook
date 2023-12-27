# Shorewall6
## Exactement la meme syntaxe que Shorewall de base
Simplement des changements sur les noms de protocole

## Visualisation de la table filter :
La commande 'iptables' pour l'utilisation d'ipv4 et la commande 'ip6tables' pour ipv6, ce qui nous donne :
```bash
watch -n 1 'ip6tables -t filter -L net-fw -nv'
```

## Ping(icmp)
/!\ Pour mettre en place des règles sur les pings, elles devront etre placé dans la 'SECTION ALL' et non comme par défaut dans la 'SECTION NEW'
