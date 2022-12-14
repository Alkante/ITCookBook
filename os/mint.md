# Linux Mint

## Activer l'hibernation

Prérequis : avoir un SWAP assez grand (dans l'idéal de la même taille que la RAM)

Source = https://www.fosslinux.com/45454/enable-hibernate-mode-linux-mint.htm

Ajouter / modifier dans /etc/default/grub :

```
GRUB_CMDLINE_LINUX="resume=/dev/mapper/vgmint-swap_1"
```

Régénérer la conf grup avec ```update-grub``` ou ```grub-mkconfig -o /boot/grub/grub.cfg```

Créer le fichier ```/etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla``` avec le contenu suivant :

```
[Enable hibernate]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions
ResultActive=yes
```

Redémarrer le PC, l'option devrait apparaitre dans l'interface graphique avec les options d'arrêt / veille.