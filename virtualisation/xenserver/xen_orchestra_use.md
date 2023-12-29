# Use case
## limitations

### migration
NOK live migration : NO_HOSTS_AVAILABLE()
NOK offline migration : SR_BACKEND_FAILURE_44(, There is insufficient space, )

### backup
il faut que XOA soit sur le même réseau que les VM et les espaces de backup NFS, sinon la configuration d'espaces de backup dans XOA échouent (serveur NFS injoignable par ex)


## pool
Après le rattachement d'un dom0 dans un pool, XO reconnait mal le dom0 (storage absent, VM non démarrées). Xencenter est OK. Solution : systemctl restart xo-server.service
