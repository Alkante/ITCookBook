#Jitsi
Procédure d'installation et maintenance jitsi pour conf.exemple.com

## Maintenance
Dossier de travail : /home/www/conf.exemple.com
Dossier des dockers : /home/www/conf.exemple.com/docker-jitsi-meet
Script pour relancer les dockers : /home/www/conf.exemple.com/restart_visio.sh


Ports :
80 et 443 en écoute et proxy sur 8000
10000 en écoute et ouvert sur le firewall

## Installation
Procédure et doc : https://github.com/jitsi/docker-jitsi-meet
Fichier de configuration des variables .env : /home/www/conf.exemple.com/docker-jitsi-meet/.env
A chaque modification du .env il faut supprimer les fichiers de configuration présent dans le dossier
/home/www/conf.exemple.com/docker-jitsi-meet/.jitsi-meet-cfg/ car les configurations ne sont pas mis à
jour automatiquement.


Les comptes sont gérées par le docker prosody, la configuration est en mode authentification interne
Créer un utilisateur :
```
cd /home/www/conf.exemple.com/docker-jitsi-meet
docker-compose exec prosody prosodyctl --config /config/prosody.cfg.lua register user meet.jitsi mdp
```

Supprimer un utilisateur :
```
cd /home/www/conf.exemple.com/docker-jitsi-meet
docker-compose exec prosody prosodyctl --config /config/prosody.cfg.lua deluser user@exemple.com
```
