# APT
## Installation d'un paquet backports
### Ajout backports :
```bash
echo 'deb http://deb.debian.org/debian stretch-backports main contrib non-free
' > /etc/apt/sources.list.d/debian_backports.list
apt update
```
### Mettre une priorité faible pour le dépôt backports. Récuération du label:
```bash
apt-cache policy
```
```
100 http://deb.debian.org/debian stretch-backports/contrib amd64 Packages
    release o=Debian Backports,a=stretch-backports,n=stretch-backports,l=Debian Backports,c=contrib,b=amd64
    origin deb.debian.org
```
A partir du retour construire un fichier de préférence :
```bash
echo 'Package: *
Pin: release o=Debian Backports,a=stretch-backports,n=stretch-backports,l=Debian Backports
Pin-Priority: 400
' > /etc/apt/preferences.d/debian_backports
apt update
```
Exemple :
```
root@x121:~# apt-cache policy tesseract-ocr-eng
tesseract-ocr-eng:
  Installé : 3.04.00-1
  Candidat : 3.04.00-1
 Table de version :
     4.00~git28-f7a4c12-1~bpo9+1 100
        400 http://deb.debian.org/debian stretch-backports/main amd64 Packages
 *** 3.04.00-1 500
        500 http://mirror.exemple.com/ftp.fr.debian.org/debian stretch/main amd64 Packages
        100 /var/lib/dpkg/status
```
### Installation
Check dépendance
```bash
apt-get install -sV -t stretch-backports tesseract-ocr tesseract-ocr-fra
```
Installation
```bash
apt-get install tesseract-ocr=4.0* tesseract-ocr-fra=4.0* tesseract-ocr-eng=4.0* tesseract-ocr-osd=4.0*
```

### Installation avec ansible
```
tools_additional:
  - tesseract-ocr=4.0*
  - tesseract-ocr-fra=4.0*
  - tesseract-ocr-eng=4.0*
  - tesseract-ocr-osd=4.0*

apt_repository_repositories:
  - repo: deb http://deb.debian.org/debian stretch-backports main contrib non-free
    default: release o=Debian Backports,a=stretch-backports,n=stretch-backports,l=Debian Backports
    priority: 400
```

## Suivi patch CVE
Voici un exemple de suivi de patch de sécurité sur le paquet php7.4
https://security-tracker.debian.org/tracker/source-package/php7.4
