# Password
## change password
```bash
echo -e "YYYYYY\nYYYYYY" | (passwd root)
echo ftp_test:test | chpasswd
```


## random password
```bash
head -c 12 /dev/random | uuencode -m - | tail -n 2 | head -n 1
pwgen -cnys1 8 1
echo $RANDOM
apg -m 14 -n 1 -M SNCL
apg -m 20 -n 15 -M SNCL -t
```

## base 64 encode
```bash
echo -n "sdqf" | openssl enc -base64
echo -n "lqsdm=" | openssl enc -base64 -d
```


## /etc/shadow
```bash
openssl passwd -1 -salt xyz  yourpass
```

OU
```bash
mkpasswd -m sha-512  -s <<< toto
mkpasswd -m sha-512  -s
```
