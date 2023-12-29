# PAM

(Pluggable Authentication Modules, modules d'authentification enfichables)

Permettent de paramétrer à l'envie les procédures et sources d'authentification, mais aussi d'offrir des services supplémentaires aux programmes qui savent les utiliser. C'est un premier pas pour la mise en place d'un SSO (Single Sign-On, authentification unique en français) sur un système Unix/Linux, ses applications, et même au-delà.

	/etc/pam.conf     # Ficher de configuration, a normalement n'utilisé que si le dossier /etc/pam.d/* n'existe pas
	/etc/pam.d/*      # Dossier contenant les authentification pam des services (privilégier)


Exemple de fichier de configuration : authentification par mot de passe sur sshd

	vim /etc/pam.d/sshd

Les sous fichier de configuration (fichier générique inclue par les fichier de configuration) sont :

	/etc/pam.d/common-account
	/etc/pam.d/common-auth
	/etc/pam.d/common-password
	/etc/pam.d/common-session
	/etc/pam.d/common-session-noninteractive


## Test auth
Install
```bash
apt install pamtester
```
Test
```bash
pamtester -v <service> <user> authenticate
```
Debug
```bash
tail -f /var/log/syslog
```
source : http://pamtester.sourceforge.net/
