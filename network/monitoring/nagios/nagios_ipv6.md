# Nagios3 avec l'IPv6
## Check des deux adresses
Création de deux serives associé à un groupe d'host

### Host
File : /etc/nagios3/conf.d/generic-host_nagios2.cfg

	define host {
		use			generic-host
		host_name	pfsense
		alias		pfsense vers exterieur
		address		pfsense.exemple.fr
		_ADDRESS4	192.168.191.254
		_ADDRESS6	2001::ffff
	}

### Hostgroups
File: /etc/nagios3/conf.d/hostgroups_nagios2.cfg

	define hostgroup {
		hostgroup_name	reseau
		alias			Composants réseau
		members 		pfsense, dhcp-dns
	}

### Service
File : /etc/nagios3/conf.d/generic-service_nagios2.cfg

	define service {
		use 		generic-service
		hostgroup_name	reseau
		service_descrition	Adresse IPv4
		Check_command	check-host-alive_4
	}
	define service {
		use 		generic-service
		hostgroup_name	reseau
		service_descrition	Adresse IPv6
		Check_command	check-host-alive_6
	}

### Commandes
Création d'une commande ping en IPv6
File : /etc/nagios3/commands.cfg

	define command{
		command_name	check_ping_6
		command_line	/usr/lib/nagios/check_ping -H '$_HOSTADDRESS6$' -w '$ARG1$' -c '$ARG2$' -6
	}
	define command{
		command_name	check-host-alive_6
		command_line	/usr/lib/nagios/check_ping -H '$_HOSTADDRESS6$' -w 5000,100% -c 5000,100% -p 1 -6
	}
