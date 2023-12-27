# Ifconfig
## Affichage
```bash
ifconfig
```

## Ajouter un ip dans une interface virtuel
```bash
ifconfig eth0:0 192.168.64.243 netmask 255.255.224.0
```

## Supprimer une interface virtuel
```bash
ifconfig eth0:0 down
```
