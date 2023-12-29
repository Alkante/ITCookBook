# SSL scan
```bash
wget  https://github.com/Iansus/OpenSSLScan/archive/master.zip -O - sslscan.zip
unzip sslscan.zip
cd sslscan-master
sudo apt-get install libssl-dev
make static
sudo make install
```
Test faille heartbleed
```bash
/usr/bin/sslscan --ssl2 app1.exemple.com
```
