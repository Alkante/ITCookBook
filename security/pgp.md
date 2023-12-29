# PGP
## Install
https://help.riseup.net/en/security/message-security/openpgp/best-practices
```bash
sudo apt-get install gnupg-curl
```
pb entropy:
```bash
sudo apt-get install rng-tools
sudo rngd -r /dev/urandom
```
## config
Edition du fichier selon ~/.gnupg/gpg.conf selon https://raw.githubusercontent.com/ioerror/duraconf/master/configs/gnupg/gpg.conf
```bash
cd ~/.gnupg/
```
wget https://sks-keyservers.net/sks-keyservers.netCA.pem
Contenu du fichier de config:
```bash
keyserver hkps://hkps.pool.sks-keyservers.net
keyserver-options ca-cert-file=/home/pnom/.gnupg/sks-keyservers.netCA.pem
keyserver-options no-honor-keyserver-url
use-agent
personal-cipher-preferences AES256 AES192 AES CAST5
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
cert-digest-algo SHA512
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
keyid-format 0xlong
with-fingerprint
list-options show-uid-validity
verify-options show-uid-validity
no-greeting
no-emit-version
no-comments
default-key  XXXXXXXXXXXXX
```
# gen key
http://ekaia.org/blog/2009/05/10/creating-new-gpgkey/
```
gpg --gen-key
Sélectionnez le type de clef désiré :
   (1) RSA et RSA (par défaut)
   (2) DSA et Elgamal
   (3) DSA (signature seule)
   (4) RSA (signature seule)
Quel est votre choix ? 1 (pour signer et déchiffrer)
les clefs RSA peuvent faire entre 1024 et 4096 bits de longueur.
Quelle taille de clef désirez-vous ? (2048) 4096
La taille demandée est 4096 bits
Veuillez indiquer le temps pendant lequel cette clef devrait être valable.
         0 = la clef n'expire pas
      <n>  = la clef expire dans n jours
      <n>w = la clef expire dans n semaines
      <n>m = la clef expire dans n mois
      <n>y = la clef expire dans n ans
Pendant combien de temps la clef est-elle valable ? (0) 2y
La clef expire le lun. 08 mai 2017 22:41:07 CEST
Est-ce correct ? (o/N) o
Une identité est nécessaire à la clef ; le programme la construit à partir
du nom réel, d'un commentaire et d'une adresse électronique de cette façon :
   « Heinrich Heine (le poète) <heinrichh@duesseldorf.de> »
Nom réel : Prénom NOM
Adresse électronique : p.nom@exemple.com
Commentaire :
Vous utilisez le jeu de caractères « utf-8 ».
Vous avez sélectionné cette identité :
    « Prénom NOM <p.nom@exemple.com> »
Faut-il modifier le (N)om, le (C)ommentaire, l'(A)dresse électronique
ou (O)ui/(Q)uitter ? o
Une phrase de passe est nécessaire pour protéger votre clef secrète.

gpg: clef 0xXXXXXXXXXX marquée de confiance ultime.
les clefs publique et secrète ont été créées et signées.
gpg: vérification de la base de confiance
gpg: 3 marginale(s) nécessaire(s), 1 complète(s) nécessaire(s),
     modèle de confiance PGP
gpg: profondeur : 0  valables :   1  signées :   0
     confiance : 0 i., 0 n.d., 0 j., 0 m., 0 t., 1 u.
gpg: la prochaine vérification de la base de confiance aura lieu le 2017-05-08
pub   4096R/0xXXXXXXXXX 2015-05-09 [expire : 2017-05-08]
      Empreinte de la clef = XXXXXXXXXXXXXXXXXXXXXXXXX
uid                [  ultime ] Prénom NOM <p.nom@exemple.com>
Remarquez que cette clef ne peut pas être utilisée pour chiffrer. Vous pouvez
utiliser la commande « --edit-key » pour générer une sous-clef à cette fin.
```


## edit
### show
```
gpg --edit-key 0xXXXXXXX
La clef secrète est disponible.
pub  4096R/0xYYYYYYYYY  créé : 2016-02-27  expire : 2018-02-26  utilisation : SC  
                               confiance : ultime        validité : ultime
sub  4096R/0xXXXXXXXxx  créé : 2016-02-27  expire : 2018-02-26  utilisation : E   
[  ultime ] (1). Prénom NOM <p.nom@exemple.com>
```
```
gpg> showpref
[  ultime ] (1). Prénom NOM <p.nom@exemple.com>
     Chiffrement : AES256, AES192, AES, CAST5, 3DES
     Hachage : SHA512, SHA384, SHA256, SHA224, SHA1
     Compression : ZLIB, BZIP2, ZIP, Non compressé
     Fonctionnalités : MDC, Serveur de clefs sans modification
```
## create revoke key
```
gpg --output revoke.asc --gen-revoke '0xXXXXXXXXXXXXX'
sec  4096R/0xXXXXXXXXXXXXX 2015-05-09 Prénom NOM <p.nom@exemple.com>
Faut-il créer un certificat de révocation pour cette clef ? (o/N) o
choisissez la cause de la révocation :
  0 = Aucune raison indiquée
  1 = La clef a été compromise
  2 = La clef a été remplacée
  3 = La clef n'est plus utilisée
  Q = Annuler
(Vous devriez sûrement sélectionner 1 ici)
Quelle est votre décision ? 0
Entrez une description facultative, en terminant par une ligne vide :
revocation
Cause de révocation : Aucune raison indiquée
revocation
Est-ce d'accord ? (o/N) o
Une phrase de passe est nécessaire pour déverrouiller la clef secrète de
l'utilisateur : « Prénom NOM <p.nom@exemple.com> »
clef RSA de 4096 bits, identifiant 0xXXXXXXXXXXXXX, créée le 2015-05-09
sortie forcée avec armure ASCII.
Certificat de révocation créé.
Veuillez le déplacer sur un support que vous pouvez cacher ; toute personne
accédant à ce certificat peut l'utiliser pour rendre votre clef inutilisable.
Imprimer ce certificat et le stocker ailleurs est une bonne idée, au cas où le
support devienne illisible. Attention quand même : le système d'impression
utilisé pourrait stocker ces données et les rendre accessibles à d'autres.
```
## revoquer le cert
```bash
gpg --import revoke.asc
gpg --send-key '0xXXXXXXXXXXXXX'
```
## publi
```bash
gpg --send-key "XXXX XXXX XXXX XXXX XXXX XXXX XXXX"
gpg: envoi de la clef 0xXXXXXXXXXXXXX au serveur hkps eu.pool.sks-keyservers.net
```
## effacer
```bash
gpg --delete-secret-keys 0xXXXXXXXXXXXXX
gpg --delete-key 0xXXXXXXXXXXXXX
```
# backup/restore
## export
```bash
gpg --export-secret-keys -a -o ~/.gnupg/maclepgp.private '0xXXXXXXXXXXXXX'
gpg --export -a -o ~/.gnupg/maclepgp.pub '0xXXXXXXXXXXXXX'
```
## import
import pub
```bash
gpg --import zim.pub
```
import priv
```bash
gpg --allow-secret-key-import --import zim.priv
```

# lister
## lister les clés publiques
```bash
gpg --list-keys
```
Afficher
```bash
gpg --export -a -o - 0xYYYYYYYYYY
```
## lister les clés privées
```bash
gpg --list-secret-keys
```
Afficher
```bash
gpg --export-secret-keys -a -o - 0xYYYYYYYYYY
```
## chercher un clé sur les serveur publics
```bash
gpg --search-keys p.nom@exemple.com
```

## verifier password
```bash
echo "1234" | gpg --no-use-agent -o /dev/null --local-user 0xYYYYYYYYYY
```
