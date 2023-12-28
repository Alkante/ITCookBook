# Files structures debian
```
/bin/       : Executable usuel systeme
/boot/      : Partion de démarage
	grub/   : Install de grub (
	config-****         : Fichier de config du noyau (y=partie du noyau; m=module; #=NULL)
	initrd.img-****     : (INITial RamDisk) système d'exploitation minimal
	System.map-****     : Contient l'emplacement du noyau
	vmlinuz-****        : Le noyau ou liens symbolique vers le noyau

/dev           : Le dev est intégralement régénéré (sauf parfois la console et le null)
	console    : console initiale (mknod -m 600 /dev/console c 5 1)
	null       : trou noir (mknod -m 666 /dev/null c 1 3)

/etc/          : Contient les configurations des paquets

	crontab    : Ficher configurant les actions répétées
	cron.d/    : Dossier contenant les exécutables lancées par /etc/crontab
		mdadm         :
		sysstat       :
	cron.daily :
		apt           : Gestionnaire de paquet (utilise dpkg)
		aptitude      : Gestionnaire de paquet user frendly (utilise dpkg)
		bsdmainutils  :
		dpkg          : Installeur de paquet
		exim4-base    :
		logrotate     : Rotation des logs
		man-db        :
		mdadm         : Gestionnaire raid
		mlocate       :
		passwd        :
		sysstat       : Programme installer
	cron.hourly:

	cron.monthly:

	cron.weekly:
		man-db

	default/     : ?
		locale          : Fichier de configuration des languages 1/2

	locale.gen   : Fichier de configuration des languages 2/2

	network/     : Configuration des cartes réseau
		if-down.d/      :
		if-post-down.d/ :
		if-pre-up.d/    :
		if-up.d/        :
		interfaces      : Fichier de config des interfaces réseau
		interfaces.d/   :
		run             : link
	NetworkManager/
	    system-connections/     : Dossier contennant les user/passwd des wifi enregistrés

	timezone     : Ficher de configuration de l'horloge utilisateur


/home
/initrd.img
/initrd.img.old
/lib
/lib64
/lost+found
/media
/mnt
/opt
/proc          : Régénéré au boot, comportant les informations et les options matérielles courantes et non persistant
/root
/run
/sbin
/srv
/sys           : Régénéré au boot, comportant les informations structurées de l'OS (en partie liées au hardware)
/tmp           : Purger à chaque shutdown, contenant les données temporaise des applications.
/usr           : Contient les données des paquet
	bin/       : Contient les exécutables des applications
	games/     :
	include/   : Contient des headers des applications (utiliser pour compiler un application ou une application tierce)
	lib/       : Contient les librairies (sources précompilées directement utilisable (charger) par un application tierce ou utilisé pour la compilation par un application tierce
	lib32/     : Idem que lib/ mais pour les architecture 32 bits
	local/     :
	sbin/      :
	share/     : Documment des programmes (Documentation, exemple de configuration, ...)
	src/       : Contient les fichiers sources des applications/des modules noyaux/du noyaux

/var           : Contient les fichiers ayant de forte change de varier dans le temps
	backups/   :
	cache/     :
	lib/       : Fichier variable générer/utiliser par les librairies
		dpkg/  : dpkg (instaleur de paquet)
			info/ : Chaque fichier détaille un paquet installé sur la machine
				PAQUET.list : Liste des dossier et fichier liées au PAQUET
				PAQUET.md5sums : Liste des hash md5 des fichiers liées au PAQUET
				PAQUET.postinst : Actions après installation du PAQUET
				PAQUET.postrm : Actions après supression du PAQUET

	local/     :
	lock/      :
	log/       : Contient les fichiers de log des programmes/services
	mail/      :
	opt/       :
	run/       :
	spool/     :
	tmp/       : Fichier temporaire dont le contenu est effacé à l'extinction de la machine

/vmlinuz
/vmlinuz.old
```
