# Samba partage
```
apt-get install samba
```
contenu de smb.conf:
```
echo '
[global]
        map to guest = Bad User

        log file = /var/log/samba/%m
        log level = 1


[guest]
        # This share allows anonymous (guest) access
        # without authentication!
        path = /var/app/rails/
        read only = no
        guest ok = yes
        create mask = 0660
        force create mode = 0660
        directory mask = 0770
        force directory mode = 0770
        force user = share
        force group = rvm
' > /etc/samba/smb.conf
/etc/init.d/samba restart
```

# conf client
```
echo '
/mnt2     /etc/auto.perso   --ghost,--timeout=90
' >> /etc/auto.master
echo '
share -fstype=cifs,guest,uid=11037,noforceuid,gid=10117,noforcegid,file_mode=0775,dir_mode=0775 ://192.168.0.1/guest
' >> /etc/auto.perso
service autofs restart
```
