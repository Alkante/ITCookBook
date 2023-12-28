# OS info
## Nom de la machine
```
hostname -s
```

## Taux de charge moyen total des CPUs sur 1 min, 5 min, 15 min
```bash
uptime | sed 's/.*load average: \(.*\), \(.*\), \(.*\)/\1 \2 \3/'
## OU Directement depuis le /proc
cat /proc/loadavg | awk '{ print $1, $2, $3 }'
```
Résultat : 0,28 0,36 0,27

## Nombre de CPU physique
```bash
igrep "physical id" /proc/cpuinfo |uniq |wc -l
```

## Nombre de coeur par CPU
```bash
echo "$(grep -c "processor" /proc/cpuinfo) / $(grep "physical id" /proc/cpuinfo |sort -u |wc -l)" | bc
```

## Nombre de CPU logiques
```bash
grep "physical id" /proc/cpuinfo |wc -l
```

## Taille mémoire ram total en Ko
```bash
cat /proc/meminfo | grep MemTotal | awk '{ print $2 }'
```

## Espace des disques montés
```bash
df -hl | grep '^/dev' | awk '{print $1" "$6" "$3"/"$2 }'
```

## Marque du CPU
```bash
cat /proc/cpuinfo | grep "model name" | cut -c14- | uniq
```

## Taille total des disques physiques
```bash
fdisk -l | grep 'Disk /dev/s*' | sed 's/^Disk[ ]*\(\/dev\/.*\):[ ]*\([0-9\.]*\)[ ]*\([a-zA-Z]*\).*/\1 \2 \3/g'
```

## Version du noyau
```bash
uname -r
```
ou depuis le /rpoc
```bash
cat /proc/version | awk '{print $3}'
```

## Version de la distribution : À améliorer
```bash
cat /etc/issue
```

## Version précise de la distribution : À améliorer
```bash
cat /etc/debian_version
```

## Avoir une idée des dépôts utilisés : À améliorer
```bash
cat /etc/apt/sources.list|grep "deb http" | awk '{print $3}'
```

## generer la liste des paquets installés
```bash
dpkg --get-selections | grep -v deinstall > packages_list_snapshot
```

## List des paquets ajoutés manuellement depuis le début de la production
```bash
comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u) > manual_added_package_list.txt
```
