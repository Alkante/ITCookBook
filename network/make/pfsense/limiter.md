# Pfsense : limiter
Depuis le 2.4.0, pfsense utilise freebsd 11 qui inclut fq_codel (ipfw).

Fq_codel permet une bien meilleure utilisation des limiters malheureusement cette fonctionnalité n'est pas encore inclut dans l'interface de pfsense.

Les limiters permettent de faire de la QOS avec un système de poids dans les queues enfants des limiters (voir exemple si-dessous).

Avant modification, vous devez avoir mis en place les limiters dans "Firewall" -> "Traffic Shaper" et onglet "Limiter".

Voici un exemple de limiter pour du 2M symétrique avec une qos sur les traffic :
* Download : débit limiter à 1800kbit/s
 + Download_LOW : poids de 10 (masque /24 avec "destination addresses")
 + Download_HIGH : poids de 90 (masque /24 avec "destination addresses")
* Upload : débit limiter à 1800kbit/s
 + Upload_LOW : poids de 10 (masque /24 avec "source addresses")
 + Upload_HIGH : poids de 90 (masque /24 avec "source addresses")

Et assigner les limiters aux rules (floating avec un match) du firewall, par exemple sur l'interface LAN le "in" correspond au download et le "out" correpsond à l'upload.

Une fois cela vous devez faire les modifications en ssh.

Copier le fichier temporaire /tmp/rules.limiter dans /root, modifier son contenu :
```
pipe 1 config  bw 1800Kb
queue 1 config pipe 1 weight 10 mask dst-ip6 /128 dst-ip 0xffffff00
queue 2 config pipe 1 weight 90 mask dst-ip6 /128 dst-ip 0xffffff00

pipe 2 config  bw 1800Kb
queue 3 config pipe 2 weight 10 mask src-ip6 /128 src-ip 0xffffff00
queue 4 config pipe 2 weight 90 mask src-ip6 /128 src-ip 0xffffff00
```
vers
```
pipe 1 config  bw 1800Kb
sched 1 config pipe 1 type qfq
queue 1 config sched 1 weight 10 mask dst-ip6 /128 dst-ip 0xffffff00 codel
queue 2 config sched 1 weight 90 mask dst-ip6 /128 dst-ip 0xffffff00 codel

pipe 2 config  bw 1800Kb
sched 2 config pipe 2 type qfq
queue 3 config sched 2 weight 10 mask src-ip6 /128 src-ip 0xffffff00 codel
queue 4 config sched 2 weight 90 mask src-ip6 /128 src-ip 0xffffff00 codel

```
Il s'agit de régle "ipfw", vous pouvez aussi les appliquer à la main en ajoutant devant ipfw

Pour utiliser ce fichier vous devez modifier le fichier /etc/inc/shaper.inc
```
...
                file_put_contents("{$g['tmp_path']}/rules.limiter", $dn_rules);
                #mwexec("/sbin/ipfw {$g['tmp_path']}/rules.limiter");
                mwexec("/sbin/ipfw /root/rules.limiter");
...
```

Pour prendre en compte les nouvelles queues :
* Réinitialisation des "pipe" :
```
ipfw pipe flush
```
* Réinitialisation dans l'interface du pfsense : "Status" -> "Filter Reload" et "Reload Filter"

## Monitoring des queues
L'interface de monitoring des queues dans pfsense ne permet l'utilisation du schedule fq_codel, pour cela modifier le fichier : /usr/local/www/diag_limiter_info.php
```
...
    if ($_REQUEST['getactivity']) {
        $text = `/sbin/ipfw pipe show`;
        if ($text == "") {
                $text = gettext("No limiters were found on this system.");
        }
        echo gettext("Limiters:") . "\n";
        echo $text;
        $text = `/sbin/ipfw queue show`;
        if ($text != "") {
                echo "\n\n" . gettext("Queue") . ":\n";
                echo $text;
        }
        exit;
    }
...
...
        events.push(function() {
            setInterval('getlimiteractivity()', 2500);
            getlimiteractivity();
        });
...
```
En
```
...
if ($_REQUEST['getactivity']) {
        $text = `/sbin/ipfw pipe show`;
        if ($text == "") {
                $text = gettext("No limiters were found on this system.");
        }
        echo gettext("Limiters:") . "\n";
        echo $text;
        $text = `/sbin/ipfw sched show`;
        if ($text != "") {
                echo "\n\n" . gettext("Shedulers") . ":\n";
                echo $text;
        }
        $text = `/sbin/ipfw queue show`;
        if ($text != "") {
                echo "\n\n" . gettext("Queue") . ":\n";
                echo $text;
        }
        exit;
}
...
...
        events.push(function() {
            setInterval('getlimiteractivity()', 500);
            getlimiteractivity();
        });
...
```
Le monitoring fonctionne maintenant dans "Diagnostics" -> "Limiter Info"

## Tunning
Apres plusieurs crache du pfsense nous avons désactiver le flow control

Dans /boot/loader.conf.local
* em(4):
```
hw.em.fc_setting=0
```
* igb(4):
```
hw.igb.fc_setting=0
 ```


## Source
Man ipfw : https://www.freebsd.org/cgi/man.cgi?ipfw(8)
Forum : https://forum.pfsense.org/index.php?topic=126637.0
Dummynet AQM : http://caia.swin.edu.au/reports/160226A/CAIA-TR-160226A.pdf
