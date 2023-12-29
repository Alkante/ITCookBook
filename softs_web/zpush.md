# zpush 2.3

### requisites : php5.4
### depot wheezy
```
echo 'deb http://repo.z-hub.io/z-push:/final/Debian_7.0/ /' >> /etc/apt/sources.list
wget -qO - http://repo.z-hub.io/z-push:/final/Debian_7.0/Release.key |  apt-key add -
```

### install
```
cd /usr/local/src/
cd /usr/share/z-push/backend/
wget "http://downloads.sourceforge.net/project/zimbrabackend/Release65/zimbra65.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fzimbrabackend%2Ffiles%2FRelease65%2F&use_mirror=netcologne" -O zimbra65.tgz
wget "http://downloads.sourceforge.net/project/zimbrabackend/Release65/zpzb-install.sh?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fzimbrabackend%2Ffiles%2FRelease65%2F&use_mirror=netcologne" -O zpzb-install.sh
```
