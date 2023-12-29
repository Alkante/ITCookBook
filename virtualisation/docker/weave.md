# Weave
Soft permettant de faire communiquer ensemble des docker situés sur différents hosts sans exposer de port sur un réseau externe

## Installation
Soit les hosts suivants :
- host1
- host2
- host3
- host4

Sur chaque host :
```
sudo curl -L git.io/weave -o /usr/local/bin/weave
sudo chmod a+x /usr/local/bin/weave
cat <<EOF | sudo tee -a /etc/systemd/system/weave.service
[Unit]
Description=Weave Network
Documentation=http://docs.weave.works/weave/latest_release/
Requires=docker.service
After=docker.service
[Service]
EnvironmentFile=-/etc/default/weave
ExecStartPre=/usr/local/bin/weave launch --no-restart $PEERS
ExecStart=/usr/bin/docker attach weave
ExecStop=/usr/local/bin/weave stop
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable weave.service
```

Créer le fichier /etc/default/weave avec les variables nécessaires :
```
PEERS="host1.domaine.tld host2.domaine.tld host3.domaine.tld host4.domaine.tld"
WEAVE_PASSWORD="very secure password "
CHECKPOINT_DISABLE=1
```
Variable CHECKPOINT_DISABLE=1 : disable data collection


## Run and troubleshoot
``` systemctl start weave.service ```

Vérifier les connexions entre les nodes :
```
weave status
weave status peers
```