# HTTP Public Key Pinning
## C'est quoi ?
Public Key Pinning est une extension du protocole de transfert HTTP (Hypertext Transfer Protocol) qui vous permet de spécifier la clef publique définie pour les futures connexions SSL/TLS. Cela consiste a avoir un certain nombre de hash de vos future clé dans les headers http, lorsque il y aura un changement de certificat, le client va pouvoir comparer avec le hash pour s'assurer qu'il correspond avec le nouveau certificat.

## Protége de ?
HPKP protége les sites internet de l'usurpation d'identité contre les certificats frauduleux émis par des autorités de certification compromises.

## L’épinglage des clefs (pinning)
L’épinglage (pinning) des clefs désigne un ensemble de méthodes par lesquelles un site peut désigner à ses visiteurs les clefs publiques ou les certificats qu’il utilise.

3 méthodes :
- dans les en-tétes HTTP (HPKP): le plus répandu et la plus facile mais ne protège pas l'utilisateur lors de sa première visite
- dans le dns (DANE): plus efficace que le http mais plus compliqué a mettre en place (DNSSEC) et pas du tout prise en charge nativement coté client (navigateur). Il sera utilisé pour des services tel que le mail (Postfix)...
- dans le code du navigateur: seul une poignée de site peuvent se le permettre du genre google et firefox

### Quelle(s) clef(s) épingler ?
La chaîne de certification de letencrypt:
- notre certificat
- le certificat intermédiaire Let’s Encrypt Authority X1
- le certificat racine DST Root CA X3

Quelle(s) clef(s) épingler ?
- ne pas épingler la clef du certificat racine
- intermédiaire, pourquoi pas mais le certificat peut changer dans l'avenir (la chaîne est brisé)
- la clé de notre certificat, la meilleur solution mais pas possible avec letencrypt sans passé par un CSR

Vous devez épingler deux clé minimum, une clef en cours d’utilisation, et la clef qui la remplacera dans le futur (obligatoire pour le cas HTTP).



## Source
https://www.1and1.fr/digitalguide/serveur/securite/hpkp-la-fonction-de-securite-pour-la-certification-ssl-tls/
