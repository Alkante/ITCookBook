
# Symfony


<!-- TOC -->

- [Symfony](#symfony)
    - [Installation de symfony](#installation-de-symfony)
    - [Installation de composer](#installation-de-composer)
    - [Création d'un nouveau projet](#création-dun-nouveau-projet)
        - [Version standard 2.8](#version-standard-28)
    - [Version REST](#version-rest)
    - [Configuration pour dévelloper](#configuration-pour-dévelloper)
    - [OLD](#old)
        - [Install framework symphony 1.4.8 en mode core sur un serveur mutulais�](#install-framework-symphony-148-en-mode-core-sur-un-serveur-mutulais�)
        - [install framework](#install-framework)
        - [ajout site dans /home/www](#ajout-site-dans-homewww)
        - [le fichier /home/www/app.exemple.com/config/ProjectConfiguration.class.php fait appel au framework :](#le-fichier-homewwwappexemplecomconfigprojectconfigurationclassphp-fait-appel-au-framework-)
        - [droits](#droits)
        - [config apache](#config-apache)

<!-- /TOC -->

## Installation de symfony

Installer symfony en local

```bash
cd ~/var/softs
curl -LsS https://symfony.com/installer -o symfony
chmod u+x symfony
cd ~/bin
ln -s ~/var/softs/symfony
```

Ajouter dans votre **.barshrc**
```bash
export PATH="~/bin:$PATH"
```

## Installation de composer

Copier les ligne de code sdu site [https://getcomposer.org/download/](https://getcomposer.org/download/)

Exemple :
```bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
```

## Création d'un nouveau projet

### Version standard 2.8
```bash
symfony new myproject 2.8
cd myproject
```

Création avec composer
```bash
composer create-project symfony/framework-standard-edition myproject "2.8.*"
cd myproject
```

## Version REST

Installer ajouter dans le **composer.json** require

```bash
"friendsofsymfony/rest-bundle": "dev-master",
"jms/serializer-bundle": "dev-master"
```

ou

```bash
php composer.phar require friendsofsymfony/rest-bundle:dev-master
php composer.phar require jms/serializer-bundle:dev-master
php composer.phar require nelmio/api-doc-bundle:dev-master
```

Puis updater le repos
```bash
php composer.phar update
```

Ajouter dans l'**app/AppKernel.php**

```
public function registerBundles()
    {
        $bundles = array(
            [...],
            new FOS\RestBundle\FOSRestBundle(),
            new JMS\SerializerBundle\JMSSerializerBundle(),
            new Nelmio\ApiDocBundle\NelmioApiDocBundle(),
```

Ajouter les configurations

```php app/config/config.yml
fos_rest:
    param_fetcher_listener: true
    body_listener: true
    format_listener: true
    view:
        view_response_listener: 'force'
        formats:
            xml: true
            json : true
        templating_formats:
            html: true
        force_redirects:
            html: true
        failed_validation: HTTP_BAD_REQUEST
        default_engine: twig
    routing_loader:
        default_format: json
```





## Configuration pour dévelloper

Désactiver les restrictions d'IP pour develloper sous symfony dans **web/app_dev.php**
Mettez en commentaire ces lignes

```php
if (isset($_SERVER['HTTP_CLIENT_IP'])
    || isset($_SERVER['HTTP_X_FORWARDED_FOR'])
    || !(in_array(@$_SERVER['REMOTE_ADDR'], ['127.0.0.1', '::1'], true) || PHP_SAPI === 'cli-server')
) {
    header('HTTP/1.0 403 Forbidden');
    exit('You are not allowed to access this file. Check '.basename(__FILE__).' for more information.');
}

```
app/AppKernel.php






## OLD

### Install framework symphony 1.4.8 en mode core sur un serveur mutulais�

### install framework
```
cd /usr/share/
mkdir symphony
cd symphony/
wget http://www.symfony-project.org/get/symfony-1.4.8.tgz
tar -xzvf symfony-1.4.8.tgz
mv symfony-1.4.8/* .
rm -rf symfony-1.4.8
rm symfony-1.4.8.tgz
chown www-data .
chgrp -R root .
chmod -R o-r-w-x .
php data/bin/symfony -V
```

### ajout site dans /home/www
### le fichier /home/www/app.exemple.com/config/ProjectConfiguration.class.php fait appel au framework :
```
require_once '/usr/share/symphony/lib/autoload/sfCoreAutoload.class.php';
```


### config apache
```
<VirtualHost 127.0.0.1:8080>
  DocumentRoot "/home/sfproject/web"
  DirectoryIndex index.php
  <Directory "/home/sfproject/web">
    AllowOverride All
    Allow from All
  </Directory>

  Alias /sf /home/sfproject/lib/vendor/symfony/data/web/sf
  <Directory "/home/sfproject/lib/vendor/symfony/data/web/sf">
    AllowOverride All
    Allow from All
  </Directory>
</VirtualHost>
```
