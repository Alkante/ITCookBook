# Msmtp
Client mail sans service, de ce fait il est très pratique pour du container docker

## Docker
Utilisation dans un docker:

Dockerfile :
```bash
RUN apt update && apt install -yq msmtp-mta
ADD src/msmtprc /etc/msmtprc
```
File msmtprc :
```
account default

## Relay :
host smtp.example.com
port 25

## Return-path :
from return-path@example.com
### Force Return-path:
#auto_from on
#maildomain example.com

## Received :
domain dockername.example.com

## Auth :
#auth off
#user
#password

## TLS
tls off
#tls_starttls off
#tls_trust_file /etc/ssl/certs/ca-certificates.crt

## Log :
syslog off
#logfile /var/log/mail.log
```

Ou faire simplement un volume du fichier /etc/msmtprc
