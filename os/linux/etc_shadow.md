# Shadow
<!-- TOC -->

- [Shadow](#shadow)
  - [Context](#context)
  - [Generate password](#generate-password)
    - [Install](#install)
    - [Usual commands](#usual-commands)
    - [Hash type](#hash-type)
    - [Salt](#salt)
    - [Rounds](#rounds)
  - [Structure of one shadow ligne](#structure-of-one-shadow-ligne)

<!-- /TOC -->

## Context

le fichier **/etc/shadow** contient le hash des mots de passe utilisateur.

## Generate password

### Install

Install **mkpasswd**
```bash
apt-get install whois
```

### Usual commands

| Command | Description |
|- |- |
| ```mkpasswd``` | Generate password with prompt |
| ```mkpasswd "mypassword"``` | Generate password without prompt  '"' are very important to generate passwor dfor /etc/shadow|
| ```mkpasswd -m sha-512 --salt=AZERTYUI --rounds=10000``` | Generate password with fix hash type, salt, number of round |


### Hash type

L'**id** reference le type de hash utilisé.

Pour GNU/Linux
- $1$ MD5
- $2a$ Blowfish (correct handling of 8-bit chars)
- $5$ SHA-256
- $6$ SHA-512, crypt(3) man page

Attention !! L'id est différent pour les autres systèmes comme FreeBSD


### Salt
Le Salt (salage) definie un nombre aléatoire d'initialisation du hash.

Si le salt n'est pas connue de l'attaquant, le salt est efficace contre:
- Les attaques par analyse fréquentielle,
- Les attaques utilisant des rainbow tables.
Inutile contre :
- Les attaques par dictionnaire,
- Les attaques par force brute.


### Rounds

Key stretching is used to increase password cracking difficulty:
- Using by default 1000 rounds of modified MD5
- 64 rounds of Blowfish,
- 5000 rounds of SHA-256 or SHA-512.[5]
- The number of rounds may be varied for Blowfish, or for SHA-256 and SHA-512 by using e.g. "$6$rounds=50000$".)
- Empty string - No password, the account has no password. (Reported by passwd on Solaris with "NP")


## Structure of one shadow ligne

Structure d'une ligne du **/etc/shadow** :

```raw
<USER>:<id>$<salt>$<hashed>:<param_int_1>:<param_int_2>:<param_int_3>:<param_int_4>:<param_int_5>:<param_int_6>:<param_int_7>
```

Exemple :

```text
pentestuser:$6$AZERTYUI$AZERTYUIOPMLKJHGFDSQWXCVBNAZERTYUIKJHGFDS:16601:0:99999:7:::
```

Description des parametres :

- ```<user>```        :   Nom de l'utilisateur
- ```<id> ```         :   Type de hash
- ```<salt>```        :   Donnée aléatoire initiale du hash
- ```<hashed>```      :   Résultat du hash (motdepasse+salt+rounds(nombre de tour: par defaut si non spécifié))
- ```<param_int_1>``` :   Le nombre de jours (depuis le 1er Janvier 1970) depuis le dernier changement du mot de passe.
- ```<param_int_2>``` :   Le nombre de jours avant que le mot de passe ne puisse être changé (un 0 indique qu'il peut être changé à n'importe quel moment).
- ```<param_int_3>``` :   Le nombre de jours après lesquels le mot de passe doit être changé (99999 indique que l'utilisateur peut garder son mot de passe inchangé pendant beaucoup, beaucoup d'années)
- ```<param_int_4>``` :   Le nombre de jours pour avertir l'utilisateur qu'un mot de passe ne va plus être valable (7 pour une semaine entière)
- ```<param_int_5>``` :   Le nombre de jours avant de désactiver le compte après expiration du mot de passe
- ```<param_int_6>``` :   Le nombre de jours depuis le 1er Janvier 1970 pendant lesquels un compte a été désactivé
- ```<param_int_7>``` :   Un champ réservé pour une utilisation future possible
