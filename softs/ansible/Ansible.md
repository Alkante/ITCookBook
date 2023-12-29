# Ansible

<!-- TOC -->

- [Ansible](#ansible)
    - [Contexte](#contexte)
    - [Installation](#installation)
    - [Packet debian](#packet-debian)
    - [Paquet Ubuntu](#paquet-ubuntu)
        - [Via docker](#via-docker)
        - [Acces ssh](#acces-ssh)
    - [Configuration](#configuration)
    - [Utilisation](#utilisation)
    - [Playbook](#playbook)
    - [Versionning de l'architecture Ansible](#versionning-de-larchitecture-ansible)
    - [Monitoring](#monitoring)
    - [Semaphore](#semaphore)
        - [Dépendance](#dépendance)
    - [A trier](#a-trier)

<!-- /TOC -->

## Contexte


Projet GitHub : [https://github.com/ansible/ansible](https://github.com/ansible/ansible)
Documentation de la dernière versino : [http://docs.ansible.com/ansible/latest/](http://docs.ansible.com/ansible/latest/)

## Installation

Conseillé : installer la dernière version avec pip
```bash
sudo apt install python-yaml python-dnspython
sudo -H pip install --upgrade pip
sudo -H pip install markupsafe
sudo -H pip install Jinja2==2.8.1
sudo -H pip install ansible==2.7.5
sudo -H pip install dnspython
sudo -H pip install netaddr
sudo chmod 755 /usr/local/bin/ansible*
echo "[defaults]
hash_behaviour=merge
allow_world_readable_tmpfiles=true
ansible_python_interpreter=auto
" > ~/.ansible.cfg
```


## Packet debian
```bash
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" > /etc/apt/sources.list.d/ansible.list

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
apt-get update
apt-get install ansible
```

## Paquet Ubuntu
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
ansible --version
ansible 2.4.1.0
```

### Via docker


Check des images Ansible

```bash
docker search ansible
```

Téléchargement de l'image

```bash
docker pull williamyeh/ansible:debian8
```

Lancer et installer

```bash
docker run -it williamyeh/ansible:debian8 /bin/bash
```

Tester l'install
```bash
ansible all -i 'localhost,' -u vagrant -c local -m ping
```

Connection ssh :

Création d'une clef RSA
```bash
ssh-keygen -b 2048 -t rsa
```
Ne spéchifier pas le fichier de sortie. Par défautle fichier est .ssh/id_rsa.

Entrez ub mot de passe pour protéger la clef.


### Acces ssh

Lancer le ssh-agent
```bash
ssh-agent /bin/bash
ssh-add
```

Copier la clef public sur les autre serveur
```bash
ssh-copy-id user@vm1.exemple.com
```

Copie les clef aussi sur le user root


## Configuration

```bash
vim /etc/ansible/hosts
```

Ajouter les host dans des groups avec un méthode suivante

```txt
# === Personnal ===
[bigdata]
## Ip
192.168.5.0
## url
vm1.exemple.com
## url:ip
toto.exemple.com:22
## Alias port ip
titi.exemple.com ansible_port=22 ansible_host=192.168.112
tutu ansible_port=22 ansible_host=192.168.112
## Précision du tipe de connection
localhost              ansible_connection=local
other1.example.com     ansible_connection=ssh        ansible_user=mpdehaan
## Variable utiliser par la suite
host1 http_port=80 maxRequestsPerChild=808

## Autre facon d'utiliser les variable
[atlanta]
host1
host2

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com

## Group de groups avec (:children et :vars)
[atlanta]
host1
host2

[raleigh]
host2
host3

[southeast:children]
atlanta
raleigh

[southeast:vars]
some_server=foo.southeast.example.com
halon_system_timeout=30
self_destruct_countdown=60
escape_pods=2
```

Les variable de group et de host peuvent etre dans des fichier séparé ('.yml', '.yaml', or '.json'):
- /etc/ansible/group_vars/my_group
- /etc/ansible/host_vars/my_vars


```bash
vim /etc/ansible/ansible.cfg
```

## Utilisation

| Commande | Description |
|--------- |------------ |
|```ansible all -m ping``` | Vérifie l'accès |
|```ansible all -m ping -u user``` | Vérifie l'accès d'un utilisateur |
|```ansible all -m ping -u user -b ``` | Vérifie l'accès sudo root|
|```ansible all -m ping -u user -b --become toto``` | Comme sudo su -l toto|
|```ansible all -m ping -u user -b --become-user toto``` | Comme su -l too |
|```ansible all -a "/bin/echo hello" -u user --become-user root --ask-become-pass``` | Comme su -l too avec demande de mot de passe |
| | |
|```ansible all -a "/bin/echo hello"``` | Command à sur les serveurs |
|```ansible all -a "/bin/echo hello" -f 10```  | Utilise 10 process (5 par defaut) |
| | |
| ```ansible fron01.exemple.com -m shell -a 'echo $TERM'``` |  Par défaut, on utilise le module shell|
| ``` =ansible atlanta -m copy -a "src=/etc/hosts dest=/tmp/hosts"``` | module de copy |
| ```ansible webservers -m file -a "dest=/srv/foo/b.txt mode=600 owner=mdehaan group=mdehaan"``` | module changent les droits de fichier |
| ```ansible webservers -m file -a "dest=/path/to/c mode=755 owner=mdehaan group=mdehaan state=directory"``` | Idem avec création de dossier |
| ```ansible webservers -m file -a "dest=/path/to/c state=absent"``` | Idem avec suppression en cascade |
| | |
| ```ansible webservers -m yum -a "name=acme state=present"``` | Vérifie qu'il est present |
| ```ansible all -m user -a "name=foo password=<crypted password here>"``` | création user |
| ```ansible all -m user -a "name=foo state=absent"``` | Suppression user |
| ```ansible webservers -m git -a "repo=git://foo.example.org/repo.git dest=/srv/myapp version=HEAD"``` | deploy git |
| ```ansible webservers -m service -a "name=httpd state=started"``` | managing service |
| | |
| ```ansible all -B 3600 -P 0 -a "/usr/bin/long_running_operation --do-stuff"``` | timeout sans pooling |
| ```ansible all -B 3600 -P 0 -a "/usr/bin/long_running_operation --do-stuff"``` | timeout check status all 60s |
| ```ansible web1.example.com -m async_status -a "jid=488359678239.2844"``` | Check status asynchrone|
| | |
| ```ansible all -m setup``` | Get des infos du system |


Remarque :
- ```-m``` pour les module, et ```-a``` pour les commandes


## Playbook

Créer un playbook

Exemple de playbook :

```bash
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum: name=httpd state=latest
  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running (and enable it at boot)
    service: name=httpd state=started enabled=yes
  handlers:
    - name: restart apache
      service: name=httpd state=restarted
```


Lancer un Playbook
```bash
ansible-playbook playbook.yml -f 10
```
Vous povez utilise ```--syntax-check``` pour avoir une vérification additionnel de la syntax et utiliser ```--verbose``` pour débuger.

## Versionning de l'architecture Ansible

```bash
ansible-pull --help
```



## Monitoring

| Commande | Description |
|--------- |------------ |
| ```ansible all --list-hosts``` |  |


## Semaphore

Semaphore est une interface graphique opensource concurrente Ansible Toweer (payant)
