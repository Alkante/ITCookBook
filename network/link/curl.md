# cURL
cURL permet de télécharger et d'envoyer des message et/ou des fichier au travers de nombreux protocoles de communication.

### Téléchargement simple
```bash
curl http://www.exemple.fr
```
ou
```bash
curl http://www.exemple.fr > save.html
```
ou
```bash
curl -o save.html http://www.exemple.fr
```
ou
```bash
curl -O http://www.exemple.fr
```

### Téléchargement multiple
```bash
curl -O http://www.exemple.fr -O http://www.toto.fr
```

### Reprendre un téléchargement
```bash
curl -C - -O http://www.exemple.fr
```

### Limiter le taux de transfert
```bash
curl --limit-rate 1MB -O http://www.exemple.fr
```

### Télécharger que si il y eu modification (test de la date)
```bash
curl -z -12-Jan-13 http://www.exemple.fr
```

### Télécharger avec authentification htacces
```bash
curl -u login:password http://www.exemple.fr
```

### Télécharger via FTP (fichier ou dossier)
```bash
curl -u ftpuser:ftppassword -O ftp://ftp.exemple.fr/dosier1/
```

### Téléversé via FTP (fichier ou dossier)
```bash
curl -u ftpuser:ftppassword -T fichier1 -O ftp://ftp.exemple.fr/dosier1/
```
ou
```bash
curl -u ftpuser:ftppassword -T "{fichier1,dosier2}" -O ftp://ftp.exemple.fr/dosier1/
```

### Utiliser les expression réguliaire (RegEx)
```bash
curl http://www.exemple.fr/[a-z]/
```

### Activer les informations et les traces
```bash
curl -v http://www.exemple.fr
```
```bash
curl --trace http://www.exemple.fr
```

### Utiliser le protocole dict pour obtenir la définition d'un mot
```bash
curl dict://dict.org/d:bash
```

### Utiliser un proxy
```bash
curl -x proxy.exemple.fr:3128 http://exemple.fr
```

### Envoyer un email
```bash
curl --mail-from toto@exemple.fr --mail-tcpt tartanpion@exemple.fr smtp://smtp.exemple.fr
```
