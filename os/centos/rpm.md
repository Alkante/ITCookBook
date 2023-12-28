# rpm
## build
```bash
yum install rpm-build
```

### prepare env
```bash
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
```
### copy sources
```bash
cp my.tgz ~/rpmbuild/SOURCES
```
### edit spec
```bash
vi ~/rpmbuild/my.spec
```
### build
```bash
rpmbuild -v -bb ~/rpmbuild/SPECS/nagios-plugins.spec
```
### check

## sign
### prepare keys
#### import private key for signing
```bash
gpg --allow-secret-key-import --import /tmp/debianexemple.private
```
#### configure env
```bash
echo '%_gpg_name Custom Debian Packaging team <debian@exemple.com>
%_signature gpg
%_gpgbin /usr/bin/gpg
%_gpg_path /var/lib/jenkins/.gnupg' > ~/.rpmmacros
```
#### import pub key to verify
```bash
rpm --import /tmp/debianexemple.pub
```
### add
```bash
rpm --addsign /tmp/nagios-plugins-ent-1.4.13-1.x86_64.rpm
```
### verify
```bash
rpm -Kvv /tmp/nagios-plugins-ent-1.4.13-1.x86_64.rpm
```

## publish on repo
### on repo srv:
#### update repo with new pkg
```bash
mkdir -p /home/mirror/mirror/centos/7/custom/x86_64/Packages
cp nagios-plugins-ent-1.4.13-1.x86_64.rpm /home/mirror/mirror/centos/7/custom/x86_64/Packages/
createrepo --update /home/mirror/mirror/centos/7/custom/x86_64/
```
#### install gpg pub key
```bash
cp debian@exemple.com.pub /home/mirror/mirror/centos/
chmod +r /home/mirror/mirror/centos/debian@exemple.com.pub
```

### on cli:
```bash
echo '[entreprise]
name=Entreprise Repository
baseurl=http://mirror.exemple.com/centos/$releasever/custom/$basearch/
enabled=1
gpgkey = http://mirror.exemple.com/centos/debian@exemple.com.pub
gpgcheck=1' > /etc/yum.repos.d/exemple.repo
```
