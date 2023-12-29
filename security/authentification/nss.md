
# NSS 

(Name Service Switch, commutateur de services de nommages)

Permet de fournir à Unix non des services d'authentification, mais des services de correspondances entre noms, de toutes sortes (noms de machines et noms d'utilisateurs intelligibles par l'homme, par exemple), et les identifiants de ces mêmes objets pour la machine (adresses IP et uid/gid dans notre exemple).

NSS, comme PAM, est composé de greffons sous formes de bibliothèques dynamiques, Le paramétrage est plus limité, non unifié entre eux (au contraire de PAM)

	/etc/nsswitch.conf.