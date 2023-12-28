#!/bin/bash

### Afficher rapidement l'espace disque disponnible ###
echo -e "\n### Espace disque ###\n"
df -h | grep --color -E 'Dispo|/$|/home$'

### Afficher rapidement des points de montage physique courant
echo -e "\n### Point de montage physique ###\n"
egrep --color '^/[^ ]+' /etc/mtab
