# Mise à jour de XenServer 7.x en XCP-NG

Adapté en partie de la procédure suivante : https://docs.xcp-ng.org/installation/upgrade/#upgrade-from-xenserver

XCP-NG va s'installer sur la partition de backup et redémarrer dessus.

Tout ce qui était installé sur le dom0 sera perdu :

- users SSH supplémentaires
- options modifiées à la main dans des fichiers
- services supplémentaires type OpenManage
- Stockage en mode fichier sur le dom0 (SR locale pour images ISO)


1. Redémarrer le host sur une image XCP-NG (via clé USB, CD, IDRAC, boot PXE ...) mais sans auto-installation.
2. Lors du boot l'installateur va détecter la présence de Xenserver et proposer de faire la mise à jour. Accepter ce choix
3. Utiliser l'installation depuis le "local media" ou depuis les repos HTTP de XCP-NG
4. Une fois l'installation terminée, redémarrer le dom0, qui démarrera sur XCP-NG


### En cas d'erreur "a base installation repository was not found"

Appuyer sur alt+f2 pour ouvrir une autre console et tenter un `curl` vers l'URL du repo. Le message d'erreur peut en effet cacher un souci de routage ou de DNS.