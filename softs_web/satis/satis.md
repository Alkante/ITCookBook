# Statis

## Pré installation
Installer php
```bash
apt-get install php5-common libapache2-mod-php5 php5-cli git subversion
```

Donner les droits www-data à un utilisateur
```bash
usermod -a -G www-data satis
```

## Installation

```bash
mkdir /home/satis.exemple.com
cd /home/satis.exemple.com
chown -R www-data: /home/satis.exemple.com
chmod -R g+rw /home/satis.exemple.com
```

Passer en mode utilisateur
```bash
su -l satis
cd /home/satis.exemple.com
```

Télécharger composer

```bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
```

Télécharger satis
```bash
php composer.phar create-project composer/satis:dev-master --keep-vcs
```

```bash
cd satis
vim config.json
```

```txt
{
    "name": "My Repository",
    "homepage": "http://ci.exemple.com",
    "repositories": [
        { "type": "vcs", "url": "https://github.com/symfony/yaml" }
    ],
    "require": {
        "symfony/yaml": "v3.2.1"
    }
}

{
  "name": "Basic IT",
  "homepage": "http://packages.basicit.company",
  "repositories": [
    {
      "type": "vcs",
      "url": "git@bitbucket.org:BasicIT/reksai.git"
    }
  ],
  "require-all": true
}
```

en Root
```bash
su -l root
chown -R www-data: /home/satis.exemple.com
chmod -R g+rw /home/satis.exemple.com
exit
cd /home/satis.exemple.com/satis
```



Lancer la génération
```bash
php bin/satis build config.json web
```


## Authentification avec gitlab
```bash
{
        "name": "depot/php",
        "homepage": "http://satis.exemple.com/",
        "repositories": [
                {
                "type":"vcs",
                "url":"git@git.exemple.com:/var/opt/gitlab/git-data/repositories/group/project.git"
                }
        ],
        "require-all": true
}
```
Dans le .ssh/config
```
Host git.exemple.com
     HostName git.exemple.com
     User git
     Port 22
     IdentityFile /home/satis.exemple.com/ssh/id_rsa
```
Mettre votre clé ssh dans
```
/var/opt/gitlab/.ssh/authorized_keys
```
