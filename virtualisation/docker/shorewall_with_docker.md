Docker et shorewall
https://blog.discourse.org/2015/11/shorewalldocker-two-great-tastes-that-taste-great-together/#

# Problème
Both Docker and Shorewall assume that nobody else is actively messing with the firewall configuration.

Shorewall assumes this because it likes to completely blow away the existing firewall configuration, and replace it with a set of rules crafted from your rules files.

Docker inserts NAT rules to implement its port forwarding system, amongst other things.  Both make sense in isolation, but when you combine the two behaviours…

# Solution :
Luckily, Shorewall, being the awesome system that it is, has plenty of hook points (or, as it calls them, extension scripts) you can use to do funky, custom things.

Such as, in this case, saving the existing Docker-related firewall rules before blowing away the firewall, and restoring them afterwards.

Thanks to Docker’s decision to confine most of its rules to a special chain, named DOCKER, this is quite straightforward.

There are three hooks you need to create, all in the same path.
## shorewall >= 5.0.6
http://shorewall.org/Docker.html#idp33083968
Ne fonctionne pas ? shorewall 5.0.15 et docker 17.06.0~ce-0~debian : shorewall vire les règles de docker...
```
sed 's/DOCKER=No/DOCKER=Yes/' /etc/shorewall/shorewall.conf
echo 'dock           docker0          bridge   #Allow ICC (bridge implies routeback=1)' >> /etc/shorewall/interfaces
echo 'dock           $FW         ACCEPT
dock           all         REJECT' >> /etc/shorewall/policy
echo 'dock          ipv4' >> /etc/shorewall/zones
```
Seul moyen trouvé:
### désactiver la gestion de iptables par docker:
```
cat << EOF > /etc/systemd/system/docker.service.d/noiptables.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --iptables=false
EOF
systemctl daemon-reload
service docker restart
```
### Ajouter manuellement le forwarding dans shorewall
Bizarrement le bridge docker0 déclaré dans /etc/shorewall/zones ne fonctionne pas. docker0 est en fait associé à la zone "net"
Dans /etc/shorewall/rules:
Pour un reverse proxy *:80 -> contener:8080
```
ACCEPT $FW:192.168.0.1 net:192.168.0.0/16 tcp 8080
```
Pour que le contener accède au mysql du host:
```
ACCEPT net:192.168.0.0/16        $FW tcp 3306                                                                                                                                                                                                
```

## shorewall <= 5.0.5
### init et stop
```
echo '
if iptables -t nat -L DOCKER >/dev/null 2>&1; then
    echo "*nat" >/etc/shorewall/docker_rules
    iptables -t nat -S DOCKER >>/etc/shorewall/docker_rules
    iptables -t nat -S POSTROUTING >>/etc/shorewall/docker_rules
    echo "COMMIT" >>/etc/shorewall/docker_rules

    echo "*filter" >>/etc/shorewall/docker_rules
    iptables -S DOCKER >> /etc/shorewall/docker_rules
    echo "COMMIT" >>/etc/shorewall/docker_rules
fi
' > /etc/shorewall/init
cp /etc/shorewall/init  /etc/shorewall/stop
```

### start
```
echo '
if [ -f /etc/shorewall/docker_rules ]; then
    iptables-restore -n </etc/shorewall/docker_rules
    run_iptables -t nat -I PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
    run_iptables -t nat -I OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
    run_iptables -I FORWARD -o docker0 -j DOCKER
    run_iptables -I FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    run_iptables -I FORWARD -i docker0 ! -o docker0 -j ACCEPT
    run_iptables -I FORWARD -i docker0 -o docker0 -j ACCEPT

    rm -f /etc/shorewall/docker_rules
fi
' > /etc/shorewall/start
```
