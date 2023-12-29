# Squashtm
Outillage du test fonctionnel https://www.squashtest.com/

## Getting started

La commande de base pour lancer le docker, `docker run --name='squash-tm' -it -p 8090:8080 squashtest/squash-tm`, génère des erreurs :

```
ESAPI: WARNING: System property [org.owasp.esapi.opsteam] is not set
ESAPI: WARNING: System property [org.owasp.esapi.devteam] is not set
ESAPI: Attempting to load ESAPI.properties via file I/O.
ESAPI: Attempting to load ESAPI.properties as resource file via file I/O.
ESAPI: Not found in 'org.owasp.esapi.resources' directory or file not readable: /opt/squash-tm/bin/ESAPI.properties
ESAPI: Not found in SystemResource Directory/resourceDirectory: .esapi/ESAPI.properties
ESAPI: Not found in 'user.home' (/home/squashtm) directory: /home/squashtm/esapi/ESAPI.properties
ESAPI: Loading ESAPI.properties via file I/O failed. Exception was: java.io.FileNotFoundException
ESAPI: Attempting to load ESAPI.properties via the classpath.
ESAPI: SUCCESSFULLY LOADED ESAPI.properties via the CLASSPATH from '/ (root)' using current thread context class loader!
ESAPI: SecurityConfiguration for Validator.ConfigurationFile.MultiValued not found in ESAPI.properties. Using default: false
ESAPI: SecurityConfiguration for Validator.ConfigurationFile not found in ESAPI.properties. Using default: validation.properties
ESAPI: Attempting to load validation.properties via file I/O.
ESAPI: Attempting to load validation.properties as resource file via file I/O.
ESAPI: Not found in 'org.owasp.esapi.resources' directory or file not readable: /opt/squash-tm/bin/validation.properties
ESAPI: Not found in SystemResource Directory/resourceDirectory: .esapi/validation.properties
ESAPI: Not found in 'user.home' (/home/squashtm) directory: /home/squashtm/esapi/validation.properties
ESAPI: Loading validation.properties via file I/O failed.
ESAPI: Attempting to load validation.properties via the classpath.
ESAPI: SUCCESSFULLY LOADED validation.properties via the CLASSPATH from '/ (root)' using current thread context class loader!
ESAPI: SecurityConfiguration for ESAPI.printProperties not found in ESAPI.properties. Using default: false
ESAPI: SecurityConfiguration for Encryptor.CipherTransformation not found in ESAPI.properties. Using default: AES/CBC/PKCS5Padding
```

Il faut télécharger un fichier de properties pour le package `org.owasp.esapi` :

```
wget https://raw.githubusercontent.com/OWASP/EJSF/master/esapi_master_FULL/WebContent/ESAPI.properties
```

Et lancer le docker avec ce fichier :

```
docker run --rm --name='squash-tm' -it -v $(pwd)/ESAPI.properties:/opt/squash-tm/bin/ESAPI.properties -p 8090:8080 squashtest/squash-tm
```

## Installation en production

Dépôt docker hub : https://hub.docker.com/r/squashtest/squash-tm

Documentation d'installation (toutes versions confondues) : https://tm-fr.doc.squashtest.com/v3/install-guide/installation-squash/config-mini-prerequis.html

Notes importantes :

 * de base, le docker fonctionne avec une bdd interne H2, non recommandé pour la production => préférer MariaDb ou PostgreSQL (voir plus bas)
 * il est possible de monter Squash sur des versions récentes Potgresql 13 ou Mariadb 10.5
 * par défaut, toutes les pièces-jointes sont stockées en base, il existe une option pour activer le stockage fichier sur disque : https://tm-fr.doc.squashtest.com/v3/install-guide/externalisation-pj/externalisation-pj.html

## Docker Squash + PostgreSQL

Adapter l'exmple docker-compose.yml : https://bitbucket.org/squashtest/docker-squash-tm/src/master/docker-compose-postgres/

 * installer un service postgres 13
 * monter le fichier `ESAPI.properties` en volume sur le service squash
 * activer le stockage des fichiers sur disque
