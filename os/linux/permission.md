# Permission
## Create user
```bash
adduser toto
```
## Add user to group
```bash
adduser toto audiogroup
```

## Change file group
```bash
chgrp audiogroup myfile
chgrp -R audiogroup mydir
```

## Change permissions
```bash
chmod 600 myfile
find . -type d -exec chmod 700 {} \;
find . -type f -exec chmod 600 {} \;
```

## Change owner &&|| group own
```bash
chown toto myfile
chown :toto myfile
chown toto:toto myfile
chown -R toto:toto mydir
```

## Delete user (/home/userdir is not deleted)
```bash
deluser toto
```

## Remove group access
```bash
del user toto audiogroup
```

## Add group administrator
```bash
gpasswd -a toto audiogroup
```

## Delete group administrator
```bash
gpasswd -r audiogroup
```

## Add group
```bash
groupadd mygroup
```

## Delete group
```bash
groupdel mygroup
```

## Modify groud id
```bash
groupmod -g 4355 mygroup
```

## Modify name group
```bash
groupmod oldgroupname newgroupname
```

## List user id and group id attached
```bash
id toto
```

## Change password
```bash
passwd toto
```

## add or change user param not interactif(!= adduser)
```
 -m Create dir if not create
 -d specify home dir
 -s Shell used
 -g group
```
```bash
useradd -m -p ChiffredPassWord toto
useradd -m -d /home/starwars -s /bin/bash anakin
useradd -d /dev/null -g openvpn -s /bin/false openvpn
useradd -d /dev/null -s /bin/false openvpn
```

## Delete user and home dir
```bash
userdel -r toto
```

## add toto in audio group without del toto of his own group
```bash
usermod -aG audio toto
```

## Rename home dir
```bash
usermod -d /home/titi -m -l titi toto
```


## Change user ID of a desktop user (with /home directory and user mounts in /media)
```bash
usermod -u UID myuser
chown -R myuser /home/myuser
cat <<EOF >/tmp/acl
user::rwx
user:myuser:r-x
group::---
mask::r-x
other::---

EOF

setfacl --set-file=/tmp/acl /media/myuser
```