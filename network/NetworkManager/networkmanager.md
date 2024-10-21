# NetworkManager
NetworkManager est un composant permettant de gérer la configuration réseau de systèmes Linux, souvent utilisé côté client.
Il est accessible en interface graphique comme en CLI (commande ```nmcli```).

## DHCPv6 et DUID
Par défaut le DUID est généré en fonction d'un machine-id (RFC6355)

Pour éviter les duplications dans le cas de machines identiques / installées automatiquement il peut être nécessaire de changer le mode de génération du DUID.
Il est possible de le dériver de l'adresse MAC (RFC3315).

Pour cela :

### Identifier la connexion à modifier :
```nmcli con show
nmcli con show
NAME             UUID                                  TYPE      DEVICE          
DHCP             64191c1b-2942-34f1-a023-c4f741ffad36  ethernet  enp1s0f1        
br-685517cdfbd7  20f7397e-c1aa-423f-af4d-6a5f183bdcf0  bridge    br-685517cdfbd7
br-7af0cb32d17b  4b0673da-3a04-4ba1-bd88-609d556bd415  bridge    br-7af0cb32d17b
br-a80dbbc90405  c7a26bf4-81ce-4d16-8190-f391da38574b  bridge    br-a80dbbc90405
docker0          d4e712c8-5856-43b0-882c-ee0ed2621378  bridge    docker0         
reseauwifi       9c1d9743-5470-445c-a572-382d2c4ac5bf  wifi      --     

```


### Modifier la connexion concernée :
```
nmcli con edit DHCP
set ipv6.dhcp.duid stable-ll
save
```
Autre solution dans le fichier : /etc/NetworkManager/system-connections/DHCP.nmconnection
```
[ipv6]
dhcp-duid=stable-llt
```
- stable-uuid (RFC 6355, id 4): generated from an Universally Unique IDentifier (UUID).
- stable-ll (RFC 3315, id 3): generated from the Link-Layer address (aka MAC address).
- stable-llt (RFC 3315, id 1): generated from the Link-Layer address plus a timestamp.
Source : https://wiki.archlinux.org/title/NetworkManager

### Redémarrer la connexion pour refaire une demande DHCPv6, en débranchant le câble ou via nmcli :
```
nmcli con down DHCP
nmcli con up DHCP
```

Plus d'infos sur les paramètres ipv6 de nmcli :

https://developer-old.gnome.org/NetworkManager/stable/settings-ipv6.html
