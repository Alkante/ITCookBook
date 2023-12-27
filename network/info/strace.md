# strace

strace permettent d'appeler un aprogramme et de regarder tout ces traces
Avantage :
- Il regarde tout, PID, network, ...
Désavantage :
- Le strace ralenti considérablement les performances (il est lourd)


## Usage

| Options | Description |
|-------- |------------ |
| -f  | trace aussi les processus filles |
| -e  |  trace TYPE, enregiste les traces du type |

## Tracer le network d'un programme
```bash
strace -f -e trace=network -s 10000 PROCESS ARGUMENTS
```

## Tacer le network d'un programme existant
```bash
strace -p $PID -f -e trace=network -s 10000
```
