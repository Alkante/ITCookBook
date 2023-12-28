# Shell

to understand the Bash manual about Startup Files and the Bash man page.
Mainly, 4 files are read: /etc/bash.bashrc, /etc/profile, ~/.bashrc, ~/.profile

# Login shells

Typical commands: ssh user@host, su - user, /bin/bash --login
Startup files executed:
```
/etc/profile, which also sources
/etc/bash.bashrc and then all files matching
/etc/profile.d/*.sh
~/.profile, which also sources
~/.bashrc
```

# Interactive non-login shells
Typical commands: su user, /bin/bash [-i], "subshells" as sometimes run by programs when they offer shells
Startup files executed:
```
/etc/bash.bashrc
~/.bashrc
```

# Non-interactive shells
Typical commands: ssh [-t] user@host command, /bin/bash -c command, shebang style script shells (#!/bin/bash), and shells as run by programs when they offer shells, e.g. ^Z in nano
Startup files executed:
```
None
```
Actually, Bash tries to detect whether it is run by ssh user@host command or not. In case of these "non-interactive login shells" Bash executes /etc/bash.bashrc and ~/.bashrc. But in Debian Squeeze both files quit right at the start due to the fact that their first command is [ -z "$PS1" ] && return.

# Overview table

|Shell type| /etc/profile | /etc/bash.bashrc |~/.profile | ~/.bashrc |
|---|---|---|----|-----|
| Login shells | X | X | X | X |
| Interactive non-login | | X | | X |
| Non-interactive | | | | |
| /bin/bash --posix
| /bin/sh --login | X | X | X | X |
| /bin/sh
