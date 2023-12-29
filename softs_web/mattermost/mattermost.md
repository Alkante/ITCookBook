# Mattermost
## Installation du serveur
	apt-get install postgresql postgresql-contrib

### Configuration de postgres
	su postgres
	psql
	CREATE DATABASE mattermost;
	CREATE USER mmuser WITH PASSWORD 'bonjour';
	GRANT ALL PRIVILEGES ON DATABASE mattermost to mmuser;
	\q
	exit

Modifier le fichier /etc/postgresql/9.4/main/postgresql.conf
Enlever le commentaire pour la ligne "listen_adresses"

Puis:

	 /etc/init.d/postgresql reload

Test de connexion :

	psql --host=127.0.0.1 --dbname=mattermost --username=mmuser --password
	\q

### Configuration de Mattermost
	cd /opt/
	wget https://releases.mattermost.com/3.2.0/mattermost-team-3.2.0-linux-amd64.tar.gz
	tar -xvf mattermost-team-3.2.0-linux-amd64.tar.gz
	rm mattermost-team-3.2.0-linux-amd64.tar.gz
	cd mattermost
	mkdir data

	useradd -r mattermost -U
	chown -R mattermost:mattermost /opt/mattermost
	chmod -R g+w /opt/mattermost

Modifier le fichier /opt/mattermost/config/config.json
Dans DriverName mettre "postgres"
Dans DataSource mettre "postgres://mmuser:bonjour@127.0.0.1:5432/mattermost?sslmode=disable&connect_timeout=10"
Modifier les valeurs de PublicLinkSalt, InviteSalt, PasswordResetSalt, AtRestEncryptKey

Test du serveur :
	/opt/mattermost/bin/platform

### Mattermost en service
	vim /etc/systemd/system/mattermost.service
Contenu :

	[Unit]
	Description=Mattermost is an open source, self-hosted Slack-alternative
	After=syslog.target network.target postgresql.service

	[Service]
	Type=simple
	User=mattermost
	Group=mattermost
	ExecStart=/opt/mattermost/bin/platform
	PrivateTmp=yes
	WorkingDirectory=/opt/mattermost
	Restart=always
	RestartSec=30
	LimitNOFILE=49152

	[Install]
	WantedBy=multi-user.target

Puis :

	systemctl daemon-reload
	systemctl enable mattermost
	systemctl start mattermost



### Nginx
	apt-get install nginx
	vim /etc/nginx/sites-available/mattermost

Contenu :

	server {
	server_name mattermost.exemple.com;

	location / {
   		client_max_body_size 50M;
   		proxy_set_header Upgrade $http_upgrade;
   		proxy_set_header Connection "upgrade";
   		proxy_set_header Host $http_host;
   		proxy_set_header X-Real-IP $remote_addr;
   		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   		proxy_set_header X-Forwarded-Proto $scheme;
   		proxy_set_header X-Frame-Options SAMEORIGIN;
   		proxy_pass http://127.0.0.1:8065;
	}
 	}

Puis :
	rm /etc/nginx/sites-enabled/defaul
	ln -s /etc/nginx/sites-available/mattermost /etc/nginx/sites-enabled/mattermost
	service nginx restart


## Changement d'adrresse mail avec gitlab
```
ssh root@mattermost.exemple.com
su postgres
psql
\c mattermost
select username,nickname , email from users;
update users set email = 'p.nom@exemple.com' , nickname = 'Prénom NOM' where username = 'pnom';
\q
```

## Installation du client
Télécharger la derniere version :

https://github.com/mattermost/desktop/releases



## Upgrade mattermost
* Download : https://about.mattermost.com/download/
* Changelog : https://docs.mattermost.com/administration/changelog.html
* UpgradeGuide : https://docs.mattermost.com/administration/upgrade.html
* Changelog important : https://docs.mattermost.com/administration/important-upgrade-notes.html
```bash
# Télécharger les sources et backup la bdd
cd /opt
wget https://releases.mattermost.com/5.36.1/mattermost-5.36.1-linux-amd64.tar.gz
tar -xf mattermost*.gz --transform='s,^[^/]\+,\0-upgrade,'
pg_dump mattermost > db_postgres_mattermost-3.4
exit

# Couper le service
systemctl stop mattermost
ps aux |grep mattermost

# Déplacer les versions
mv mattermost mattermost-5.25
mv mattermost-upgrade mattermost

# Recupération données et config
mv mattermost/config/config.json mattermost/config/config.json.bak
cp mattermost-5.25/config/config.json mattermost/config/
cp -r mattermost-5.25/data mattermost/

# Droits
chown -R mattermost: mattermost
```
Test
```
./bin/mattermost
```
Run
```
chown -R mattermost: mattermost
systemctl start mattermost
ps aux |grep mattermost
```

## Webhook
Exemple curl :
```
curl -i -X POST -d "payload={\"username\": \"WIFI\",\"icon_url\":\"http://icons.iconarchive.com/icons/custom-icon-design/mono-general-3/256/wifi-icon.png\",\"text\": \"Mot de passe visiteur de la semaine (login: visiteur):\n\`\`\`$PASSWD\`\`\`\"}" http://mattermost.exemple.com/hooks/uddjhddkfjr19c7gbxnyams4ca
```
