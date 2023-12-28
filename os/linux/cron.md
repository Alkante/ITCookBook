# cron
## Fichiers cron executés automatiquement sans etre mis dans la table crontab
- /etc/crontab
- /etc/cron.d/*
## Le fichier /etc/crontab execute automatiquement tout les scripts présents dans :
- /etc/cron.daily
- /etc/cron.hourly
- /etc/cron.monthly
- /etc/cron.weekly

## Liste de la table cron
```bash
crontab -l
```


## Rédaction d'une ligne d'un fichier cron
```
# m : minute         0-59
# h : heure          0-23
# dom : jour du mois   0-31
# mon : mois           0-12 (ou noms, voir plus bas)
# dow : jour de semaine0-7 (0 et 7  snt  Dimanche,  ou  les

# m h dom mon dow user  command
25 6    * * *   root    test -x /usr/sbin/anacron
```
La commande peut être soumit à condition : cf. wikipedia
