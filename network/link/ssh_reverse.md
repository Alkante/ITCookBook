# Reverse ssh
## principe:
on cherche à accéder en SSH à une machine qui n'est pas joignable normalement (pare-feu, NAT, etc...)
la machine client va monter un tunnel SSH vers un serveur
A partir de ce serveur il est alors possible de se connecter en SSH à la machine client.

## pré-requis:
la machine client doit pouvoir se connecter sur le port SSH du serveur

## montage du tunnel
### préparation du serveur:
Ajouter cette ligne dans /etc/ssh/sshd_config, et re-démarrer le serveur SSH:
```
AllowTcpForwarding yes
```
Par sécurité créer un utilisateur dédié au tunnel sur le serveur:
```
adduser userssh
```

### filtrage des utilisateurs ssh
Dans /etc/ssh/sshd_config, ajouter :
```
AllowUsers userssh pnom
```
ou (si il existe un groupe «sshUsers» qui intègre les utilisateurs autorisés à se connecter en ssh)
```
AllowGroups sshUsers
```

### préparation à partir de la machine client:
Le port 22222 de l'exemple suivant doit se trouver entre 1024 et 65535. Il faut évidement tenir une liste des ports associés aux machines.
Créez le tunnel sur la machine client:
```
ssh -NR 22222:localhost:22 userssh@serveur
```

### connexion reverse:
sur le serveur, on ouvre une connexion SSH vers la machine client:
```
ssh -p 22222 user_machine_client@127.0.0.1
```
