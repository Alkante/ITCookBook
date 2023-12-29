# PKI



## Principe d'intalation d'une PKI avec AC personnel


- 1/4: Générer les certificats CA (Certified Authority)
- 2/4: Signer des certificats
- 3/4: Inclure les CA dans les postes Client (linux, firefox, chrome, ...)
- 4/4: tester :)


## 1/4 : Générer le certificat CA


Création de l'infrastructure en tant que root
```bash
mkdir /root/pki
cd /root/pki

mkdir -p db/ca.db.certs
mkdir config
mkdir certificats

 #Initialisation des numéros de séries à 1
echo '01'> db/ca.db.serial

 #Initialisation de l'index des certificats
cp /dev/null db/ca.db.index

touch db/ca.db.index.attr
```

Créer le fichier de configuration **config/ca.config**
```ini
[ ca ]
default_ca      = CA_own

[ CA_own ]
dir             = /root/pki/db
certs           = /root/pki/db
new_certs_dir   = /root/pki/db/ca.db.certs
database        = /root/pki/db/ca.db.index
serial          = /root/pki/db/ca.db.serial
RANDFILE        = /root/pki/db/ca.db.rand
certificate     = /root/pki/certificats/ca.crt
private_key     = /root/pki/certificats/ca.key
default_days    = 3000
default_crl_days = 30
default_md      = sha256
preserve        = no
policy  = policy_anything

[ policy_anything ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional
```



Généré le certificat racine maitre protégé par une passphrase:
```bash
openssl genrsa -des3 -out certificats/ca.key 2048
```


Générer un certificat autosigné:
```bash
openssl req -utf8 -new -x509 -days 3000 -key cacertificats/ca.key -out certificats/ca.crt
```


Liste des question posées:
```txt
Country Name (2 letter code) [AU]:FR
State or Province Name (full name) [Some-State]:France
Locality Name (eg, city) []:Rennes
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Exemple
Organizational Unit Name (eg, section) []:IT
Common Name (e.g. server FQDN or YOUR name) []:perso.exemple.com
Email Address []:admin@exemple.com
```


Convertir le ca.crt en format DER (utilisé par de nombreux navigateurs):
```bash
openssl x509 -in certificats/ca.crt -outform DER -out certificats/ca.der
```

## 2/4 : Signer un nouveau certificat

Création de la clef public
```bash
openssl genrsa -out certificats/https.www.exemple.com.key 2048
```

Création d'un certificat request
```bash
openssl req -days 365 -new -key certificats/https.www.exemple.com.key -out certificats/https.www.exemple.com.csr
```


Question :
```
Country Name (2 letter code) [AU]:FR
State or Province Name (full name) [Some-State]:France
Locality Name (eg, city) []:Rennes
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Exemple
Organizational Unit Name (eg, section) []:IT
Common Name (e.g. server FQDN or YOUR name) []:www.exemple.com
Email Address []:admin@exemple.com
```
Et donner un mot de passe de protection


Signature du certificat request :
```bash
openssl ca -config config/ca.config -out certificats/https.www.exemple.com.crt -in certificats/https.www.exemple.com.csr
```

# 3/4 : Ajout dans les OS et les soft

```
apt-get install nsions v3openssl


cd /usr/lib/ssl/misc
```
CA certificate filename (or enter to create)

Making CA certificate ...
```
openssl req  -new -keyout ./demoCA/private/cakey.pem -out ./demoCA/careq.pem
Generating a 2048 bit RSA private key
.....+++
....................................+++
writing new private key to './demoCA/private/cakey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [FR]:
State or Province Name (full name) [Bretagne]:
Locality Name (eg, city) []:
Organization Name (eg, company) [ENTREPRISE]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:auth.exemple.com
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```
```
openssl ca  -create_serial -out ./demoCA/cacert.pem -days 1825 -batch -keyfile ./demoCA/private/cakey.pem -selfsign -extensions v3_ca -infiles ./demoCA/careq.pem
Using configuration from /usr/lib/ssl/openssl.cnf
Enter pass phrase for ./demoCA/private/cakey.pem:
Check that the request matches the signature
Signature ok
Certificate Details:
        Serial Number:
            XXXXXXXXXXXXXX
        Validity
            Not Before: May 31 19:34:56 2017 GMT
            Not After : May 30 19:34:56 2022 GMT
        Subject:
            countryName               = FR
            stateOrProvinceName       = Bretagne
            organizationName          = ENTREPRISE
            commonName                = auth.exemple.com
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                YYYYYYYYYYYYYYYY
            X509v3 Authority Key Identifier:
                keyid:ZZZZZZZZZZZZZZZZZZZZZZZZZZZ

            X509v3 Basic Constraints: critical
                CA:TRUE
Certificate is to be certified until May 30 19:34:56 2022 GMT (1825 days)

Write out database with 1 new entries
Data Base Updated
==> 0
====
CA certificate is in ./demoCA/cacert.pem
```
premier csr
```bash
cd /tmp
openssl req -exte_req -new -nodes -subj '/CN=*.exemple.com/O=ENTREPRISE/C=FR/ST=Bretagne' -keyout wildcard.exemple.com.key -out wildcard.exemple.com.csr -days 1825
```
signature de la csr avec le ca
```bash
cd /usr/lib/ssl/misc/
openssl ca -extensions v3_req -days 1825 -out /tmp/wildcard.exemple.com.crt -infiles /tmp/wildcard.exemple.com.csr
```
verif ca / crt
```bash
openssl verify -verbose -CAfile demoCA/cacert.pem demoCA/newcerts/XXXXXX.pem
```
verif crt / key
```bash
(openssl x509 -noout -modulus -in /tmp/wildcard.exemple.com.crt | openssl md5 ; openssl rsa -noout -modulus -in /tmp/wildcard.exemple.com.key | openssl md5)
```




## Sources

https://jamielinux.com/docs/openssl-certificate-authority/introduction.html
