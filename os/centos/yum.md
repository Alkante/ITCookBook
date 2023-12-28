# yum

## Reposotories


La commande ```yum``` puis :
| Options | Description |
|- |- |
|```repolist all``` | Liste les repos et leur status |
|```--enable-repo=base``` |Active temporairement un repos |
|```--disable-repo=base``` |Désactive temporairement un repos |

### Activer définitivement un repository
```bash
sed -i -e "s/enabled=0/enabled=1/" /etc/yum.repos.d/CentOS-Base.repo
```


## Useful flags

| Options | Description |
|- |- |
|```--y``` | Assume yes for all prompts |
|```--assumeno``` |Assume no for all prompts |
|```--nogpgcheck``` |Disable GPG verification |
|```--skip-broken``` |Skips packages that whose dependencies can’t be resolved. |


# Package Management
## Installing an RPM package
### Installing an RPM package from remote repositories
```bash
yum install [package-name]
```
### Installing a local RPM package
```bash
yum install /path/to/vim-1.2.rpm
```
Installing a specific version of a package
```bash
yum install gcc-4.0
```
## Removing an RPM package and dependencies
Removes a package and any package it depends on (provided nothing else depends on it).
```bash
yum remove [package-name]
```
Note: this will only remove the binaries and libraries, any configuration files will stay intact.
## Downgrade a package

This will install the package’s previous version.
```bash
yum downgrade [package-name]
```
## View a package’s dependencies
```bash
yum deplist [package-name]
```
## Listing packages

The yum list command can take different arguments:
### List all available packages from repositories
```bash
yum list available
```
### List installed packages
```bash
yum list installed
yum list installed *openjdk*
```
ou
```bash
rpm -qa
rpm -qa |grep java-1.8.0-openjdk
```
### List installed and available packages
```bash
yum list all
```

### List all packages (installed or available) that match a given [package-name], can be a glob
```bash
yum list [package-name]
yum list mysql*
```
## Search for package

This searches for [package-name] across all repositories, also looking inside package descriptions.
```bash
yum search [package-name]
```
## Upgrade all system packages
```bash
yum upgrade
```
This command installs all of the latest versions of each package installed on the system and is, generally, not recommended to be run on production systems.
## Reinstall a single package

Sometimes, it’s necessary to force reinstallation of a package.
```bash
yum reinstall [package-name]
```    
## View info for a package
```bash
yum info [package-name]
```
## Find which RPM package installs a given file

This command is very handy when it’s not obvious which package needs to be installed to use it.
```bash
yum provides [file]
```
yum provides can also take a glob:
```bash
yum provides "*/bin/vim"
```
## List all dependencies for a given package
```bash
yum provides [package-name]
```



# Package Groups

Note: yum now has a groups subcommand for group operations, versions before 3.4.x should refer to this document instead.

yum has the concept of “package groups”, groups of related packages that can be installed or uninstalled at once, that don’t necessarily depend on each other.
## List all groups
```bash
yum group list
```
## Install all packages for a group
```bash
yum group install "Basic Web Server"
```
## Remove all packages for a group
```bash
yum group remove "Basic Web Server"
```



# Repository Management
## List all repositories
```bash
yum repolist
```
## List all packages for a given [repository]
(Note: yum > 3.4.x only)
```bash
yum repo-pkgs [repository] list
yum repo-pkgs Updates-ambari-2.4.2.0 list
```
## Install all packages from given [repository]
(Note: yum > 3.4.x only)
```bash
yum repo-pkgs [repository] install
```
## Remove all packages from a given [repository]
(Note: yum > 3.4.x only)
```bash
yum repo-pkgs [repository] remove
```
## Update local metadata cache
This is run automatically by yum as needed, but can be refreshed manually with yum makecache
```bash
yum makecache
```
When this command is run, all available packages are fetched and re-indexed from the repositories yum knows about.




# yum-utils and yumdownloader

In order to download source packages, it’s necessary to install an additional package for yum, called “yum-utils”, which provides a yumdownloader binary, among other things.
## Downloading RPMs
### Downloading RPM from remote repositories
```bash
yumdownloader [package-name]
```
## Downloading Source RPMs
```bash
yumdownloader --source [package-name]
```
## Downloading all dependencies for an RPM
```bash
yumdownloader --resolve [package-name]
```
## Filtering by architecture
```bash
yumdownloader --archlist=[arch-list]  [package-name]
```

## show files provided by package
package content
```bash
repoquery -q -l {package-name-here}
repoquery -q -l --plugins {package-name-here}
repoquery -q -l --plugins *{package-name-here}*
```
dans un rpm:
```bash
rpm -qlp checkinstall-1.6.2-1.cnt6.x86_64.rpm
```

## show package requirements
pour ambari-server quels paquets vont être installés?
```bash
repoquery --requires ambari-server-2.4.2.0-136
```
ou:

```bash
yum deplist ambari-server-2.4.2.0-136
```
pour un fichier:
```bash
rpm -qp --requires ambari-server-2.4.2.0-136
```


## show package depending
quels paquets installés sur le système requièrent openssl
```bash
rpm -q --whatrequires openssl
ambari-server-2.4.2.0-136.x86_64
ambari-agent-2.4.2.0-136.x86_64
```
```bash
repoquery --whatrequires openssl
```
