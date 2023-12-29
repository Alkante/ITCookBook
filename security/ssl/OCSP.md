# Serveur OCSP (agrafage)
Permettant de vérifier la validité d'un certificat numérique. Celui-ci peut être mis en place au niveau du serveur pour que le client ne requête pas directement les serveurs OSCP. Cela permet de meilleur performance et un meilleur maintient de la vie privé.

## apache
/etc/apache2/apache2.conf
```
SSLStaplingCache shmcb:/tmp/stapling_cache(128000)
```
/etc/apache2/sites-enabled/4_0_test-letsencrypt.exemple.com.conf
```
SSLUseStapling          on
#SSLCACertificateFile /etc/apache2/ssl-cert/intermediate.pem
SSLStaplingResponderTimeout 5
SSLStaplingReturnResponderErrors off
```

## nginx
/etc/nginx/nginx.conf
```
# OCSP
ssl_stapling on;
ssl_stapling_verify on;
resolver 127.0.0.1;
```

## Source
- https://www.digitalocean.com/community/tutorials/how-to-configure-ocsp-stapling-on-apache-and-nginx
- https://fr.wikipedia.org/wiki/Agrafage_OCSP
