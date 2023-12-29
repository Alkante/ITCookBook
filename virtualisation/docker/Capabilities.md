## Capabilities
unités distinctes de privilèges qui peuvent être activées ou désactivées
pour diviser le pouvoir de root
l'idée est de donner uniquement les droits qui sont nécessaire au bon fonctionnement.

### Pour lister les Capabilities dans un docker
```bash
apt install libcap-ng-utils
pscap
```

### Détails
Les capabilities listés sont activées de base dans un conteneur docker:

chown:
- Modifier UID et GID des fichiers
- Inutile en production ( si besoin peut être activé pour le travail puis désactivé)

dac_override:
- Permet de contourner les contrôles de permission de lecture, écriture et éxecution
- Peut lire écrire exécuter n'importe quel fichier sur le système même si les droits ne le permettent pas
- Sans cette capabilities, meme root ne peux plus accéder dans les dossiers qui ne sont pas à lui.
  Seulement le user "www-data" et le groupe "www-data" pourront accéder dans les dossiers du site.
  www-data pourra bien créer un fichier dans "site/public/upload/annu/" par exemple
- La retirer va empecher un script de fonctionner une fois déployé mais cela est un + pour la sécurité.
- Notre docker postgres et mapserver en ont besoin pour fonctionner

fowner:
- Permet de contourner les contrôles de permission sur les opérations qui exigent normalement l'UID du système
  correspond à l'UID du fichier
- Comme dac_override inutile en production

fsetid:
- Ne pas effacer les bits de mode set-user-ID et set-group-ID lorsqu'un fichier est modifié
- Avoir la capacité d’utiliser chmod sans limitation

kill:
- Contourne les vérifications pour l'émission de signaux kill
- Ce n'est pas un gros danger

setgid:
- Accès à toutes les manipulations des GID du processus, permet l'utilisation de faux GID
- Si les processus du docker n'ont pas besoin de modifier les GID, il est inutile de la garder.

setuid:
- Accès à toutes les manipulations des UID du processus
- Si les processus du docker n'ont pas besoin de modifier les UID, il est inutile de la garder.

setpcap:
- Si les capacités de fichiers ne sont pas prises en charge : accorde ou retire
  n'importe quelle capacité de l'ensemble de capacités autorisées

setfcap:
- Avoir la capacité de modifier les capacités d'un fichier
- Peut être nécessaire pour faire des installations pendant le développement mais inutile pour la production

net_bind_service:
- Avoir la capacité d'écouter sur un port inférieur à 1024
- Un processus malveillant pourrais intercepter un service comme sshd

net_raw:
- Permet à un processus d'espionner les paquets de son réseau
- Cet accès donnent également à un attaquant la possibilité d'injecter n'importe quoi sur le réseau

sys_chroot:
- Autorise l'utilisation de chroot
- Inutile dans un conteneur

mknod:
- Autorise la création de fichier spéciaux
- Presque aucun conteneur ne l'utilise et ils devraient tous l'abandonner

audit_write:
- Avoir la capacité d'écrire des logs Kernels (par exemple pour changer un MDP)
- Quasiment aucun processus tentent d'écrire à l'intérieur du noyau donc inutile

### Conclusion

Une partie des capabilities sont nécessaires pour manipuler le système, elles sont utilisées par le conteneur mais pas par les processus s'exécutant dans le conteneur.
L'ajout des capabilities ajoute des vulnérabilités ce qui peut rompre l'isolation du conteneur, il faut donc les limiter.
