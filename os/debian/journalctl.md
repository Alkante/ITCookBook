# Journalctl
Journalctl est l'utilitaire qui permet de consulter les logs de tous les services

## Help
```
journalctl [OPTIONS...] [MATCHES...]

Query the journal.

Source Options:
     --system                Show the system journal
     --user                  Show the user journal for the current user
  -M --machine=CONTAINER     Operate on local container
  -m --merge                 Show entries from all available journals
  -D --directory=PATH        Show journal files from directory
     --file=PATH             Show journal file
     --root=ROOT             Operate on files below a root directory
     --image=IMAGE           Operate on files in filesystem image
     --namespace=NAMESPACE   Show journal data from specified journal namespace

Filtering Options:
  -S --since=DATE            Show entries not older than the specified date
  -U --until=DATE            Show entries not newer than the specified date
  -c --cursor=CURSOR         Show entries starting at the specified cursor
     --after-cursor=CURSOR   Show entries after the specified cursor
     --cursor-file=FILE      Show entries after cursor in FILE and update FILE
  -b --boot[=ID]             Show current boot or the specified boot
  -u --unit=UNIT             Show logs from the specified unit
     --user-unit=UNIT        Show logs from the specified user unit
  -t --identifier=STRING     Show entries with the specified syslog identifier
  -p --priority=RANGE        Show entries with the specified priority
     --facility=FACILITY...  Show entries with the specified facilities
  -g --grep=PATTERN          Show entries with MESSAGE matching PATTERN
     --case-sensitive[=BOOL] Force case sensitive or insensitive matching
  -k --dmesg                 Show kernel message log from the current boot

Output Control Options:
  -o --output=STRING         Change journal output mode (short, short-precise,
                               short-iso, short-iso-precise, short-full,
                               short-monotonic, short-unix, verbose, export,
                               json, json-pretty, json-sse, json-seq, cat,
                               with-unit)
     --output-fields=LIST    Select fields to print in verbose/export/json modes
  -n --lines[=INTEGER]       Number of journal entries to show
  -r --reverse               Show the newest entries first
     --show-cursor           Print the cursor after all the entries
     --utc                   Express time in Coordinated Universal Time (UTC)
  -x --catalog               Add message explanations where available
     --no-hostname           Suppress output of hostname field
     --no-full               Ellipsize fields
  -a --all                   Show all fields, including long and unprintable
  -f --follow                Follow the journal
     --no-tail               Show all lines, even in follow mode
  -q --quiet                 Do not show info messages and privilege warning

Pager Control Options:
     --no-pager              Do not pipe output into a pager
  -e --pager-end             Immediately jump to the end in the pager

Forward Secure Sealing (FSS) Options:
     --interval=TIME         Time interval for changing the FSS sealing key
     --verify-key=KEY        Specify FSS verification key
     --force                 Override of the FSS key pair with --setup-keys

Commands:
  -h --help                  Show this help text
     --version               Show package version
  -N --fields                List all field names currently used
  -F --field=FIELD           List all values that a specified field takes
     --list-boots            Show terse information about recorded boots
     --disk-usage            Show total disk usage of all journal files
     --vacuum-size=BYTES     Reduce disk usage below specified size
     --vacuum-files=INT      Leave only the specified number of journal files
     --vacuum-time=TIME      Remove journal files older than specified time
     --verify                Verify journal file consistency
     --sync                  Synchronize unwritten journal messages to disk
     --relinquish-var        Stop logging to disk, log to temporary file system
     --smart-relinquish-var  Similar, but NOP if log directory is on root mount
     --flush                 Flush all journal data from /run into /var
     --rotate                Request immediate rotation of the journal files
     --header                Show journal header information
     --list-catalog          Show all message IDs in the catalog
     --dump-catalog          Show entries in the message catalog
     --update-catalog        Update the message catalog database
     --setup-keys            Generate a new FSS key pair
```

## Toutes les logs depuis le dernier boot
```bash
journalctl -b
```

## Consultation de log pour un service
Exemple avec nginx
```bash
journalctl -u nginx
```

Exemple avec plus de détail et directement à la fin de la pagination
```bash
journalctl -u nginx -xe
```


Suivire le flux (équivalent de ```tail -f```)
```bash
journalctl -u nginx -f
```

Uniquement un certain nombre de ligne (équivalent de ```tail -n 50```)
```bash
journalctl -u nginx -n 50
```

Cas particulier de postfix
```bash
journalctl -u 'postfix*'
```

Récupérer la liste :
```bash
journalctl --field _SYSTEMD_UNIT |grep -v session
```

## Consultation de log avec une date
Exemple pour aujourd'hui avec nginx :
```bash
journalctl -u nginx.service --since today
```
Exemple avec postfix entre 8h et 12h:
```bash
journalctl -u 'postfix*' -S "2024-05-06 08:00:00" -U "2024-05-06 12:00:00"
```

Ici on spécifie ```'postfix*'``` car posIl est parfois nécessaire de spécifier avec une regar

## Recherche de pattern
Exemple avec postfix avec une recherche en 8h et 12h sur les mails d'orange:
```bash
journalctl -u 'postfix*' -S "2024-05-06 08:00:00" -U "2024-05-06 12:00:00" -g orange
```
Si besoin de pipe
```bash
journalctl --no-pager |grep gpg
```
## Consultation des logs docker
Prérequis dans le fichier /etc/docker/daemon.json :
```json
{
    ...
    "log-driver": "journald",
    "log-opts": {
        "tag": "{{.Name}}/{{.ID}}"
    }
}
```
Consultation:
```bash
journalctl CONTAINER_NAME=privatebin
```

## Consultation par processus
Lister par UID disponible:
```bash
journalctl -F _UID
```
Lister par GID disponible:
```bash
journalctl -F _GID
```

Consultation
```bash
journalctl _UID=109
```

## Consulation des logs kernel
```bash
journalctl -k
```

## Format de sortie
Format possible :
- cat : affiche uniquement le champ du message en lui-même.
- export : un format binaire adapté au transfert ou à la sauvegarde de données.
- json : JSON standard avec une entrée par ligne.
- json-pretty : JSON formaté pour une meilleure lisibilité par l’homme
- json-sse : résultat formaté sous JSON enveloppé pour que l’événement add server-sen soit compatible
- short : la sortie de style syslog par défaut
- short-iso :le format par défaut a été augmenté pour afficher les horodatages d’horloge murale ISO 8601
- short-monotonic : le format par défaut avec des horodatages monotones.
- short-precise : le format par défaut avec précision à la microseconde près
- verbose : affiche chaque champ de journal disponible pour l’entrée, y compris ceux généralement cachés en interne.

Exemple pour json
```bash
journalctl CONTAINER_NAME=privatebin -o json-pretty
```
Cela permet de voir tous les champs possible, par exmeple :
```bash
journalctl CONTAINER_NAME=privatebin -o json-pretty
{
        "_CMDLINE" : "/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock",
        "__CURSOR" : "s=XXXXXX;i=XXXXX;b=XXXXXXX;m=XXXX;t=XXXX;x=XXXX",
        "_SYSTEMD_INVOCATION_ID" : "XXXXXx",
        "_SYSTEMD_UNIT" : "docker.service",
        "_EXE" : "/usr/bin/dockerd",
        "SYSLOG_IDENTIFIER" : "privatebin/XXXXXXX",
        "__MONOTONIC_TIMESTAMP" : "10910771944713",
        "MESSAGE" : "10.10.78.1 - - [02/May/2024:20:35:12 +0200] \"GET / HTTP/1.0\" 200 17600 \"-\" \"check_http/v2.3.3 (nagios-plugins 2.3.3)\" \"1.2.3.4\"",
        "_TRANSPORT" : "journal",
        "_BOOT_ID" : "XXXXXXXXXx",
        "_SYSTEMD_CGROUP" : "/system.slice/docker.service",
        "_SYSTEMD_SLICE" : "system.slice",
        "_SOURCE_REALTIME_TIMESTAMP" : "1714674912890068",
        "PRIORITY" : "6",
        "IMAGE_NAME" : "privatebin/nginx-fpm-alpine",
        "_COMM" : "dockerd",
        "CONTAINER_ID" : "XXXXXXXx",
        "_CAP_EFFECTIVE" : "1ffffffffff",
        "_RUNTIME_SCOPE" : "system",
        "CONTAINER_LOG_ORDINAL" : "XXXX",
        "__REALTIME_TIMESTAMP" : "1714674912890105",
        "CONTAINER_LOG_EPOCH" : "XXXXXXXXXXXXXXXXXXXXXXXXXX",
        "_HOSTNAME" : "mamachine",
        "_GID" : "0",
        "SYSLOG_TIMESTAMP" : "2024-05-02T18:35:12.889958678Z",
        "CONTAINER_ID_FULL" : "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx",
        "CONTAINER_TAG" : "privatebin/XXXXXXXX",
        "_UID" : "0",
        "CONTAINER_NAME" : "privatebin",
        "_SELINUX_CONTEXT" : "unconfined\n",
        "_MACHINE_ID" : "XXXXXXXXXXXXXXXXXXXX",
        "_PID" : "3576"
}
```

## Gestion de l'espace disque des logs
Info:
```bash
journalctl --disk-usage
```
En taille :
```bash
journalctl --vacuum-size=1G
```
En nombre de jour
```bash
journalctl --vacuum-time=5d
```
