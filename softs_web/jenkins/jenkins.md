# Jenkins
## Installation
```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
```

Si problème de certificat. Faire un upgradate de ca-certificates


```bash
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install openjdk-8-jre openjdk-8-jdk
apt-get install jenkins
```


Ce connecter
```bash
http://localhost:8080/
```


### Si serveur sans accès http/https
Si c'est un serveur distant ou seul un acces via ssh est permi.

Il faut fait un tunnel ssh pour ce connecter.

Exécuté cette commande depuis VOTRE MACHINE
```bash
ssh -N -f -L 8080:localhost:8080 user@jenkins.exemple.com
```


### Si serveur avec service http/https

## Proxy apache
```bash
apt-get install apache2
a2enmod proxy
a2enmod proxy_http
a2dissite 000-default
```

Editer /etc/apache2/sites-available/jenkins.exemple.com.conf
```bash
vim /etc/apache2/sites-available/jenkins.exemple.com.conf
```

```text conf
<VirtualHost *:80>
	ServerAdmin admin@exemple.com
	ServerName jenkins.exemple.com
	ServerAlias ci
	ProxyRequests Off
<Proxy *>
	Order deny,allow
	Allow from all
</Proxy>
ProxyPreserveHost on
ProxyPass / http://localhost:8080/ nocanon
AllowEncodedSlashes NoDecode
</VirtualHost>
```

Puis

```bash
a2ensite jenkins.exemple.com
service apache2 restart
```

Ce connecter
```bash
http://jenkins.exemple.com
```

### Première connexion

Renseigner le AdminPassword, il est inscrit dans le fichier suivant
```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```


Puis, Selectionnner : intaller les plugins suggérés

Jenkins va installer les plugins suivants :
- Folders Plugin
- OWASP Markup Formatter Plugin
- build timeout plugin
- Credentials Binding Plugin
- Timestamper
- Workspace Cleanup Plugin
- Ant Plugin
- Gradle Plugin
- Pipeline
- GitHub Organization Folder Plugin
- Pipeline: Stage View Plugin
- Git plugin
- Subversion Plug-in
- SSH Slaves plugin
- Matrix Authorization Strategy Plugin
- PAM Authentication plugin
- LDAP Plugin
- Email Extension Plugin



## Interconnexion avec docker et jenkins
### docker
Sur l'interface de jenkins installer le plugin docker
Dans "Global Tool configuration" -> onglet "Docker" :
```
Name : Docker
Installation root : /usr/bin
Install automatically : []
```

### Sonar
Sur l'interface de jenkins installer le plugin sonarqube
Dans "Global Tool configuration" -> onglet "SonnarQubeScanner" :
```
Name : Sonarqube scanner
SONAR_RUNNER_HOME : /opt/sonar-scanner-2.7
Install automatically : []
```

Dans "Configuration" -> onglet "SonarQube servers"
```
Name : Sonar 6.0
Server URL : http://jenkins.exemple.com/sonar
Server version : 5.3 or higher
```

## Problème de sous processus
Jenkins créer des sous processus lors qu'il lance des processes, des dockers, vms. Il peut y avoir des problème de job qui ne se finisse jamais. Voici une solution possible:
```bash
echo 'JENKINS_ARGS="$JENKINS_ARGS --prefix="' >> /etc/default/jenkins
service jenkins restart
```
