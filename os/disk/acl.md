# POSIX & ACL

<!-- TOC -->

- [POSIX & ACL](#posix--acl)
    - [Installer](#installer)
    - [POSIX](#posix)
        - [chmod](#chmod)
        - [umask](#umask)
    - [ACL](#acl)
        - [getfacl](#getfacl)
        - [setfacl](#setfacl)
            - [racourci](#racourci)
        - [](#)

<!-- /TOC -->


## Installer
```bash
apt-get install acl
```

## POSIX
les droits sont du style
```bash
ls -al
```
```
drwsrwsr-x+  3 root    root     4096 Sep 10 14:16 .
drwxr-xr-x  12 root     root     4096 Sep 10 13:47 ..
```


### chmod
chmod utilise la notation suivante :

    u - pour le propriétaire (user)
    g - pour le groupe (group)
    o - pour les autres (other)
    a - pour tous (all)



Une autre notation sera utilisée pour attribuer et/ou retirer des droits.

    + (plus) pour attribuer
    - (moins) pour retirer
    = (égale) pour fixer l'accès exact

Affection récurssive (-R)
```bash
chmod -R +w repertoire
```
Clear les acccès
```bash
chmod o= fichier
```

```
SUID SGID Sticky bit
4000 2000 1000

SUID & u+x = s
SUID & u-x = S

GUID & g+x = s
GUID & g-x = S

Sticky bit & o+x = t
Sticky bit & o-x = T
```

### umask
umask défini les droit des fichier par défaut
```bash
umask 0022 fichier
```



## ACL

### getfacl


### setfacl
```bash
setfacl -Rm default:group:www-data:rwx /var/www
setfacl -Rm default:user:pnom:rwx /var/www
```
#### racourci
```bash
setfacl -RM d:g:www-data:rwx,d:u:pnom:rwx /var/www
```

```bash
setfacl -Rm d:g:userftp:rwx,d:u:userftp:rwx,d:o::rwx /mnt/md1/FTP/test/public
chmod 3777 /mnt/md1/FTP/test/public
```
