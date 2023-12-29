# Logrotate
<!-- TOC -->

- [Logrotate](#logrotate)
    - [Installation](#installation)
    - [Configuration](#configuration)

<!-- /TOC -->

## Installation
```bash
apt-get install logrotate
```


## Configuration
Editer ```/etc/logrotate.conf```

Add your log :
```
/var/log/lns/* {
# If file is root
    su root root
# Is not abnormal if logs does not exist
    missingok
# Max size of logs
    size 300M
# Add date in name file
    dateext
# Compress file
    delaycompress
# We have 3 file, .log, 23.12.16.log and 23.12.16.log.tar.gz
    rotate 3
}

```

## Test

Pour tester :
```
cd /etc/logrotate.d
logrotate -f <fichier_logrotate>
```
```-f``` = force
