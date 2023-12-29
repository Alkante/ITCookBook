# OpenVpn

Le principe d'un vpn est de créer une connexion chiffrée.

Le client se connecte au seveur puis la connexion est router ou bridgée respectivement sur une interface tun ou tap

Le protocole privilégié est l'udp puisque faire passer du tcp dans du tcp provoque un énorme coup réseau supplémentaire.


La connexion est chiffré. les clients souhaitant ce connecter doivent avoir une clef préalablement signé.

## File extention
- *.key : Private : Private key
- *.csr : Public  : Certificate request (like a public key)
- *.crt : Public  : Certificate (like a public key signed by an other certificate)
- *.pem : Can be *.key *.csr or *.pem

## OpenVPN chaine certification
Root certificate (ca.key,ca.crt)  ->  Intermediate certificate (openvpn-ca.key,openvpn-ca.crt)(Optional) -> Serveur certificate (server.key,server.crt) && User1 certificate (User1.key,User1.crt)  

The root certificate is special because it is autosigned. To control all the process, don't pass by external certification authorities. So build all and certify all by your certificates.


### Order
- Root :                                                 -> [ca.key,ca.crt]                 # Autosigned :)
- Intermediate :                                         -> [openvpn-ca.key,openvpn.csr]    # *.key is private :)
- Intremediate to Root :                                    mv [openvpn-ca.csr]
- Root :                  [ca.key,ca.crt,openvpn-ca.csr] -> [openvpn-ca.crt]
- Root to Intermediate :                                 mv [openvpn-ca.crt]

- Server :                                               -> [server.key,server.csr]         # *.key is private :)
- Server to Intermediate :                               mv [server.csr]
- Intermediate :    [openvpn.key,openvpn.crt,server.csr] -> [server.crt]
- Server to Intermediate :                               mv [server.crt]

- User1 :                                                -> [user1.key,user1.csr]           # *.key is private :)
- User1 to Intermediate :                                mv [user1.csr]
- Intermediate :     [openvpn.key,openvpn.crt,user1.csr] -> [user1.crt]
- User1 to Intermediate :                                mv [user1.crt]


Intermediate generate [user1.key,user1.crt] and give them to User1 (If you trust Intermediate)

For simple use :
 - Don't use Intermediate
 - Root/Server are in same machine
 - Generate User1 key and certificate in Root/Server and give them to the User1 (If you trust the Root/Server)


In this installation, we choose simple use way

## Server & Machine with root certificate install openvpn
```
apt-get install openvpn

apt-get install bridge-utils

```

### Copy file to use ssl frendly
	cd /etc/openvpn
	mkdir easy-rsa
	cd easy-rsa

Puis

	cp -R /usr/share/doc/openvpn/examples/easy-rsa/2.0/* .

ou

	cp -R /usr/share/easy-rsa/* .

Sécuriser

	chown -R root:root /etc/openvpn/easy-rsa
	chmod -R 0700 /etc/openvpn/easy-rsa

## Generator root key [ca.key(private)] and root certificate [ca.crt(Public)] (2 options)
### 1/3 : Very Very Fast way

	editor ./vars

Changer

	export KEY_COUNTRY="FR"
	export KEY_PROVINCE="FR"
	export KEY_CITY="FR"
	export KEY_ORG="nom"
	export KEY_EMAIL="admin@nom.lan"
	export KEY_OU="nom"



Nétoyer la configuration (supprime les clefs)

	 rm -rf on /etc/openvpn/easy-rsa/keys
	./clean-all

Charger les options

	source vars
	./pkitool --initca

### 2/3 : Fast way
```
editor ./vars     # Edit vars, (Important to edit last 10 lines) The common name is the most important
. ./vars          # Load variables (OR  source ./vars)

./build-ca        # Produce [ca.key, ca.crt] in keys/: Use default option already specified in ./vars (Press enter many times)
```
### 3/3 : Detail way
```
cd keys
openssl req -new -x509 -keyout ca.key -out ca.crt -config /etc/ssl/openssl.cnf # -> [ca.key,ca.crt]
chmod 0600 ca.key    # Force private permission
touch index.txt      # List of crt signed by ca.key (is Empty)
touch serial         # Number of ca know (01)
echo "01" > serial
cd ..
```


## Generator of internediate certificate [openvpn-ca.key(private, openvpn-ca.crt(public))] (2 options)
### 1/2 : Fast way
```
./build-inter openvpn # -> [openvpn.ca.key,openvpn-ca.crt,01.pem]
```
- Now, keys/index.txt have 1 entry (one crt signed)
- Now, keys/serial is increase by 1
### - 2/2 : Detail way
```
cd keys
openssl req -new -keyout openvpn-ca.key -out openvpn-ca.csr -config /etc/ssl/openssl.cnf # -> [openvpn-ca.key,openvpn-ca.csr]
openssl ca -extensions v3_ca -days 3650 -out openvpn-ca.crt -in openvpn-ca.csr -config /etc/ssl/openssl.cnf # [openvpn-ca.csr] -> [openvpn-ca.crt]
cat ca.crt openvpn-ca.crt > allca.crt # Concatenation [ca.crt,openvpn-ca.crt] -> allca.crt
cd ..
```


## Generate server key [server.key, server.crt] (3 options)
### - 1/3 : Very Very Fast way
```
./pkitool --server server # -> [server.key, server.crt]
```
### - 2/3 : Fast way
```
./build-key-server server # -> [server.key, server.crt]
```
### - 3/3 : Detail way
```
cd keys
openssl req -nodes -new -keyout server.key -out server.csr -config /etc/ssl/openssl.cnf # -> [server.key,server.csr]
openssl ca -keyfile openvpn-ca.key -cert openvpn-ca.crt -out server.crt -in server.csr -extensions server -config /etc/ssl/openssl.cnf # [openvpn-ca.key,openvpn-ca.crt,server.csr] -> [server.crt]
chmod 0600 server.key # Force private permission
cd ..
```


## Generate server DIFFIE-HELLMAN parameters nedded for the server
```
./build-dh
```

As we want to use OpenVPN's "tls-auth" feature for perfect forward secrecy (it "adds an additional HMAC signature to all SSL/TLS handshake packets for integrity verification"), we'll have to generate a shared secret:
```
cd keys
openvpn --genkey --secret ta.key
cd ..
```

## Copy important file needed
```
cd keys
cp ca.crt server.key server.crt dh2048.pem ta.key  /etc/openvpn/
cd ..
```

## Generate jail and clientconf save
```
mkdir /etc/openvpn/jail
mkdir /etc/openvpn/clientconf
```

## Edit server.conf
```
cd /etc/openvpn
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz .
gunzip server.conf.gz

editor /etc/openvpn/server.conf
```

## Test the conf validity
```
cd /etc/openvpn
openvpn server.conf
```

## Run openvpn server
```
service openvpn restart
```

### Enable ip forward on the fly
```
echo 1 > /proc/sys/net/ipv4/ip_forward
```
### Enable ip forward definitly
```
editor /etc/sysctl.conf
```

```
BEFORE
	#net.ipv4.ip_forward=1
AFTER
	net.ipv4.ip_forward=1
```



## User install openvpn
### On the server
#### Genetare client key on the server [user1.key, user1.crt] (2 options)
##### - 1/3 : Fast way
```
KEY_CN=someuniqueclientcn ./pkitool user1
```
##### - 2/3 : Fast way
```
cd /openvpn/easy-rsa
./build-key user1 # -> [user1.key, user1.crt]
```
##### - 3/3 : Detail way
```
cd keys
openssl req -nodes -new -keyout user1.key -out user1.csr -config /etc/ssl/openssl.cnf # -> [user1.key, user1.csr]
openssl ca -keyfile openvpn-ca.key -cert openvpn-ca.crt  -out user1.crt -in user1.csr -config /etc/ssl/openssl.cnf # [openvpn-ca.key,openvpn-ca.crt,user1.csr] -> [user1.crt]
chmod 0600 user1.key # Force private permission
cd ..
```


## Save client conf
```
rm user1.csr
mv user1.key user1.crt ../../clientconf/
cp ca.crt dh1024.pem ta.key ../../clientconf/
```


### On the user machine
#### Copy importante file in /etc/openvpn
```
cd /etc/openvpn
Copy user1.key user1.crt ca.crt dh1024.pem ta.key To /etc/openvpn
```

#### Edit client.conf
```
cd /etc/openvpn
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf .
editor client.conf
```

I prefer to manually start the client on my laptop when needed, so I use AUTOSTART="none" in /etc/default/openvpn and then start the client via:
```
openvpn /etc/openvpn/client.conf
```




## Some usefull ssl  command
### Command openssl generate
-> .key, .csr : Generate a new private key and Certificate Signing Request
```
openssl req -out CSR.csr -new -newkey rsa:2048 -nodes -keyout privateKey.key
```
-> .key, .crt : Generate a self-signed certificate
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout privateKey.key -out certificate.crt
```
.key -> .csr : Generate a certificate signing request (CSR) for an existing private key
```
openssl req -out CSR.csr -key privateKey.key -new
```
.key, .crt -> .csr : Generate a certificate signing request based on an existing certificate
```
openssl x509 -x509toreq -in certificate.crt -out CSR.csr -signkey privateKey.key
```
.pem -> .pem :Remove a passphrase from a private key
```
openssl rsa -in privateKey.pem -out newPrivateKey.pem
```
### Command openssl check
.csr : Check a Certificate Signing Request (CSR)
```
openssl req -text -noout -verify -in CSR.csr
```
.key : Check a private key
```
openssl rsa -in privateKey.key -check
```
.crt : Check a certificate
```
openssl x509 -in certificate.crt -text -noout
```
.pfx|.p12 : Check a PKCS#12 file (.pfx or .p12)
```
openssl pkcs12 -info -in keyStore.p12
```

### Command openssl modify
.crt|.cer|.der -> .pem : Convert a DER file (.crt .cer .der) to PEM
```
openssl x509 -inform der -in certificate.cer -out certificate.pem
```
.pem -> .der : Convert a PEM file to DER
```
openssl x509 -outform der -in certificate.pem -out certificate.der
```
.pfx|.p12 -> .pem : Convert a PKCS#12 file (.pfx .p12) containing a private key and certificates to PEM

You can add -nocerts to only output the private key or add -nokeys to only output the certificates.
```
openssl pkcs12 -in keyStore.pfx -out keyStore.pem -nodes
```
.key,.crt -> .pfx|.p12 : Convert a PEM certificate file and a private key to PKCS#12 (.pfx .p12)
```
openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt -certfile CACert.crt
```
