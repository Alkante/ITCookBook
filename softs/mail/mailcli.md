# Mail cli
## mailx
```bash
printf "%b" "corps du message\nCoucou" | mail -s "Sujet"  -r returnpath destinataire
```

## sendmail
```bash
printf "%b" "Subject: sujet\ncorps du message\nCoucou" | sendmail  -freturnpath destinataire
```
