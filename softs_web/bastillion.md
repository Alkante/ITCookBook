# Bastillion
## Objectif
Avoir une interface pour donner des consoles au développeur.

## Installation
```bash
wget https://github.com/bastillion-io/Bastillion/releases/download/v3.05.01/bastillion-jetty-v3.05_01.tar.gz
tar -xvf bastillion-jetty-v3.05_01.tar.gz
cd Bastillion-jetty
./startBastillion.sh
```
## Installation docker
```bash
wget https://github.com/bastillion-io/Bastillion/releases/download/v3.05.01/bastillion-jetty-v3.05_01.tar.gz
tar -xvf bastillion-jetty-v3.05_01.tar.gz
```
Script start-docker-bastillion.sh :
```bash
#!/bin/bash
DOCKER_NAME="bastillion-console"
docker rm -f $DOCKER_NAME
docker run \
	--restart always -d \
	-p 8443:8443 \
	--name="$DOCKER_NAME" \
	-v `pwd`/docker-root:/root \
	-v `pwd`/Bastillion-jetty:/home/bastillion \
	-e "TZ=Europe/Paris" \
	openjdk:11-stretch \
	/bin/bash -c "/root/start-bastillion.sh"
```
Créer un dossier docker-root avec le CA exemple.com (CA_exemple.com.crt) et le script de lancement (start-bastillion.sh) :
```bash
#!/bin/bash
cp /root/CA_exemple.com.crt /usr/local/share/ca-certificates/
update-ca-certificates
cd /home/bastillion/jetty
java -Xms1024m -Xmx1024m -jar start.jar
```

## Configuration
### BDD pass
Run docker
```bash
docker run \
	--restart always -it \
	-p 8443:8443 \
	--name="bastillion-console" \
	-v `pwd`/docker-root:/root \
	-v `pwd`/Bastillion-jetty:/home/bastillion \
	-e "TZ=Europe/Paris" \
	openjdk:11-stretch \
	/bin/bash -c "/root/start-bastillion.sh"
```

### Désativation double auth
```bash
sed -i 's/^oneTimePassword=.*$/oneTimePassword=disabled/' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
```

### LDAP
```bash
sed -i 's/^jaasModule=.*$/jaasModule=ldap-ad/' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
sed -i '/ldap-ad {/,/};/{d;s/ ,$//}' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/jaas.conf
cat << \EOF >> Bastillion-jetty/jetty/bastillion/WEB-INF/classes/jaas.conf

ldap-ad {
    //AD example config
    com.sun.security.auth.module.LdapLoginModule REQUIRED
    userProvider="ldaps://ldap.exemple.com:636/OU=Utilisateurs,DC=exemple,DC=com"
    //authIdentity="cn={USERNAME},OU=Utilisateurs,DC=exemple,DC=com"
    userFilter="(&(samAccountName={USERNAME})(objectClass=user)(memberOf=CN=dev,OU=Groupes,DC=exemple,DC=com))"
    authzIdentity="{displayName}" //set this to return full name
    java.naming.security.authentication="simple"
    java.naming.security.principal="CN=read-only,OU=Utilisateurs,DC=exemple,DC=com"
    java.naming.security.credentials="YYYYYY"
    useSSL=false
    debug=false;
};
EOF
```

### SSH jenkins-dev
```bash
mkdir docker-root/.ssh
cat << \EOF > docker-root/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-----END RSA PRIVATE KEY-----
EOF
cat << \EOF > docker-root/.ssh/id_rsa.pub
ssh-rsa YYYYYYYYYYYYYY== jenkins@jenkins
EOF
sed -i 's|^resetApplicationSSHKey=.*$|resetApplicationSSHKey=true|' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
sed -i 's|^privateKey=.*$|privateKey=/root/.ssh/id_rsa|' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
sed -i 's|^publicKey=.*$|publicKey=/root/.ssh/id_rsa.pub|' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
sed -i 's|^keyManagementEnabled=.*$|keyManagementEnabled=false|' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
sed -i 's|^forceUserKeyGeneration=.*$|forceUserKeyGeneration=false|' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
sed -i 's|^clientIPHeader=.*$|clientIPHeader=X-Forwarded-For|' Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties
```
