# Importation conf nagios
## Installation du module GLAPI
Télécharger les sources sur : https://download.centreon.com/

Etape :

	tar xzf centreon-clapi-XXX.tar.gz
	cd centreon-clapi-XXX
	./install.sh -i
Script :

	------------------------------------------------------------------------
	Load parameters
	------------------------------------------------------------------------
	Please specify the directory that contains "instCentWeb.conf"
	> /etc/centreon/

Sur l'interface web : Administration -> Modules -> Installer

## Script Nagios Reader
### Prérequis :
	apt-get install libmodule-build-perl
	apt-get install liblist-compare-perl
	wget http://search.cpan.org/CPAN/authors/id/D/DU/DUNCS/Nagios-Object-0.21.20.tar.gz
	tar xzf Nagios-Object-0.21.20.tar.gz
	cd Nagios-Object-0.21.20
	perl Build.PL
	./Build
	./Build test
	./Build install
Utilisation

	git clone https://github.com/centreon/nagiosToCentreon.git
	cd nagiosToCentreon

### Exportation :
	perl nagios_reader_to_centreon_clapi.pl --config /usr/local/nagios/etc/nagios.cfg > clapi_import.txt

### Importation : 
	/usr/share/centreon/www/modules/centreon-clapi/core/centreon -u admin -p @PASSWORD -i clapi_import.txt


/!\\ Le script ne fonctionnera pas si vous avez un groupe d'hostes avec comme membres toutes les hostes (" * "), il faut lister tous les hostes du groupe.

/!\\ Les services lié a des groupes d'hosts seront modifier et pour etre des services par host


