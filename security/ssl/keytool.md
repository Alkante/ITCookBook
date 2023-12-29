# java keytool

## creation cert dans le store cas.keystore
```bash
keytool -keysize 4096 -genkey -alias tomcat -keyalg RSA -keystore cas.keystore  -storepass changeit -validity 3600
```
set SAN (Subject Alternative Name):
```
keytool -keysize 4096 -genkey -alias app1.exemple.com -ext SAN=dns:app1.exemple.com -keyalg RSA -keystore keystore092019 -storepass changeit -validity 3600
```

## voir cert dans le store java cas.keystore
```bash
keytool -list -v -keystore cas.keystore
changeit
```
ou non-interactive
```bash
keytool -list -v -keystore /etc/ssl/certs/java/cacerts -deststorepass changeit -noprompt
keytool -list -v -keystore /etc/tomcat7/keystore/app.keystore -deststorepass $SSL_PWD -noprompt
```

## export cert
```bash
keytool -export -alias tomcat -file /tmp/app.crt -keystore cas.keystore
```
## import du cert dans le cacert global
```bash
keytool -import -alias tomcat -file /tmp/app.crt -keystore /usr/lib/jvm/default-java/jre/lib/security/cacerts
changeit (default java password)
```
import sans prompt password dans le truststore global
```bash
keytool -import -trustcacerts  -keystore /etc/ssl/certs/java/cacerts -storepass changeit -noprompt -file "$SSLDIR/CA_intermediate.pem" -alias wildcardappCA
```
import sans prompt password dans le keystore protegé par $SSL_PWD
```bash
keytool -importkeystore -destkeystore /etc/tomcat7/keystore/app.keystore -srckeystore /etc/tomcat7/keystore/wildcard.p12.$YEAR -srcstoretype pkcs12 -srcalias wildcardapp -srcstorepass $SSL_PWD -deststorepass $SSL_PWD -noprompt
```
## change alias
```bash
keytool -changealias -keystore /etc/tomcat7/keystore/app.keystore -alias wildcardapp -destalias wildcard.app -deststorepass $SSL_PWD -noprompt
keytool -changealias -keystore /etc/ssl/certs/java/cacerts -alias wildcardappca -destalias wildcard.appCA  -deststorepass changeit -noprompt
```
