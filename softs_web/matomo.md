# Matomo
Outil de tracking d'utilisateurs sur un ou plusieurs sites Web, compatible avec le RGPD (suivant la configuration).

Appli Web en PHP + base MySQL

## Passer en mode maintenance (couper l'accès web et garder le tracking) ou couper le tracking
https://matomo.org/faq/how-to/faq_111/

## Mise à jour
https://matomo.org/faq/on-premise/update-matomo/#the-manual-three-step-update

Version simple :
1. DL / extraire la nouvelle version
2. Copier le fichier de configuration (config/config.ini.php) de l'installation actuelle dans le répertoire de la nouvelle version
3. Remplacer tous les fichiers de l'ancienne version par la nouvelle
4. Si grosse mise à jour, lancer l'upgrade dans un screen en CLI, sinon via l'interface web

```bash
su -c "./path/to/matomo/console core:update" www-data
```

## Rejouer des logs (en cas d'indispo de l'appli sans coupure du serveur web)
https://matomo.org/faq/log-analytics-tool/faq_19221/

```bash
python3.7 /home/www/matomo/misc/log-analytics/import_logs.py --url=https://matomo.exemple.com/ --replay-tracking LOGFILE --auth-user MATOMOUSER --auth-password 'MATOMOPASSWORD'
```

## Cron (archivage des rapports + tâches planifiées)
```
#Ansible: Archive Matomo
11 * * * * www-data /usr/bin/php /home/www/matomo/console core:archive --url=https://matomo.exemple.com/
```

## Forcer l'archivage des rapports d'un site
```bash
su -c "/usr/bin/php /home/www/matomo/console core:archive --force-idsites 2089 --url=https://matomo.exemple.com/ --force-periods=month --verbose --force-report" www-data
```
L'ID du site (ici 2089) peut se trouver dans l'interface de Matomo (soit dans la liste des sites côté admin, soit dans les URLs de certaines pages type https://matomo.exemple.com/index.php?module=CoreHome&action=index&idSite=2089 )

## Invalider des rapports entre certaines dates (pour forcer la régénération de rapports)
```bash
su -c "/usr/bin/php /home/www/matomo/console core:invalidate-report-data --dates=2023-04-01,2023-04-25 --sites=2089" www-data
```
