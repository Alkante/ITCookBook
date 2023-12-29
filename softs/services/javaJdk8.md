# Install Java JDK
## Téléchargement
Lien : http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

32-bit
```
tar -xvf jdk-8-linux-i586.tar.gz
```
64-bit
```
tar -xvf jdk-8-linux-x64.tar.gz
```


## Installation
```
mkdir -p /usr/lib/jvm
mv ./jdk1.8.0 /usr/lib/jvm/

update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0/bin/java" 1
update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0/bin/javac" 1
update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/jdk1.8.0/bin/javaws" 1

chmod a+x /usr/bin/java
chmod a+x /usr/bin/javac
chmod a+x /usr/bin/javaws
chown -R root:root /usr/lib/jvm/jdk1.8.0

update-alternatives --config java
```

Choisier votre jdk :
```
Selection    Path                                            Priority   Status
------------------------------------------------------------
0            /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java   1071      auto mode
1            /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java   1071      manual mode
* 2            /usr/lib/jvm/jdk1.7.0/bin/java                   1         manual mode
3            /usr/lib/jvm/jdk1.8.0/bin/java                   1         manual mode

```
```
update-alternatives --config javac
update-alternatives --config javaws
```
