# Nmap

## scanner le port d'un serveur
```bash
nmap -p 80 www.exemple.fr
```

## scan intense d'un serveur
```bash
nmap -T4 -A -v www.exemple.fr
nmap -A -p- -Pn -vv www.exemple.fr -oA www.exemple.fr
```

## scan tout les ports TCP d'un serveur
```bash
nmap -p 1-65535 -T4 -A -v www.exemple.fr
```

## scan rapide
```bash
nmap -T4 -F www.exemple.fr
```

## traceroute rapide
```bash
nmap -sn --traceroute www.exemple.fr
```

## scanner réseau
```bash
nmap -sP 192.168.0.0/24
```

## Documentations
- https://www.cyberciti.biz/networking/nmap-command-examples-tutorials/
- https://gbhackers.com/network-penetration-testing-checklist-examples/
- https://highon.coffee/blog/penetration-testing-tools-cheat-sheet/#nmap-commands
