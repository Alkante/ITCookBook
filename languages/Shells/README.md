# Shells

### Liste des shell disponible
```
cat /etc/shell
```

### Shell par défaut pour les utilisateurs
```
cat /etc/passwd
```


### Fichier lu lors d'un connexion terminal interactive
Files read:

    /etc/profile
    ~/.bash_profile, ~/.bash_login or ~/.profile: first existing readable file is read
    ~/.bash_logout upon logout.



### Fichier lu lors d'un connexion terminal non interactive
A non-login shell means that you did not have to authenticate to the system. For instance, when you open a terminal using an icon, or a menu item, that is a non-login shell.

Files read:

    ~/.bashrc

This file is usually referred to in ~/.bash_profile:
```
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
```

All scripts use non-interactive shells. They are programmed to do certain tasks and cannot be instructed to do other jobs than those for which they are programmed.

Files read:

    defined by BASH_ENV

PATH is not used to search for this file, so if you want to use it, best refer to it by giving the full path and file name.


### Type de commande supportés
Bash supports 3 types of built-in commands:

    Bourne Shell built-ins:

	:
	.
	break
	cd
	continue
	eval
	exec
	exit
	export
	getopts
	hash
	pwd
	readonly
	return
	set
	shift
	test
	[
	times
	trap
	umask
	unset

    Bash built-in commands:

    alias, bind, builtin, command, declare, echo, enable, help, let, local, logout, printf, read, shopt, type, typeset, ulimit and unalias.

    Special built-in commands:

    When Bash is executing in POSIX mode, the special built-ins differ from other built-in commands in three respects:

        Special built-ins are found before shell functions during command lookup.

        If a special built-in returns an error status, a non-interactive shell exits.

        Assignment statements preceding the command stay in effect in the shell environment after the command completes.

    The POSIX special built-ins are :, ., break, continue, eval, exec, exit, export, readonly, return, set, shift, trap and unset.

### Afficher toutes les variables globales
```
env
printenv
```
