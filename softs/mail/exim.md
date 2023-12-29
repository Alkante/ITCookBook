# Exim4
config exim4 pour envoi vers SMTP orange
```
apt-get install mailx exim4
dpkg-reconfigure -plow exim4-config
vi /etc/exim4/update-exim4.conf.conf
echo "smtp.orange.fr:p.nom:password" >> /etc/exim4/passwd.client
echo "MAIN_TLS_ENABLE = true
AUTH_CLIENT_ALLOW_NOTLS_PASSWORDS=yes" >> /etc/exim4/exim4.conf.localmacros
/etc/init.d/exim4 stop
update-exim4.conf
/etc/init.d/exim4 start
mail -vs titre_msg p.nom2@exemple.com < test
```
