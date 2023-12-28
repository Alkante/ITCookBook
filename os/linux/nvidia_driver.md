# Nvidia driver

##Installer les parquets pour de la compilation
```bash
apt-get install build-essential linux-headers-$(uname -r)
```

## Déscativer l'ancien driver
Désactiver le driver appelé "nouveau"

```bash
editor /etc/modprobe.d/disable-nouveau.conf
```
```text conf
# Disable nouveau
blacklist nouveau
options nouveau modeset=0
```

## Installer les drivers Nvidia
```bash
apt search nvidia-driver-
apt install -y nvidia-driver-XXX
```
