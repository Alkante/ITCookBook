# apt-mirror
<!-- TOC -->

- [apt-mirror](#apt-mirror)
                    - [####### config](#-config)
- [deisable/enable postmirror execution](#deisableenable-postmirror-execution)
                    - [####### end config](#-end-config)
- [deb-src http://ftp.fr.debian.org/debian jessie unstable main contrib non-free unstable](#deb-src-httpftpfrdebianorgdebian-jessie-unstable-main-contrib-non-free-unstable)
- [Security updates](#security-updates)
- [deb     http://security.debian.org/ jessie/updates  main contrib non-free](#deb-----httpsecuritydebianorg-jessieupdates--main-contrib-non-free)
- [deb-src http://security.debian.org/ jessie/updates  main contrib non-free](#deb-src-httpsecuritydebianorg-jessieupdates--main-contrib-non-free)
- [mirror additional architectures](#mirror-additional-architectures)
- [deb-alpha http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-alpha-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-amd64 http://ftp.fr.debian.org/debian jessie unstable main contrib non-free](#deb-amd64-httpftpfrdebianorgdebian-jessie-unstable-main-contrib-non-free)
- [deb-armel http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-armel-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-hppa http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-hppa-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-i386 http://ftp.us.debian.org/debian jessie unstable main contrib non-free](#deb-i386-httpftpusdebianorgdebian-jessie-unstable-main-contrib-non-free)
- [deb-ia64 http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-ia64-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-m68k http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-m68k-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-mips http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-mips-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-mipsel http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-mipsel-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-powerpc http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-powerpc-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-s390 http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-s390-httpftpusdebianorgdebian-unstable-main-contrib-non-free)
- [deb-sparc http://ftp.us.debian.org/debian unstable main contrib non-free](#deb-sparc-httpftpusdebianorgdebian-unstable-main-contrib-non-free)

<!-- /TOC -->


`apt-mirror` permet de créer un mirroir d'un repot linux.
Les postes linux passeront par le mirroir pour les intallations et/ou les mise à jours.
Le mirroir fait office de cache à la demande.

## Installation

```bash
apt-get update
apt-get install apt-mirror
```

Créer un dossier qui accueillera les dépots
```bash
mkdir /var/spool/apt-mirror
```

## Configuration


```bash
editor /etc/apt/mirror.list
```

Chosir les dépots cible
```conf
############# config ##################
#
set base_path    /var/spool/apt-mirror
#
set mirror_path  $base_path/mirror
set skel_path    $base_path/skel
set var_path     $base_path/var
set cleanscript $var_path/clean.sh
set defaultarch  amd64
set postmirror_script $var_path/postmirror.sh
# deisable/enable postmirror execution
set run_postmirror 0
set nthreads     20
set _tilde 0
#
############# end config ##############


deb http://ftp.fr.debian.org/debian jessie unstable main contrib non-free unstable
#deb-src http://ftp.fr.debian.org/debian jessie unstable main contrib non-free unstable


#  Security updates
#deb     http://security.debian.org/ jessie/updates  main contrib non-free
#deb-src http://security.debian.org/ jessie/updates  main contrib non-free

# mirror additional architectures
#deb-alpha http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-amd64 http://ftp.fr.debian.org/debian jessie unstable main contrib non-free
#deb-armel http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-hppa http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-i386 http://ftp.us.debian.org/debian jessie unstable main contrib non-free
#deb-ia64 http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-m68k http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-mips http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-mipsel http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-powerpc http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-s390 http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-sparc http://ftp.us.debian.org/debian unstable main contrib non-free

clean http://ftp.fr.debian.org/debian

```

UNDER CONSTRUCTION
