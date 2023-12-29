# MapServer Suite

 - MapServeur Core
 - MapCache
 - TinyOWS

## Links
**MapServer**
Repo code: https://github.com/mapserver/mapserver
Documentation: https://www.mapserver.org/
Docker mapserver reprenant le dépot officiel: https://github.com/msmitherdc/mapserver-docker

**MapCache**
Repo source: https://github.com/mapserver/mapcache
Documentation: https://mapserver.org/mapcache/

**Group MapServer**
On github: https://github.com/mapserver

## MapServer

### install

doc: https://mapserver.org/fr/installation/unix.html

download page: https://mapserver.org/fr/download.html#download

Dependencies:
 - libproj: libproj provides projection support for MapServer. Version 4.4.6 or greater is required.
 - libcurl: libcurl is the foundation of OGC (WFS/WMS/WCS) client and server support. Version 7.10 or greater is required.
 - OGR: OGR provides access to a lot of vector formats.
 - GDAL: GDAL provides access to a lot of raster formats.


## Install manuel MapServer

## MapServer Required External Libraries
```bash
apt install libpng-dev freetype2-demos libjpeg-dev zlib1g-dev
```

## MapServer Highly Recommended Libraries
```bash
apt install libproj-dev
```


libcurl: libcurl is the foundation of OGC (WFS/WMS/WCS) client and server support. Version 7.10 or greater is required.

OGR: OGR provides access to a lot of vector formats.

GDAL: GDAL provides access to a lot of raster formats.

## Install manuel MapCahce

Connection en tant que root
```bash
wget http://download.osgeo.org/mapserver/mapserver-7.4.1.tar.gz
```

sudo apt-get install
sudo a2dismod mpm_event
sudo a2enmod mpm_prefork
sudo service apache2 restart

sudo a2enmod mpm_prefork




### MapCache build dependencies
```bash
apt install apache2 libpng-dev  libjpeg62-dev libcurl4-gnutls-dev
```

### MapCache build recomended dependencies
```bash
apt install libpcre3-dev libpixman-1-dev
```

### MapCache build additionnal dependencies
```bash
apt install libfcgi-dev libgdal-dev libgeos-dev libsqlite3-dev libtiff5-dev libdb4-dev
```




# Install mapcache compilation prerequisites
```bash
apt-get install -y software-properties-common g++ make cmake wget git bzip2 apache2 apache2-dev curl
apt-get install -y \
    libxml2-dev \
    libxslt1-dev \
    libproj-dev \
    libfribidi-dev \
    libcairo2-dev \
    librsvg2-dev \
    libmysqlclient-dev \
    libpq-dev \
    libcurl4-gnutls-dev \
    libexempi-dev \
    libgdal-dev \
    libgeos-dev \
    gdal-bin
```

```bash
VERSION=harfbuzz-0.9.19.tar.bz2
if [ ! -f /tmp/resources/harfbuzz-0.9.19.tar.bz2 ]; then \
    wget http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.19.tar.bz2 -P /tmp/resources/; \
    fi; \
    cd /tmp/resources &&\
    tar xjf harfbuzz-0.9.19.tar.bz2  &&\
    cd harfbuzz-0.9.19 && \
    ./configure  && \
    make  && \
    make install  && \
    ldconfig

if [  ! -d /tmp/resources/mapserver ]; then \
    git clone https://github.com/mapserver/mapserver /tmp/resources/mapserver; \
    fi;\
    mkdir -p /tmp/resources/mapserver/build && \
    cd /tmp/resources/mapserver/build && \
    cmake /tmp/resources/mapserver/ -DWITH_THREAD_SAFETY=1 \
        -DWITH_PROJ=1 \
        -DWITH_KML=1 \
        -DWITH_SOS=1 \
        -DWITH_WMS=1 \
        -DWITH_FRIBIDI=1 \
        -DWITH_HARFBUZZ=1 \
        -DWITH_ICONV=1 \
        -DWITH_CAIRO=1 \
        -DWITH_RSVG=1 \
        -DWITH_MYSQL=1 \
        -DWITH_GEOS=1 \
        -DWITH_POSTGIS=1 \
        -DWITH_GDAL=1 \
        -DWITH_OGR=1 \
        -DWITH_CURL=1 \
        -DWITH_CLIENT_WMS=1 \
        -DWITH_CLIENT_WFS=1 \
        -DWITH_WFS=1 \
        -DWITH_WCS=1 \
        -DWITH_LIBXML2=1 \
        -DWITH_GIF=1 \
        -DWITH_EXEMPI=1 \
        -DWITH_XMLMAPFILE=1 \
        -DWITH_PROTOBUFC=0 \
        -DWITH_FCGI=0 && \
    make && \
    make install && \
    ldconfig

echo "ServerName localhost" >> /etc/apache2/apache2.conf
echo '<?php phpinfo();' > /var/www/html/info.php
```

## mapserver form repo
```bash
sudo apt-get install apache2 apache2-bin apache2-utils cgi-mapserver mapserver-bin mapserver-doc libmapscript-perl python-mapscript ruby-mapscript
sudo apt install libapache2-mod-fcgid
sudo a2enmod cgi fcgid
```

```bash
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get install cgi-mapserver
```

```bash
ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
<Directory "/usr/lib/cgi-bin/">
  AllowOverride All
  Options +ExecCGI -MultiViews +FollowSymLinks
  AddHandler fcgid-script .fcgi
  Require all granted
</Directory>
```



## HarfBuzz

Install HarfBuzz from source.
Check the lastest version here. This example grubs harfbuzz-1.7.6:

```bash
cd ~/src
wget https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.7.6.tar.bz2
tar xjf harfbuzz-1.7.6.tar.bz2
rm harfbuzz-1.7.6.tar.bz2
cd harfbuzz-1.7.6
./configure && make && sudo make install
sudo ldconfig && cd ~/
```


















### WIll
#mapserver7
##########################################
apt install php php-dev

apt-get install protobuf-compiler

------
apt install libpng-dev freetype2-demos libjpeg-dev zlib1g-dev

apt-get install build-essential cmake


--   * png:
--   * jpeg: JPEG_LIBRARY-NOTFOUND
--   * freetype: FREETYPE_LIBRARY-NOTFOUND



cd /tmp
wget http://download.osgeo.org/mapserver/mapserver-7.4.2.tar.gz
tar -xzf mapserver-7.4.2.tar.gz
mv mapserver-7.4.2
cd mapserver-7.4.2
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_PREFIX_PATH="/usr" \
  -DWITH_CAIRO=ON \
  -DUSE_CAIRO=ON \
  -DWITH_FRIBIDI=OFF \
  -DWITH_FCGI=OFF \
  -DWITH_PROJ=ON \
  -DWITH_GEOS=ON \
  -DWITH_POSTGIS=ON \
  -DWITH_GDAL=ON \
  -DWITH_OGR=ON \
  -DWITH_CURL=ON \
  -DWITH_CLIENT_WFS=ON \
  -DWITH_CLIENT_WMS=ON \
  -DWITH_WFS=ON \
  -DWITH_WCS=ON \
  -DWITH_HARFBUZZ=0 \
  -DPHP5_EXTENSION_DIR="/usr/lib64/php/modules/" \
  -DWITH_PHP=ON \
  -DWITH_PROTOBUFC=0 \
  ..

make
make install
mkdir /usr/lib/cgi-bin/
cp /usr/local/bin/mapserv /usr/lib/cgi-bin/mapserv
chmod 755 /usr/lib/cgi-bin/mapserv
echo "extension=php_mapscript.so" > /etc/php.d/mapscript.ini
ldd /usr/lib64/php/modules/php_mapscript.so 1> /dev/null

cd /usr/lib/cgi-bin
mkdir diagnostic-wfs diagnostic-wms quartiers-wfs quartiers-wms wfs wms
for dir in diagnostic-wfs diagnostic-wms quartiers-wfs quartiers-wms wfs wms; do mkdir $dir; cd $dir; ln -s ../mapserv ; cd ..; done


/usr/lib/cgi-bin/mapserv -v    
MapServer version 7.0.5 OUTPUT=PNG OUTPUT=JPEG SUPPORTS=PROJ SUPPORTS=AGG SUPPORTS=FREETYPE SUPPORTS=CAIRO SUPPORTS=ICONV SUPPORTS=WMS_SERVER SUPPORTS=WMS_CLIENT SUPPORTS=WFS_SERVER SUPPORTS=WFS_CLIENT SUPPORTS=WCS_SERVER SUPPORTS=GEOS INPUT=JPEG INPUT=POSTGIS INPUT=OGR INPUT=GDAL INPUT=SHAPEFILE



















How can I run a MapServer (7.4) localy using docker ? Even if i succed building an image with MapServer compiled and installed, I still don't understand how to link the mapserv program with the web interface.

Here is my Dockerfile :

``` docker
RUN apt-get update && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libproj-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libcairo-dev \
    libgdal-dev \
    libgpg-error-dev \
    wget \
    unzip \
    cmake \
    make \
    g++ \
    gcc \
    libc-dev \
    libfcgi-dev

RUN cd /tmp/ \
    && mkdir install_mapscript \
    && cd install_mapscript \
    && wget --no-check-certificate https://github.com/mapserver/mapserver/archive/rel-7-4-1.tar.gz \
    && tar -xzf /tmp/install_mapscript/rel-7-4-1.tar.gz \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/opt -DCMAKE_PREFIX_PATH="/usr/local:/opt" -DWITH_PROTOBUFC=0 -DWITH_CLIENT_WFS=ON -DWITH_CLIENT_WMS=ON -DWITH_CURL=ON -DWITH_SOS=ON -DWITH_PYTHON=OFF -DWITH_SVGCAIRO=OFF ../mapserver-rel-7-4-1 >../configure.out.txt \
    && make \
    && make install
```
