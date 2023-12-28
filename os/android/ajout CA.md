# Ajout d'un certificat dans les CAs système Android
Prérequis : téléphone / tablette rooté

Source : https://medium.com/hackers-secrets/adding-a-certificate-to-android-system-trust-store-ae8ca3519a85

1. DL le certificat sur l'appareil
2. installer un terminal sur l'appareil (ou avoir un terminal adb)
3. dans le terminal :

```bash
su -
```

Autoriser les privilèges root

```bash
cat /proc/mounts | grep system
```

Récupérer le nom du device pour remonter le /system en lecture-écriture.

```bash
mount -o rw,remount /dev/block/xxxxxxxxxxxxxxx /system
```

Récupérer le "old_hash" du certificat :

```bash
openssl x509 -inform PEM -subject_hash_old -in <exported_cert_file>| head -1
```

Copier le certificat au bon endroit en le renommant avec le has précédemment récupéré (répertoire source à adapter suivant le téléphone) :

```bash
mv /media/0/Download/CA_exemple.com.crt /system/etc/security/cacerts/old_hash.0
chmod 644 /system/etc/security/cacerts/<old_hash>.0
chown root:root /system/etc/security/cacerts/<old_hash>.0
reboot
```
