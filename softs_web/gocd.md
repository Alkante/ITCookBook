# GoCd

## Install serveur
source : https://docs.gocd.org/current/installation/install/server/linux.html


```bash
echo "deb https://download.gocd.org /" | sudo tee /etc/apt/sources.list.d/gocd.list
curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo apt-key add -
sudo apt update
```

```bash
sudo apt-get install go-server
service go-server start
```

url: http://localhost:8153/go


 - Material : git
  