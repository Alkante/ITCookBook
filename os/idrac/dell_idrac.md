# Idrac Dell

## Changer l'alimentation active (si mode actif/backup sans partage de charge)
```bash
# serveurs Dell récents
racadm set System.ServerPwr.RapidOnPrimaryPSU PSU2
# serveurs Dell plus anciens
racadm set System.Power.Hotspare.PrimaryPSU PSU2
```

## Enlever le check du Host en HTTP si erreur 400
Utile si le nom de l'idrac ne correspond pas au nom DNS.

```bash
racadm set idrac.webserver.HostHeaderCheck 0
# redémarrer l'idrac pour la prise en compte
racadm racreset
```


Changer le mot de passe du compte par défaut (root)

```bash
read -sp "Enter new password" ROOTPW
# entrer le nouveau mdp
racadm set iDRAC.Users.2.Password $ROOTPW
```