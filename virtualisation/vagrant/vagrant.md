# Vagrant
<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Vagrant](#vagrant)
	- [Context](#context)
	- [Commandes usuelles](#commandes-usuelles)
	- [Création d'un projet](#cration-dun-projet)
	- [obtenir rapidement une box sans se poser de questions](#obtenir-rapidement-une-box-sans-se-poser-de-questions)
- [vagrant init [box/version]](#vagrant-init-boxversion)
	- [exemple de fichier Vagrantfile basique](#exemple-de-fichier-vagrantfile-basique)
	- [réinitialiser les clés SSH par défaut pour une VM](#rinitialiser-les-cls-ssh-par-dfaut-pour-une-vm)

<!-- /TOC -->


## Context

Vagrant est un outil de provisionning de VM compatible avec des hyperviseurs et logiciels tels que VirtualBox.

## Installation
```bash
echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" >> /etc/apt/sources.list.d/virtualbox.list
apt-key fingerprint 0EBFCD88
wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
apt-key add oracle_vbox_2016.asc
rm oracle_vbox_2016.asc
apt update
apt-get install linux-headers-amd64
apt-get install virtualbox-5.1 virtualbox-guest-utils virtualbox-guest
wget https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.deb
dpkg -i  vagrant_2.0.2_x86_64.deb
rm vagrant_2.0.2_x86_64.deb
```

## Commandes usuelles

- avec un Vagrantfile existant dans le répertoire courant :

```bash
vagrant up
vagrant ssh
vagrant halt
vagrant destroy [-f]
```
- pour créer une box à partir d'une VM existante et pré-configurée :

```bash
cd /path/to/folder/
vagrant package [--base <vm_name>]
```

**à noter**

-> Eviter d'éteindre la VM avec poweroff ou reboot, sinon les connections réseaux de la VM deviennent instables (this is a big myster)
-> Utiliser exit ou logout pour se déconnecter de la session SSH et utiliser les commandes `vagrant halt` ou `vagrant reload`


## Création d'un projet

```bash
mkdir vagrant_getting_started
cd vagrant_getting_started
vagrant init
```


## obtenir rapidement une box sans se poser de questions

```
mkdir mybox && cd mybox
# vagrant init [box/version]
vagrant init debian/stretch64
vagrant up && vagrant ssh
```


## exemple de fichier Vagrantfile basique

```
Vagrant.configure("2") do |config|

    #config.vm.box = "debian/stretch64"
    config.vm.box = "http://mirror.exemple.com/box/stretch.box"

    config.vm.provider "virtualbox" do |v|
        v.memory = 256
        #v.name = "stretch64"
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end
end
```


## réinitialiser les clés SSH par défaut pour une VM

il peut arriver que la commande `vagrant ssh` retourne une erreur du type :

"default: Warning: Authentication failure. Retrying..."

il est possible de réinitialiser les clés SSH "insecure_private_key", pour cela il faut se connecter à la VM par un autre moyen (VNC, console VirtualBox, ssh via une autre VM...) puis executer les commandes suivantes :

```bash
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
wget --no-check-certificate \
    https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
    -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
```
Pour utiliser la clé privée:
```
wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant
```

# Manage space used b yboxes

## list
```
vagrant box list
http://mirror.exemple.com/box/centos7.box (virtualbox, 0)
http://mirror.exemple.com/box/jessie.box  (virtualbox, 0)
http://mirror.exemple.com/box/stretch.box (virtualbox, 0)
http://mirror.exemple.com/box/wheezy.box  (virtualbox, 0)
```
Les boxes sont stockées dans ~/.vagrant.d/boxes/ :
```
du -hs  ~/.vagrant.d/boxes/*
499M    /home/pnom/.vagrant.d/boxes/http:-VAGRANTSLASH--VAGRANTSLASH-mirror.exemple.com-VAGRANTSLASH-box-VAGRANTSLASH-centos7.box
1,2G    /home/pnom/.vagrant.d/boxes/http:-VAGRANTSLASH--VAGRANTSLASH-mirror.exemple.com-VAGRANTSLASH-box-VAGRANTSLASH-jessie.box
340M    /home/pnom/.vagrant.d/boxes/http:-VAGRANTSLASH--VAGRANTSLASH-mirror.exemple.com-VAGRANTSLASH-box-VAGRANTSLASH-stretch.box
476M    /home/pnom/.vagrant.d/boxes/http:-VAGRANTSLASH--VAGRANTSLASH-mirror.exemple.com-VAGRANTSLASH-box-VAGRANTSLASH-wheezy.box
```

## remove
```
vagrant box remove http://mirror.exemple.com/box/jessie.box
```
