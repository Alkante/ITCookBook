# Zimbra
<!-- TOC -->

- [Zimbra](#zimbra)
  - [Documentation](#documentation)
  - [Connexion](#connexion)
  - [Service control](#service-control)
    - [Status](#status)
    - [Start](#start)
    - [Stop](#stop)
    - [Reload](#reload)
    - [Affichage version](#affichage-version)
    - [Affichage configuration local](#affichage-configuration-local)
    - [Affichage password pour root mysql](#affichage-password-pour-root-mysql)
    - [Affichage password pour zimbra mysql](#affichage-password-pour-zimbra-mysql)
    - [Connexion mysql avec le compte root](#connexion-mysql-avec-le-compte-root)
  - [Gestion des users](#gestion-des-users)
    - [Afficher la liste des utilisateurs](#afficher-la-liste-des-utilisateurs)
    - [creation compte user:](#creation-compte-user)
    - [suppression compte usr:](#suppression-compte-usr)
    - [provision avec (password + cos default\_customers + change pass obligatoire à la première connexion)](#provision-avec-password--cos-default_customers--change-pass-obligatoire-à-la-première-connexion)
    - [provision avec nom et prenom](#provision-avec-nom-et-prenom)
    - [rendre le user de type admin](#rendre-le-user-de-type-admin)
    - [recreate spam virus wiki accounts](#recreate-spam-virus-wiki-accounts)
    - [Search deleted accounts](#search-deleted-accounts)
    - [Reindexation](#reindexation)
  - [rename account](#rename-account)
  - [add alias to account](#add-alias-to-account)
  - [delete alias from account](#delete-alias-from-account)
    - [create list diff](#create-list-diff)
    - [change identity (replyto, etc...)](#change-identity-replyto-etc)
    - [sendas / persona](#sendas--persona)
- [Gestion d'une BAL](#gestion-dune-bal)
  - [Afficher répertoire utilisateur](#afficher-répertoire-utilisateur)
  - [lire les dossiers](#lire-les-dossiers)
  - [lire tous les dossiers](#lire-tous-les-dossiers)
  - [Recherches dans une BAL](#recherches-dans-une-bal)
    - [Rechercher des messages et les effacer](#rechercher-des-messages-et-les-effacer)
    - [Recherche big messages](#recherche-big-messages)
    - [Lire le msg trouvé](#lire-le-msg-trouvé)
    - [Info sur le store du message](#info-sur-le-store-du-message)
    - [Rechercher dans toutes les boites](#rechercher-dans-toutes-les-boites)
  - [Lire un message (id du message) , chemin, dossier...](#lire-un-message-id-du-message--chemin-dossier)
  - [tracer un mail](#tracer-un-mail)
  - [Envoi d'un fichier dans une BAL](#envoi-dun-fichier-dans-une-bal)
    - [en REST](#en-rest)
    - [en curl](#en-curl)
- [Configuration](#configuration)
  - [Autoriser l'utilisation des mots de passe en clair via pop et imap](#autoriser-lutilisation-des-mots-de-passe-en-clair-via-pop-et-imap)
  - [Lister les services actifs](#lister-les-services-actifs)
  - [Lister les services installés](#lister-les-services-installés)
  - [desactiver un service](#desactiver-un-service)
  - [lister les restrictions mta](#lister-les-restrictions-mta)
  - [taille des file upload](#taille-des-file-upload)
  - [taille des mails mta](#taille-des-mails-mta)
  - [modifier le poll des comptes externes (account ou cos)](#modifier-le-poll-des-comptes-externes-account-ou-cos)
  - [visualiser les comptes externes](#visualiser-les-comptes-externes)
  - [lister les quotas](#lister-les-quotas)
    - [check config postfix](#check-config-postfix)
  - [ldap search](#ldap-search)
    - [Basic search:](#basic-search)
    - [ldap explorer](#ldap-explorer)
  - [Backup (pro)](#backup-pro)
    - [Cron](#cron)
  - [backup](#backup)
  - [Restore (pro)](#restore-pro)
    - [list des backups](#list-des-backups)
    - [maintenance](#maintenance)
    - [restore](#restore)
  - [disk usage backups](#disk-usage-backups)
  - [query last backups](#query-last-backups)
  - [restauration manuelle de messages à partir d'un backup opensource](#restauration-manuelle-de-messages-à-partir-dun-backup-opensource)
  - [mailq](#mailq)
    - [liste les mails dans la file pour evenements@app11.com](#liste-les-mails-dans-la-file-pour-evenementsbipelcom)
  - [divers](#divers)
    - [tunning ram](#tunning-ram)
    - [ne pas être alerté en cas de virus](#ne-pas-être-alerté-en-cas-de-virus)
    - [scan manuel dossier](#scan-manuel-dossier)
    - [reinjecter un mail classé virus](#reinjecter-un-mail-classé-virus)
    - [ne pas blacklister l'IP des webmails](#ne-pas-blacklister-lip-des-webmails)
    - [changer l'intervalle de synchro avec un calendrier externe](#changer-lintervalle-de-synchro-avec-un-calendrier-externe)
    - [adresses de contact (rapports, etc...)](#adresses-de-contact-rapports-etc)
    - [changer domaine par défaut](#changer-domaine-par-défaut)
- [Gestion domaine](#gestion-domaine)
  - [create domain](#create-domain)
  - [delete domain](#delete-domain)
  - [create domain appartenant à une cos](#create-domain-appartenant-à-une-cos)
  - [lister les utilisateurs d'un domaine](#lister-les-utilisateurs-dun-domaine)
  - [lister sans les user spéciaux](#lister-sans-les-user-spéciaux)
  - [lister les domaines](#lister-les-domaines)
  - [DKIM / SPF](#dkim--spf)
    - [DKIM](#dkim)
    - [SPF](#spf)
- [Gestion des groupes](#gestion-des-groupes)
  - [creation groupe admin](#creation-groupe-admin)
  - [affectation des attributs au groupe admin](#affectation-des-attributs-au-groupe-admin)
  - [ajout d'un user au groupe](#ajout-dun-user-au-groupe)
  - [donne les droits de gestion de domaine au groupe admins@cdg00.fr](#donne-les-droits-de-gestion-de-domaine-au-groupe-adminscdg00fr)
  - [restrictions sur les listes de distribution:](#restrictions-sur-les-listes-de-distribution)
    - [accorder les membres de list1 à ecrire à list1](#accorder-les-membres-de-list1-à-ecrire-à-list1)
    - [lister les droits sur list1](#lister-les-droits-sur-list1)
    - [tester les ACL sur list1](#tester-les-acl-sur-list1)
    - [enlever une ACL](#enlever-une-acl)
- [COS](#cos)
  - [affectation d'une cos](#affectation-dune-cos)
  - [Remove debug](#remove-debug)
  - [Utiliser plusieurs boites dans l'interface : ajout de service@exemple.com pour l'utilisateur test@exemple.com (deprecated zimbra6)](#utiliser-plusieurs-boites-dans-linterface--ajout-de-serviceexemplecom-pour-lutilisateur-testexemplecom-deprecated-zimbra6)
  - [Partage dossier brouillon](#partage-dossier-brouillon)
- [ssl](#ssl)
  - [renouvellement des certificats self-signed](#renouvellement-des-certificats-self-signed)
  - [voir le crt](#voir-le-crt)
  - [voir le csr](#voir-le-csr)
  - [voir tous les crt](#voir-tous-les-crt)
  - [renouvellement des certificats self-signed](#renouvellement-des-certificats-self-signed-1)
  - [confidentialité freebusy (n'existe pas dans les cos)](#confidentialité-freebusy-nexiste-pas-dans-les-cos)
    - [lister les ACE](#lister-les-ace)
    - [trouver l'ID du groupe list1](#trouver-lid-du-groupe-list1)
- [Gestion calendrier](#gestion-calendrier)
  - [effacer un calendrier](#effacer-un-calendrier)
  - [sauver un calendrier](#sauver-un-calendrier)
  - [créer un calendrier](#créer-un-calendrier)
  - [importer calendrier](#importer-calendrier)
  - [contacts](#contacts)
    - [export d'un carnet (celui de la GAL)](#export-dun-carnet-celui-de-la-gal)
    - [créer un carnet](#créer-un-carnet)
    - [importer contacts](#importer-contacts)
    - [export contacts](#export-contacts)
    - [search contacts](#search-contacts)
    - [effacer contact](#effacer-contact)
  - [Create GAL](#create-gal)
  - [GAL multi domaine](#gal-multi-domaine)
    - [Effacement du compte GAL du domaine](#effacement-du-compte-gal-du-domaine)
    - [(re)création du compte gal du domaine](#recréation-du-compte-gal-du-domaine)
    - [Creation du répertoire du second addressbook](#creation-du-répertoire-du-second-addressbook)
    - [ajout du second addressbook au compte](#ajout-du-second-addressbook-au-compte)
    - [affichage des sources addressbook pour le compte](#affichage-des-sources-addressbook-pour-le-compte)
    - [récupération du password ldap](#récupération-du-password-ldap)
  - [actualisation d'une liste GAL](#actualisation-dune-liste-gal)
  - [post contact rest api](#post-contact-rest-api)
    - [distribution list](#distribution-list)
    - [creation avec un user](#creation-avec-un-user)
    - [add users to list1 list:](#add-users-to-list1-list)
  - [Transport map](#transport-map)
  - [Transport map : forward des mails vers certains domaines via un serveur relais](#transport-map--forward-des-mails-vers-certains-domaines-via-un-serveur-relais)
  - [bd berkeley (deprecated z8.7)](#bd-berkeley-deprecated-z87)
- [Admin Rights (delegate)](#admin-rights-delegate)
  - [get rights for account](#get-rights-for-account)
  - [droits pour un admin domaine (admin = admin@app7.com)](#droits-pour-un-admin-domaine-admin--adminquark-energiesfr)
  - [Export filter to another account](#export-filter-to-another-account)
    - [Création des dossiers avant l'import](#création-des-dossiers-avant-limport)
    - [Import](#import)
- [Provisioning rapide](#provisioning-rapide)

<!-- /TOC -->
## Documentation
https://wiki.zimbra.com/wiki/Zmmailbox

## Connexion
Pour avoir accès à toutes les commandes, il faut être connecté en tant qu'utilisateur zimbra.

```bash
su -l zimbra
```

## Service control

### Status
```bash
zmcontrol status
```
### Start
```bash
zmcontrol start
```

### Stop
```bash
zmcontrol stop
```

### Reload
```bash
zmcontrol reload
```

### Affichage version
```bash
zmcontrol -v
```

### Affichage configuration local
```bash
zmlocalconfig -s
```

### Affichage password pour root mysql
```bash
zmlocalconfig -s mysql_root_password
```

### Affichage password pour zimbra mysql
```bash
zmlocalconfig -s zimbra_mysql_password
```

### Connexion mysql avec le compte root
```bash
mysql -S /opt/zimbra/db/mysql.sock -u root --password=mysql_root_password
```

## Gestion des users

### Afficher la liste des utilisateurs
```bash
zmprov -l gaa
```
### creation compte user:
```bash
zmprov ca user2@app1.com YYYYYY
```

### suppression compte usr:
```bash
zmprov da user2@app1.com
```

### provision avec (password + cos default_customers + change pass obligatoire à la première connexion)
```bash
zmprov ca truc@app2.com password zimbraCOSId 8fb9300d-578b-4b25-b7bd-8de76f6c0904 zimbraPasswordMustChange TRUE
```

### provision avec nom et prenom
```bash
zmprov ca testa@app3.com passwd displayName "David TEST" givenName "David" sn "TEST"
zmprov ca "${address}" "${password}" displayName "${display}" givenName "${prenom}" sn "${nom}"
```
### rendre le user de type admin
```bash
zmprov ma user1@app1.com zimbraIsDelegatedAdminAccount TRUE
```

### recreate spam virus wiki accounts
```bash
zmprov ca virus-quarantine.Zhn3PtuhNv@app4.com fvKg1rQKUA amavisBypassSpamChecks TRUE zimbraAttachmentsIndexingEnabled FALSE zimbraIsSystemResource TRUE zimbraHideInGal TRUE zimbraMailMessageLifetime 7d zimbraMailQuota 0 description 'System account for Anti-virus quarantine'
zmprov ca spam.jc_mprcm@app4.com fvKgeerQKUA amavisBypassSpamChecks TRUE zimbraAttachmentsIndexingEnabled FALSE zimbraIsSystemResource TRUE zimbraHideInGal TRUE zimbraMailMessageLifetime 7d zimbraMailQuota 0 description 'Spam training account'
zmprov ca ham.gjky_frol@app4.com fvKgffQKUA amavisBypassSpamChecks TRUE zimbraAttachmentsIndexingEnabled FALSE zimbraIsSystemResource TRUE zimbraHideInGal TRUE zimbraMailMessageLifetime 7d zimbraMailQuota 0 description 'Non Spam training account'
zmprov mcf zimbraAmavisQuarantineAccount virus-quarantine.Zhn3PtuhNv@app4.com
zmprov mcf zimbraSpamIsSpamAccount spam.jc_mprcm@app4.com
zmprov mcf zimbraSpamIsNotSpamAccount ham.gjky_frol@app4.com
```

### Search deleted accounts
```bash
mysql
```
```sql
select email, from_unixtime(deleted_at) from zimbra.deleted_account order by deleted_at;
select email, from_unixtime(deleted_at) from zimbra.deleted_account where email='adgs.mairie@app5.com'
```

### Reindexation
Pour réindexer un compte :
```bash
zmprov ma compte@domain.tld zimbraAccountStatus maintenance
zmprov rim compte@domain.tld start
```
Pour voir l'évolution de l'indexation :
```bash
zmprov rim compte@domain.tld status
```
Quand c'est fini on remet le compte en actif :
```bash
zmprov ma compte@domain.tld zimbraAccountStatus active
```

## rename account

NB : voir ci-dessous la suppression d'alias si préalable nécessaire.

renommer p.nom@app6.com en p.nom@app7.com :

```bash
zmprov ra p.nom@app6.com p.nom@app7.com
```

## add alias to account

```bash
echo "aaa \""${dest_alias}"\" \""${alias}"\"" >> ${ZMPROV_CMD}
```

## delete alias from account

```bash
# zmprov raa compte alias
zmprov raa daad@app1.com maps@app1.com
```

### create list diff
```bash
zmprov adlm "all@${domaine}" "${address}"
```
### change identity (replyto, etc...)
```bash
zmprov cid "${dest_alias}" "${alias}" zimbraPrefIdentityName "${alias}" zimbraPrefReplyToDisplay "${display}" zimbraPrefReplyToAddress "${dest_alias}" zimbraPrefFromDisplay "${display}" zimbraPrefReplyToEnabled TRUE
```

### sendas / persona
sendas si le user est externe à zimbra: p.nom@app7.com peut envoyer en tant que p.nom@app8.com
```bash
zmprov ma p.nom@app7.com zimbraAllowFromAddress p.nom@app8.com
```
create persona pour le user externe
```bash
zmprov cid p.nom@app7.com p.nom_app8.com zimbraPrefFromAddress p.nom@app8.com
```
sendas si adresse interne à zimbra : p.nom@app7.com peut envoyer en tant que p.nom@app6.com
```bash
zmprov grr account p.nom@app6.com usr p.nom@app7.com sendAs
```
verif
```bash
zmprov ckr account p.nom@app6.com p.nom@app7.com sendAs
```

delegation de boite mail sous outlook:
p.nom1@app6.com se connecte au compte outlook de p.nom2@app6.com et peut lire/envoyer des messages en tant que p.nom2@app6.com:
```
zmprov grr account p.nom1@app6.com usr p.nom2@app6.com sendAs
zmprov grr account p.nom1@app6.com usr p.nom2@app6.com sendOnBehalfOf
```
en plus on transmet tous les mails de p.nom1 vers p.nom2 sans les garder:
```
zmprov ma p.nom1@app6.com zimbraPrefMailLocalDeliveryDisabled TRUE zimbraMailForwardingAddress p.nom2@app6.com
```

# Gestion d'une BAL

## Afficher répertoire utilisateur
```bash
zmmailbox -z -m user@monDomaine.com gaf
```

| Option | Description |
|------- |------------ |
| -z  | utiliser les droits de l'administrateur |
| -m  | spécifie pour quel utilisateur on liste les répertoires |
| gaf | Get All Folders |

## lire les dossiers
```bash
zmmailbox -z -m p.nom@exemple.com gaf
```
## lire tous les dossiers
```bash
for i in `zmprov gac`; do echo $i; for j in `zmprov -l gaa $i`;do echo $j;zmmailbox -z -m $j gaf;echo;done;echo;done
```

## Recherches dans une BAL

### Rechercher des messages et les effacer
```bash
iddel=`zmmailbox -z -m admin@exemple.com search -t message -l 1000 "Subject: Disk"|awk '{ if (NR!=1) {print}}'| grep mess | awk '{ print $2 "," }' | tr -d` '\n'
zmmailbox -z -m admin@exemple.com dm `echo $iddel`
```
la recherche est limitée à 1000 (25 par défaut), faire une boucle
```bash
iddel="string";a=0
while [ -n "$iddel" ];do a=$((a+1));echo $a;....;done
for ((a=0; a <= 15 ; a++)); do
echo $a; zmmailbox -z -m p.nom@app1.com search -t message -l 1000 "Subject: Mail Delivery System"|awk '{ if (NR!=1) {print}}'| grep mess | awk '{ print "dm " $2 }' > /tmp/todel
zmmailbox -z -m p.nom@app1.com < /tmp/todel
done
```

### Recherche big messages
```bash
zmmailbox -z -v -m rh@app.com s -t message "in:inbox size:>5MB"
zmmailbox -z -v -m rh@app3.com s -t message "size:>100MB"
1. 18550  mess   Rh                    Fwd: Partenariat PIF                                03/07/12 17:31
```

### Lire le msg trouvé
```bash
zmmailbox -z -v -m rh@app3.com gm 18550
```

### Info sur le store du message
```bash
zmmetadump -m rh@app3.com -i 18550
[Blob Path]
/opt/zimbra/store/0/136/msg/4/18550-61300.msg
```

### Rechercher dans toutes les boites
```bash
zmmboxsearch -m "*" -q "Subject:Facture date:yesterday"
```

## Lire un message (id du message) , chemin, dossier...
```bash
zmmailbox -z -v -m p.nom@exemple.com gm 37086
```

## tracer un mail
recherche de from p.nom@wanadoo.fr to prenom.nom@app9.com dans /var/log/mail.log.1
```bash
/opt/zimbra/libexec/zmmsgtrace /var/log/mail.log.1 -r prenom.nom@app9.com -s p.nom@wanadoo.fr

Tracing messages
        from p.nom@wanadoo.fr
        to prenom.nom@app9.com

Message ID 'XXXXXXXXXXXXXXXXx@email.android.com'
p.nom@wanadoo.fr -->
        prenom.nom@app9.com
  Recipient prenom.nom@app9.com
  Feb 17 11:19:59 - vm1 --> vm1.exemple.com:7025 (X.X.X.X:7025) status sent
```
le message a pour header : Message ID 'XXXXXXXXXXXXXXXXx@email.android.com'
on recherche dans les logs /opt/zimbra/log/mailbox.log* :
```
zgrep "XXXXXXXXXXXXXXXXx@email.android.com" /opt/zimbra/log/mailbox.log.2017-02-17.gz
2017-02-17 11:20:00,030 INFO  [LmtpServer-1419] [name=prenom.nom@app9.com;mid=28;ip=X.X.X.X;] mailop - Adding Message: id=54479, Message-ID=<XXXXXXXXXXXXXXXXx@email.android.com>, parentId=-1, folderId=2, folderName=Inbox.
```
on retrouve alors l'id du message dans zimbra (54479)

si le message existe encore, on peut obtenir des infos:
```
zmmetadump -m prenom.nom@app9.com -i 54479
invalid request: No such item: mbox=28, item=54479
com.zimbra.common.service.ServiceException: invalid request: No such item: mbox=28, item=54479
ExceptionId:main:YYYYYYY:YYYYYY
Code:service.INVALID_REQUEST
        at com.zimbra.common.service.ServiceException.INVALID_REQUEST(ServiceException.java:267)
        at com.zimbra.cs.mailbox.util.MetadataDump.getItemRow(MetadataDump.java:208)
        at com.zimbra.cs.mailbox.util.MetadataDump.doDump(MetadataDump.java:298)
        at com.zimbra.cs.mailbox.util.MetadataDump.main(MetadataDump.java:395)
```
ici le message n'existe plus

on recherche les autres occurences de "id=54479" dans mailbox.log:
```
zgrep "id=54479" mailbox.log.2017-02-1*
mailbox.log.2017-02-17.gz:2017-02-17 19:00:49,086 INFO  [qtp509886383-1551772:https://X.X.X.X:443/service/soap/MsgActionRequest] [name=prenom.nom@app9.com;mid=28;ip=80.15.59.104;ua=ZimbraConnectorForOutlook/8.5.0.1258;] mailop - moving Message (id=54479) to Folder Trash (id=3)

```
les message a été supprimé par l'utilisateur

## Envoi d'un fichier dans une BAL

### en REST
```bash
zmmailbox -z -m p.nom@exemple.com postRestURL --contentType "text/plain" "/Briefcase/fact3.txt" "/tmp/export/exp_fact"
```
```bash
zmmailbox -zadmin
mbox> selectMailbox p.nom@exemple.com
mbox p.nom@exemple.com> createfolder /Recovery
mbox p.nom@exemple.com> addMessage /Recovery /mnt/backup/tmp/store/0/18/msg/104/426598-1211126.msg
```

### en curl
```bash
curl -u testdev@exemple.com:YYYYYY --upload-file /tmp/mymessage.msg http://localhost/home/testdev@exemple.com/inbox
```



# Configuration
## Autoriser l'utilisation des mots de passe en clair via pop et imap
```bash
zmprov ms vm1.exemple.com zimbraReverseProxyPop3StartTlsMode on
zmprov ms vm1.exemple.com zimbraReverseProxyImapStartTlsMode on
```

## Lister les services actifs
``` bash
zmprov gs domain.com | grep zimbraServiceEnabled
```

## Lister les services installés
```bash
zmprov gs server.domain.com | grep zimbraServiceInstalled
```

## desactiver un service
```bash
zmprov -l ms server.domain.com -zimbraServiceEnabled imapproxy
```

## lister les restrictions mta
```bash
zmprov gacf | grep zimbraMtaRestriction
```

## taille des file upload
```bash
zmprov gacf | grep zimbraFileUploadMaxSize
```
## taille des mails mta
```bash
zmprov gacf | grep zimbraMtaMaxMessageSize
```

## modifier le poll des comptes externes (account ou cos)
```bash
zmprov mc ccloch zimbraDataSourceImapPollingInterval 15m
```

## visualiser les comptes externes
```bash
zmprov gds p.nom@exemple.com
```

## lister les quotas
```bash
zmprov gqu vm1.exemple.com
```
### check config postfix
```bash
zmlocalconfig | grep antispam_enable
```
milter timeout
```bash
zmlocalconfig | grep milter
```

## ldap search
### Basic search:
Recherche des passwords
```bash
zmlocalconfig -s | egrep "ldap_master_url|zimbra_ldap_userdn|zimbra_ldap_password"
```
```bash
ldapsearch -x -H $ldap_master_url -D $zimbra_ldap_userdn -w $zimbra_ldap_password
```
Specifying the 'people' ou as the search base. 'dc=example' and 'dc=com' will have to be replaced with your domain
```bash
ldapsearch -x -H $ldap_master_url -D $zimbra_ldap_userdn -w $zimbra_ldap_password -LLL -b 'ou=people,dc=example,dc=com'
```
Alternatively, using search filters, and also showing all accounts of the object class 'zimbraAccount'
```bash
ldapsearch -x -H $ldap_master_url -D $zimbra_ldap_userdn -w $zimbra_ldap_password -LLL '(&(objectClass=zimbraAccount)(ou:dn:=people))'
```
Using search base and showing the uid for admin accounts:
```bash
ldapsearch -x -H $ldap_master_url -D $zimbra_ldap_userdn -w $zimbra_ldap_password -b 'ou=people,dc=example,dc=com' -LLL '(&(uid=*)(zimbraIsAdminAccount=TRUE))' uid
```
Listing out all the servers:
```bash
ldapsearch -x -H $ldap_master_url -D $zimbra_ldap_userdn -w $zimbra_ldap_password -b 'cn=servers,cn=zimbra'
```
afficher les adresses mail (on enlève les comptes virtuels)
```bash
ldapsearch -x -H ldap://vm1.exemple.com:389 -D uid=zimbra,cn=admins,cn=zimbra -w OSHj8v4e -b 'ou=people,dc=exemple,dc=fr' -LLL '(&(objectClass=zimbraAccount)(!(zimbraIsExternalVirtualAccount=TRUE)))' zimbraMailDeliveryAddress
(zimbraAccountStatus=Active)(createTimestamp>=$displaydate))
```
Example using localconfig keys:
```bash
ldapsearch -x -D `zmlocalconfig -m nokey -s zimbra_ldap_userdn` -w `zmlocalconfig -m nokey -s zimbra_ldap_password` -h `hostname -f`
```
Searching against an AD server:
```bash
ldapsearch -H ldap://ad.example.net:3268  -D admin -x -w pass -b "ou=users,dc=example,dc=net"
```

### ldap explorer
sur un poste client http://www.ldapsoft.com/downloads610/LdapAdminTool-6.10.x-Linux-x64-Install.sh
Monter un tunnel SSH à partir du poste client vers zimbra (port LDAP distant vm1.exemple.com:389 du srv distant(vm1.exemple.com) redirigé vers 19101 local via un tunnel ssh)
```bash
ssh -N -f user@vm1.exemple.com -L19101:vm1.exemple.com:389
```
#les param de connexion sont alors les suivants (executer sur le server zimbra):
```bash
ldappass=`/opt/zimbra/bin/zmlocalconfig -s -m nokey zimbra_ldap_password`
ldapdn=`/opt/zimbra/bin/zmlocalconfig -s -m nokey zimbra_ldap_userdn`
echo "-x $ldappass -D $ldapdn"
#Hote = 127.0.0.1
#Port 19101
#Utilisateur: uid=zimbra,cn=admins,cn=zimbra
#pass : OSHj8v4e
```
## Backup (pro)
### Cron
Inscrire les taches
```bash
zmschedulebackup -R  f "0 1 * * 6" i "0 1 * * 0-5" d 2m "0 0 * * *"
```
vérifier la crontab zimbra:
```bash
crontab -l | grep back
0 1 * * 6  [ $(date +\%d) -le 07 ] && /opt/zimbra/bin/zmbackup -f -a all
0 1 * * 6  [ $(date +\%d) -gt 07 ] && /opt/zimbra/bin/zmbackup -i
0 1 * * 0-5,7 /opt/zimbra/bin/zmbackup -i   
0 5 * * * /opt/zimbra/bin/zmbackup -del 68d
```
## backup
suivi des logs lors d un backup
```
tail -f /opt/zimbra/log/zmmailboxd.out
```
annuler un backup en cours:
```
zmbackupabort --label full-20180309.090835.234
```
effacer backup:
```
zmbackup -del  full-20180309.090835.234
```
si backup sur NFS, alors les backups full peuvent poser pb (ParallelZipCopier stopped due to earlier error: Input/output)
essai avec:
```
/opt/zimbra/bin/zmbackup -f --noZip -a all
```
## Restore (pro)
### list des backups
```bash
zmbackupquery -a admin@zimbrademo.exemple.com --from "2011/04/25 22:00:00"
```
### maintenance
```bash
zmprov ma admin@zimbrademo.exemple.com  zimbraAccountStatus maintenance
```
### restore
```bash
zmrestore -a admin@zimbrademo.exemple.com -restoreToTime "2011/04/23 17:03:31 268" -lb full-20110422.230007.744 -ca -pre temp_
```
Restauration d'un backup après suppression
```bash
zmrestore -a n.hubert@app7.com -restoreToIncrLabel incr-20200122.000006.808 -lb full-20200104.000006.842 -br -ca -pre restore3_ --ignoreRedoErrors
```
```bash
zmrestore -d -a "compta@app10.com" -ca --prefix "restored_" -restoreToTime "2015/04/11 03:00:00"
```
restauration dans une BAL temporaire à partir d'un backup remonté de bacula:
```
mv /tmp/bacula_restore/opt/zimbra/backup/sessions/full-20190802.230004.621 /opt/zimbra/backup/sessions/
chown -R zimbra: /opt/zimbra/backup/sessions/full-20190802.230004.621
su - zimbra
zmrestore -d -a prenom.nom@app1.com --pre restore_ -ca -rf -lb full-20190802.230004.621
exit
```

## disk usage backups
```bash
for dir in `find /opt/zimbra/backup/sessions/ -maxdepth 1 -mindepth 1 -printf '\t%Ty%Tm%Td%TH%TM %h/%f\n' |sort -n| awk '{ print $2 }'`; do du -hs $dir;done
zmrestore -d -a "compta@app10.com" -ca --prefix "restored_" -restoreToTime "2015/04/11 03:00:00"
```
## query last backups
entre deux dates
```bash
su - zimbra -c "zmbackupquery -v --from 20160901000000 --to 20161001000000"
```
## restauration manuelle de messages à partir d'un backup opensource
```bash
zmprov getMailboxInfo p.nom@exemple.com
mailboxId: 402
quotaUsed: 3257900348
```
mailboxid=402
```bash
expr 402 % 100
```
2
pour cette boite le store est donc /opt/zimbra/store/0/402 => dossier à restaurer quelquepart
sur le serveur de backup, à partir des archives 33*.dar, on extrait uniquement les contenus présents dans store/0/402 vers /backup/disk2/extract/
```bash
dar -v -r -R /backup/disk2/extract/ -x 33_ZimbraBackup_20160820_FULL -g store/0/402
```
on choisit les mails à récupérer (fichires textes msg)
sur zimbra on ré-injecte les messages dans la boite du user, dans un répertoire /Recovery:
```bash
zmmailbox -zadmin
mbox> selectMailbox p.nom@exemple.com
mailbox: p.nom@exemple.com, size: 3.03 GB, messages: 24806, unread: 1736
authenticated as p.nom@exemple.com
mbox p.nom@exemple.com> addMessage /Recovery /tmp/tmp/   
33823 (/tmp/tmp/33660-141265.msg)
33824 (/tmp/tmp/33126-138182.msg)
```
## mailq
```bash
/opt/zimbra/postfix/sbin/postqueue -p
```
### liste les mails dans la file pour evenements@app11.com
```bash
/opt/zimbra/postfix/sbin/postqueue -p | egrep -v '^ *\('  | awk 'BEGIN { RS = "" } { if ($7 ~ "@app11.com") print $5 "/06-"$6 " " $7 " " $8} ' | sort | grep evenements@app11.com
```
## divers

### tunning ram
java 20-25% de la mémoire, pour 16Gb :
```
zmlocalconfig -e mailboxd_java_heap_size=4096
```
mysql innodb_buffer_pool_size
```
/opt/zimbra/libexec/zmmycnf > /tmp/newmycnf.txt
```
Apadter votre config :
```
diff /opt/zimbra/conf/my.cnf /tmp/newmycnf.txt
```
src : https://imanudin.net/2019/05/16/zimbra-tips-things-to-do-after-upgrading-ram/

### ne pas être alerté en cas de virus
```bash
zmprov mcf zimbraVirusWarnRecipient FALSE
zmamavisdctl reload
```

### scan manuel dossier
```
clamscan -i --database ~/data/clamav/db/  /tmp/quar/
```

### reinjecter un mail classé virus
on cherche le mail placé en quarantaine qui était destiné à p.nom4
```
su - zimbra
account=`zmprov gcf zimbraAmavisQuarantineAccount | awk '{ print $NF }'`
mailboxid=`zmprov gmi $account | awk '/mailboxId/ { print $NF }'`
cd /opt/zimbra/store/0/$mailboxid/msg
grep -rl p.nom4 .
```
on renvoie le mail placé en quarantaine à l'utilisateur final (p.nom4)
```
zmlmtpinject -r p.nom4@exemple.com -s p.nom@exemple.com -v 12160-60800.msg
```
cf reinject_quarantine.sh


### ne pas blacklister l'IP des webmails
```bash
zmprov mcf zimbraSmtpSendAddOriginatingIP FALSE
```
### changer l'intervalle de synchro avec un calendrier externe
```bash
zmprov mc cos_cdg35_direction zimbraDataSourceCalendarPollingInterval 1
```
### adresses de contact (rapports, etc...)
backups
```bash
zmprov mcf zimbraBackupReportEmailRecipients admin@exemple.com
zmlocalconfig -e smtp_destination=admin@exemple.com
```

### changer domaine par défaut
```bash
zmprov mcf zimbraDefaultDomainName app4.com
```
adresse quand alerte virus
```bash
zmlocalconfig -e av_notify_domain=app4.com
zmlocalconfig -e av_notify_user=admin@app4.com
```
# Gestion domaine

## create domain
```bash
zmprov cd app1.com
```
Associer un tag client au domaine:
```bash
zmprov md app1.com zimbraNotes client_0384
```

## delete domain
```bash
zmprov dd app1.com
```

## create domain appartenant à une cos
```bash
zmprov gd app3.com zimbraDomainDefaultCOSId 70847b56-6769-47f2-9185-a9c824e49dfc zimbraVirtualHostname webmail.app3.com
```

## lister les utilisateurs d'un domaine
```bash
zmprov -l gaa app1.com
```
## lister sans les user spéciaux
```bash
zmprov -l gaa zimbrademo.exemple.com|grep -v "^wiki@" |grep -v "^admin@" |grep -v "^spam\.*" |grep -v "^ham\.*"
```

## lister les domaines
```bash
zmprov gad
```

## DKIM / SPF
### DKIM
Ajout de la clé DKIM dans l'ente des mails:
```bash
/opt/zimbra/libexec/zmdkimkeyutil -a -d app1.com
```

Ajouter dans la zone DNS
```bash
8e57b3d4-f121-443d-b29f-1f4cddae921d._domainkey IN  TXT "v=DKIM1; k=rsa;p=XXXXXXXXXXXXXXXXXXXXXXXXXXXXx"
```

Afficher les informations du DKIM sur zimbra d'un domain (préfix, clef privée, ...)
```bash
/opt/zimbra/libexec/zmdkimkeyutil -q -d app9.com
```

Afficher les Info DKIM du DNS d'un domain (nécessite le préfix)
```bash
dig -t txt 8e57b3d4-f121-443d-b29f-1f4cddae921d._domainkey.app1.com
```

Vérifier la conf zimbra
```bash
/opt/zimbra/opendkim/sbin/opendkim-testkey -d app1.com -s 8e57b3d4-f121-443d-b29f-1f4cddae921d -x /opt/zimbra/conf/opendkim.conf
```


### SPF
Ajoute du record DNS qui permet au serveur vm1 et à l'IP Y.Y.Y.Y d'émettre des mails en tant que @app1.com
```bash
@ 10800 IN TXT "v=spf1 mx ip4:Y.Y.Y.Y/32 a:vm1.exemple.com ~all"
```



# Gestion des groupes

## creation groupe admin
```bash
zmprov cdl admins@app1.com
```
## affectation des attributs au groupe admin
```bash
zmprov mdl admins@app1.com \
  zimbraIsAdminGroup TRUE \
  zimbraMailStatus disabled \
  zimbraAdminConsoleUIComponents accountListView \
  zimbraAdminConsoleUIComponents aliasListView \
  zimbraAdminConsoleUIComponents DLListView \
  zimbraAdminConsoleUIComponents resourceListView \
  zimbraAdminConsoleUIComponents saveSearch
```

## ajout d'un user au groupe
```bash
zmprov adlm admins@app1.com user1@app1.com
```
## donne les droits de gestion de domaine au groupe admins@cdg00.fr
```bash
zmprov grr domain app1.com grp admins@app1.com domainAdminConsoleRights
for i in `zmprov gad|grep cdg`; do zmprov ca user1@$i YYYYYY; zmprov ca user2@$i YYYYYY;zmprov ca user3@$i YYYYYY;done
```
Problème de flag / drapeau sur dossier : reset héritage sur conflit de droit dans sous dossiers
```bash
zmmailbox -z -m user1@test.com mff /Inbox u
```

## restrictions sur les listes de distribution:
important : restart milter après modif des restrictions !!!!
```
zmmilterctl restart
```

### accorder les membres de list1 à ecrire à list1
```bash
zmprov grr  dl list1@exemple.com grp list1@exemple.com sendToDistList
zmprov grr  dl list1@exemple.com grp list2@exemple.com sendToDistList
```
accorder les membres de grptout le monde à écrire à la liste app@app1.com
```
zmprov grr  dl app@app1.com grp grptoutlemonde@app1.com sendToDistList
```
refuser le droit pour toute adresse non zimbra (non gerée par zimbra)
```
zmprov grr  dl app@app1.com pub -sendToDistList
```

### lister les droits sur list1
```bash
zmprov gg -t dl list1@exemple.com
```

### tester les ACL sur list1
```
zmprov ckr dl list1@exemple.com toto@gmail sendToDistList
```

### enlever une ACL
```
zmprov rvr dl grptoutlemonde@app1.com grp app@app1.com sendToDistList
```
# COS

## affectation d'une cos
```
zmprov sac agnes.bernard@app1.com cdg00
```
## repartition des comptes dans les COS
```
zmprov cta app1.com
```

## blacklists
Spam : Désactiver pour les users la possibilité d'enregistrer des whitelists et des blacklists
```
zmprov mc app-enr_cos zimbraMailBlacklistMaxNumEntries 0
```

## rafraichir LDAP
zmprov flushCache [account|cos|domain|server] [name|id]
## activer debug
```bash
zmprov aal admin@exemple.com zimbra.soap debug
tail -f log/mailbox.log
```
## Remove debug
```
zmprov ral admin@exemple.com
```


# Partage

## partage corbeille
```bash
zmmailbox -z -m joe@domain  mfg  /Trash  account  mary@domain  rw
```

## Utiliser plusieurs boites dans l'interface : ajout de service@exemple.com pour l'utilisateur test@exemple.com (deprecated zimbra6)
```bash
zmprov ga service@exemple.com | grep zimbraId
zmprov ma test@exemple.com +zimbraChildAccount 46d1e854-456d-4bb9-b0a4-ac315188783f
zmprov ma test@exemple.com +zimbraPrefChildVisibleAccount 923d7697-1c21-4747-ac0d-fd1f0189e557
```
## Partage dossier brouillon
```bash
zmmailbox -z -m admin@app7.com mfg /Drafts account  p.nom@app8.com rwixd
```



# ssl

## renouvellement des certificats self-signed
http://wiki.zimbra.com/wiki/Administration_Console_and_CLI_Certificate_Tools
## voir le crt
```bash
/opt/zimbra/openssl-0.9.8k/bin/openssl x509 -in /opt/zimbra/ssl/zimbra/server/server.crt -noout -text
```
## voir le csr
```bash
/opt/zimbra/bin/zmcertmgr viewcsr self /opt/zimbra/ssl/zimbra/server/server.csr
```
## voir tous les crt
```bash
/opt/zimbra/bin/zmcertmgr viewdeployedcrt all
```

## renouvellement des certificats self-signed
```bash
/opt/zimbra/bin/zmcertmgr createca -new
/opt/zimbra/bin/zmcertmgr createcrt -new -days 365
/opt/zimbra/bin/zmcertmgr deploycrt self
/opt/zimbra/bin/zmcertmgr deployca
/opt/zimbra/bin/zmcertmgr viewdeployedcrt
zmcontrol stop
zmcontrol start
```

## confidentialité freebusy (n'existe pas dans les cos)

### lister les ACE
```bash
zmprov -l ga p.nom@exemple.com |grep zimbraACE
zimbraACE: 4b1375ca-a175-4a7e-8793-5d8f63efa043 grp viewFreeBusy
zimbraACE: 4b1375ca-a175-4a7e-8793-5d8f63efa043 grp invite
```
### trouver l'ID du groupe list1
```bash
zmprov -l gdl list1@exemple.com |grep zimbraId
zimbraId: 9e55213e-1719-4ade-870f-7d8def3
ttlemonde zimbraACE "99999999-9999-9999-9999-999999999999 pub viewFreeBusy"
nobody zimbraACE "00000000-0000-0000-0000-000000000000 all -viewFreeBusy"
mongroupe zimbraACE "4b1375ca-a175-4a7e-8793-5d8f63efa043 grp viewFreeBusy"
internal zimbraACE "00000000-0000-0000-0000-000000000000 all viewFreeBusy"
```

# Gestion calendrier

## effacer un calendrier
```bash
zmmailbox -z -v -m test@exemple.com ef /Calendar
```
## sauver un calendrier
```bash
zmmailbox -z -v -m test@exemple.com gru /Calendar > /tmp/cal.ics
```

## créer un calendrier
```bash
zmmailbox -z -m test@exemple.com createFolder --view appointment /Calendar2
```
## importer calendrier
```bash
zmmailbox -z -v -m test@exemple.com pru /Calendar2 /tmp/cal.ics
```


## contacts

### export d'un carnet (celui de la GAL)
```bash
zmmailbox -z -v -m galsync@app12.com gru /_app12 > /tmp/ccloch.ics
```
### créer un carnet
```bash
zmmailbox -z -m test@exemple.com createFolder --view contact /ccloch
```
### importer contacts
```bash
zmmailbox -z -v -m test@exemple.com pru /ccloch /tmp/cal.ics
```
### export contacts
```
zmmailbox -z -m p.nom@exemple.com gact > /tmp/expcontact.txt
curl -v --user "p.nom@exemple.com:pass" https://vm1.exemple.com:443/home/p.nom@exemple.com/contacts?fmt=zip --output sq.zip
```
recursive:
get all contacts folders:
```
zmmailbox -z -m ripam@app5.com gaf  | awk '{ if ($2 == "cont") {for (i=5 ; i <= NF ; i++) { printf $i " "} printf "\n"} }' > /tmp/book.list
```
export each addressbook:
```
LC_ALL=fr_FR.UTF-8
cat /tmp/book.list | sed 's/ $//' | while read line; do echo $line; zmmailbox -z -m ripam@app5.com getRestURL "${line}?fmt=csv" >> /tmp/all ; done
```
### search contacts
pour la BAL user@app4.com on cherche dans le dossier "emailed contact" une adresse direction@app4.com
```
zmmailbox -z -m user@app4.com s -v -t cont "in:\"Emailed Contacts\" content:direction@app4.com"
```

### effacer contact
efface une entrée "direction@app4.com" de l'autocomplete qui était erronnée
```
zmsoap -z -m user@app4.com RankingActionRequest/action @op=delete @email=direction@app4.com
zmprov fc account user@app4.com
```
efface direction@app4.com du carnet (trouvé avec le Id: de la recherche)
```
zmmailbox -z -m user@app4.com dct ContactID
```

## Create GAL
```bash
zmgsautil createAccount -a galsync@app8.com -n zimbra --domain app8.com -t zimbra -s vm1.exemple.com
```

## GAL multi domaine

### Effacement du compte GAL du domaine
```bash
zmgsautil deleteAccount -a galsync@app3.com
```

### (re)création du compte gal du domaine
```bash
zmgsautil createAccount -a galsync@app3.com -n app.com --domain app3.com -t zimbra -f _app.com
```

### Creation du répertoire du second addressbook
```bash
zmmailbox -z -m galsync@app3.com createFolder --view contact /_exemple
```

### ajout du second addressbook au compte
```bash
zmgsautil createAccount -a galsync@app3.com -n exemple --domain app3.com -t ldap -f _exemple
```

### affichage des sources addressbook pour le compte
```bash
zmprov gds galsync@app3.com
```

### récupération du password ldap
```bash
PASS=`zmlocalconfig -s | awk '/zimbra_ldap_password/ { print $3 }'`
```
paramétrage de la seconde source GAL
```bash
zmprov mds galsync@app3.com exemple \
zimbraGalSyncLdapBindDn uid=zimbra,cn=admins,cn=zimbra \
zimbraGalSyncLdapBindPassword $PASS \
zimbraGalSyncLdapFilter '(&(|(cn=*%s*)(sn=*%s*)(gn=*%s*)(mail=*%s*)(zimbraMailDeliveryAddress=*%s*)(zimbraMailAddress=*%s*))(|( objectclass=zimbraAccount)(objectclass=zimbraDistributionList)))' \
zimbraGalSyncLdapSearchBase dc=exemple,dc=fr \
zimbraGalSyncLdapURL ldap://X.X.X.X:389
```
indique que le compte GAl utilise plusieurs sources
```bash
zmprov md app3.com zimbraGALMode both
```
resynchro des sources
```bash
zmgsautil forceSync -a galsync@app3.com -n app.com                                                                                                                                                                       
zmgsautil forceSync -a galsync@app13.com -n  app13                                                                                                                                                                   
zmgsautil forceSync -a galsync@app12.com -n app12                                                                                                                                                                       
zmgsautil forceSync -a galsync@app5.com -n app5                                                                                                                                                                
zmgsautil forceSync -a galsync@lcapp5.com -n lcapp5                                                                                                                                                
zmgsautil forceSync -a galsync@app15.com -n app15                                                                                                                                                 
zmgsautil forceSync -a galsync@app16.com -n app16                                                                                                                                                        
zmgsautil forceSync -a galsync@app17.com -n app17
```

## actualisation d'une liste GAL
```bash
zmgsautil forceSync -a galsync@exemple.com -n zimbra
```
## post contact rest api
```bash
curl -v -k --user testdev@exemple.com:YYYYYY --upload-file /home/www/app/upload/gestproj/clients_exp.txt https://vm1.exemple.com:443/home/testdev@exemple.com/contacts?fmt=csv
```



### distribution list
### creation avec un user
```bash
zmprov cdl testdiff@exemple.com displayName "dl de test" zimbraMailForwardingAddress p.nom@exemple.com
```
### add users to list1 list:
l is a list of users (awk '{ print $4 }' get_zimbra_infos_190930-030101.log > l)
for all domains, add users to their list all@domain:
```
zmprov gad > d
cat d | while read dom; do awk '/@'$dom'$/ { print "adlm all@'$dom' " $0 }' l; done > dl
zmprov < dl
```

## Transport map
Demander à zimbra d'envoyer les mails non pas en local mais vers un serveur smtp externe (si le mx est encore externe)
```bash
zmprov md app1.com zimbraMailTransport smtp:app-fr01e.mail.protection.outlook.com:25
zmprov ma p.nom@app1.com zimbraMailTransport smtp:app-fr01e.mail.protection.outlook.com:25
```
Après migration mx, lorsque la boite arrive réellement sur le zimbra local
```bash
zmprov ma p.nom@app1.com zimbraMailTransport smtp:app-fr01e.mail.protection.outlook.com:25
```

## Transport map : forward des mails vers certains domaines via un serveur relais
Par exemple si un zimbra est blacklisté chez un destinataire seulement, plus light / simple que de changer l'IP du serveur.

```bash
echo "innoval.com :[vm2.exemple.com]" >> /opt/zimbra/postfix/conf/transport
su -c "/opt/zimbra/common/sbin/postmap /opt/zimbra/postfix/conf/transport" zimbra
```

Pour supprimer cette règle : supprimer la ligne en question du fichier transport et relancer un postmap

## bd berkeley (deprecated z8.7)
```bash
cat tpmail_senders
  /^(.*)$/ restrict_tpmail
cat tpmail_recipients
  localdomain OK
  exemple.com OK
  exemple.com OK
vi /opt/zimbra/conf/zmmta.cf
  POSTCONF smtpd_sender_restrictions          FILE postfix_sender_restrictions.cf
  POSTCONF smtpd_restriction_classes          restrict_tpmail
  POSTCONF restrict_tpmail                    FILE postfix_restrict_tpmail.cf
cd /opt/zimbra/conf
echo "check_sender_access regexp:/opt/zimbra/conf/tpmail_senders" > postfix_sender_restrictions.cf
echo "check_recipient_access hash:/opt/zimbra/conf/tpmail_recipients, reject" >> postfix_restrict_tpmail.cf
```
test regexp
```bash
  postmap -q "exemple.com" regexp:/opt/zimbra/conf/tpmail_senders
  postmap -q "s@exemple.com" regexp:/opt/zimbra/conf/tpmail_senders
  postmap -q "exemple.com" regexp:/opt/zimbra/conf/tpmail_senders
```
generation des db
```bash
cd /opt/zimbra/conf
postmap tpmail_senders
postmap tpmail_recipients
postfix reload
```


#synchro des mails entre plusieurs boites
imapsync --host1 "localhost" --host2 "localhost"   --user1 "prenom.nom3@app3.com" --user2 "prenom.nom3@app13.com"   --authuser1 "admin@exemple.com" --authuser2 "admin@exemple.com" --password1 "XXXXXX" --password2 "XXXXXX"



# Admin Rights (delegate)

https://git.zimbra.com/repos/zimbra-foss/ZimbraServer/docs/delegatedadmin.txt

## get rights for account
```bash
zmprov gaer usr test.test@app1.com
zmprov ckr global test.test@app1.com adminConsoleServerInfoTabRights
zmprov ckr global test.test@app1.com configureQuota                 
zmprov ckr domain app1.com test.test@app1.com configureQuota
zmprov ger global test.test@app1.com
zmprov ger domain app1.com test.test@app1.com
zmprov gg -t domain app1.com -g usr test.test@app1.com 0
```
description d'un droit:
```
zmprov gr configureQuota
```
app6.com peut il envoyer en tant que p.nom@app8.com?
```bash
zmprov ckr account p.nom@app6.com p.nom@app8.com sendAs
```
accorder à p.nom@app8.com le droit d'envoyer en tant que p.nom@app6.com
```bash
zmprov grr account p.nom@app8.com usr p.nom@app6.com sendAs
```
visualiser les droits affectés sur le domaine:
```bash
zmprov gg -t domain app8.com
```
sur un user:
```
zmprov gg -t account p.nom@app7.com
```

## droits pour un admin domaine (admin = admin@app7.com)
```bash
zmprov grr domain app1.com usr admin@app7.com -adminLoginAs
zmprov grr domain app1.com usr admin@app7.com adminConsoleDLRights
zmprov grr domain app1.com usr admin@app7.com adminConsoleResourceRights
zmprov grr domain app1.com usr admin@app7.com adminConsoleAliasRights
zmprov grr domain app1.com usr admin@app7.com adminConsoleAccountRights
```

## Export filter to another account
Récupération des filtres :
```bash
zmprov ga p.nom@exemple.com zimbraMailSieveScript
```
### Création des dossiers avant l'import
Liste des dossiers
```bash
zmprov ga p.nom@exemple.com zimbraMailSieveScript |grep fileinto |sed 's|^\s*fileinto "\([^"]*\)";|\1|' |sed 's#^\([^/]\)#/\1#' |sort -h |uniq
```
Exemple de création
```bash
zmmailbox -z -m p.nom2@exemple.com cf --view mail /Inbox/1-admin
```
### Import
Export dans un fichier :
```bash
zmprov ga p.nom@exemple.com zimbraMailSieveScript > /opt/zimbra/backup/mailfilterexport.sh
```
Modifier le fichier :
- Origine :
```
# name p.nom@exemple.com
zimbraMailSieveScript: require ["fileinto", "copy", "reject", "tag", "flag", "variables", "log", "enotify", "envelope", "body", "ereject", "reject", "relational", "comparator-i;ascii-numeric"];
...

...
```
- New :
```
#!/bin/bash
# name p.nom@exemple.com
zmprov ma p.nom2@exemple.com zimbraMailSieveScript 'require ["fileinto", "copy", "reject", "tag", "flag", "variables", "log", "enotify", "envelope", "body", "ereject", "reject", "relational", "comparator-i;ascii-numeric"];
...

...
'
```
/!\\ Attention au caractère spéciaux qui ne passe pas lors de l'import
- é
- è
- à
- '
- Symbole (bacula report)

Exécuter le script:
```bash
bash /opt/zimbra/backup/mailfilterexport.sh
```

# Provisioning rapide
zmprov et d'autres commandes peuvent être utilisées comme un shell, pour une execution bcp plus performante
au lieu de faire zmprov command1 dans un shell bash, on ouvre le shell zmprov
à l'invite du prompt zmprov, on peut alors lancer command1
autre solution:
```bash
zmprov << NOHRSC
command1
command2
...
quit
NOHRSC
```
ou :
```bash
zmprov < liste_commandes
```
