# Netbox
Outil IPAM/DCIM Open Source

## Modifier le masque de toutes les adresses d'un subnet

En se connectant à la BDD PostgreSQL :

```sql
update public.ipam_ipaddress set address = set_masklen(address, 23) where address in (select address from public.ipam_ipaddress where network(address) = '10.10.0.0/19');
```

Ici le /19 est transformé en /23.
