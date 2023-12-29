# WiseMapping

## Sur debian wheezy
```
apt-get install openjdk-7-jdk

su - postgres
createuser -SDlPR user_wisemapping
> pass_wisemapping
createdb -T template0 --encoding='UTF-8' --lc-collate='fr_FR.UTF-8' --lc-ctype='fr_FR.UTF-8' -O user_wisemapping db_wisemapping
exit
```

### wisemapping-v4.0.3.zip
```
cd /usr/local/src/
git clone https://bitbucket.org/wisemapping/wisemapping-open-source.git
cd /usr/local/src/wisemapping-open-source/config/database/postgres/

psql -U user_wisemapping -W -d db_wisemapping -p 5432 -h localhost -f create-schemas.sql
psql -U user_wisemapping -W -d db_wisemapping -p 5432 -h localhost
INSERT INTO COLLABORATOR (id, email, creation_date) VALUES (1, 'test@wisemapping.org', now()::date);
INSERT INTO COLLABORATOR (id, email, creation_date) VALUES (2, 'admin@wisemapping.org', now()::date);
INSERT INTO "user" (colaborator_id, firstname, lastname, password, activation_code, allow_send_email,authentication_type) VALUES (1, 'Test', 'User', 'ENC:a94a8fe5ccb19ba61c4c0873d391e987982fbbd3', 1237,  1,'D');
INSERT INTO "user" (colaborator_id, firstname, lastname, password, activation_code, allow_send_email,authentication_type) VALUES (2, 'Admin', 'User', 'admin', 1237, 1,'D');

cd /usr/local/src
apt-get install maven
wget http://wwwftp.ciril.fr/pub/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar -xzf apache-maven-3.3.9-bin.tar.gz
rm /usr/bin/mvn
ln -s /etc/alternatives/mvn /usr/bin/mvn
rm /etc/alternatives/mvn
ln -s /usr/local/src/apache-maven-3.3.9/bin/mvn /etc/alternatives/mvn
git clone https://bitbucket.org/wisemapping/wisemapping-open-source.git
cd wisemapping-open-source
```
editer /usr/local/src/wisemapping-open-source/pom.xml pour activer postgres
```
mvn clean install -U -Dmaven.test.skip=true

mkdir /home/www/framasoft/wisemapping
```
copier le war de /root/.m2/repository vers /home/www/framasoft/wisemapping
```
cd /home/www/framasoft/wisemapping
jar xf wise-webapp.war
```
editer WEB-INF/app.properties
```
database.url=jdbc:postgresql://localhost:5432/db_wisemapping
database.driver=org.postgresql.Driver
database.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
database.username=user_wisemapping
database.password=pass_wisemapping
site.baseurl = http://app.exemple.com/wisemapping
```
ajouter dans ./WEB-INF/wisemapping-dao.xml, dessous <prop key="hibernate.dialect">${database.hibernate.dialect}</prop> :
```
<prop key="hibernate.default_schema">public</prop>

echo '<Context path="/framindmap" debug="0" privileged="true" allowLinking="true"
         docBase="/home/www/framasoft/wisemapping/">
</Context>' > /etc/tomcat7/Catalina/localhost/framindmap.xml
```

chemin du log dans /home/www/framasoft/wisemapping/WEB-INF/classes/log4j.properties
```
log4j.appender.R.File=/var/log/tomcat7/wisemapping.log
```
```
/etc/init.d/tomcat7 restart
```

login par défaut : User: test@wisemapping.org Password: test

## Avec tomcat8
http://www.jouvinio.net/wiki/index.php/Installation_Wisemapping

## Source code
https://bitbucket.org/wisemapping/wisemapping-open-source/pull-requests/
