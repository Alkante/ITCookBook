# Xen Orchestra

https://xen-orchestra.exemple.com/

## Nodejs
```
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get install -y nodejs
node -v
```
## Yarn
```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt-get update && sudo apt-get install yarn
```

## XOA
```
apt-get install build-essential redis-server libpng-dev git python-minimal
mkdir /home/www
cd /home/www
git clone -b master http://github.com/vatesfr/xen-orchestra
cd xen-orchestra
yarn
yarn build
cd packages/xo-server
cp sample.config.yaml .xo-server.yaml
vim .xo-server.yaml
```
```
# BE *VERY* CAREFUL WHEN EDITING!
# YAML FILES ARE SUPER SUPER SENSITIVE TO MISTAKES IN WHITESPACE OR ALIGNMENT!
# visit http://www.yamllint.com/ to validate this file as needed

#=====================================================================

# Example XO-Server configuration.
#
# This file is automatically looking for at the following places:
# - `$HOME/.config/xo-server/config.yaml`
# - `/etc/xo-server/config.yaml`
#
# The first entries have priority.
#
# Note: paths are relative to the configuration file.

#=====================================================================

# It may be necessary to run XO-Server as a privileged user (e.g.
# `root`) for instance to allow the HTTP server to listen on a
# [privileged ports](http://www.w3.org/Daemon/User/Installation/PrivilegedPorts.html).
#
# To avoid security issues, XO-Server can drop its privileges by
# changing the user and the group is running with.
#
# Note: XO-Server will change them just after reading the
# configuration.

# User to run XO-Server as.
#
# Note: The user can be specified using either its name or its numeric
# identifier.
#
# Default: undefined
#user: 'nobody'
user: 'www-data'

# Group to run XO-Server as.
#
# Note: The group can be specified using either its name or its
# numeric identifier.
#
# Default: undefined
#group: 'nogroup'
group: 'www-data'

#=====================================================================

# Configuration of the embedded HTTP server.
http:

  # Hosts & ports on which to listen.
  #
  # By default, the server listens on [::]:80.
  listen:
    # Basic HTTP.
    -
      # Address on which the server is listening on.
      #
      # Sets it to 'localhost' for IP to listen only on the local host.
      #
      # Default: all IPv6 addresses if available, otherwise all IPv4
      # addresses.
      #hostname: 'localhost'

      # Port on which the server is listening on.
      #
      # Default: undefined
      #port: 80
      port: 8080

      # Instead of `host` and `port` a path to a UNIX socket may be
      # specified (overrides `host` and `port`).
      #
      # Default: undefined
      #socket: './http.sock'

    # Basic HTTPS.
    #
    # You can find the list of possible options there https://nodejs.org/docs/latest/api/tls.html#tls.createServer
    #-
       # The only difference is the presence of the certificate and the
       # key.
       #
       #hostname: '127.0.0.1'
       #port: 8443
       # File containing the certificate (PEM format).

       # If a chain of certificates authorities is needed, you may bundle
       # them directly in the certificate.
       #
       # Note: the order of certificates does matter, your certificate
       # should come first followed by the certificate of the above
       # certificate authority up to the root.
       #
       # Default: undefined
       #cert: '/home/www/xen-orchestra.exemple.com/ssl-cert/ssl.crt/wildcard.exemple.com.chain.crt.latest'

       # File containing the private key (PEM format).
       #
       # If the key is encrypted, the passphrase will be asked at
       # server startup.
       #
       # Default: undefined
       #key: '/home/www/xen-orchestra.exemple.com/ssl-cert/ssl.key/wildcard.exemple.com.chain.key.latest'

  # If set to true, all HTTP traffic will be redirected to the first
  # HTTPs configuration.
  #redirectToHttps: true

  # List of files/directories which will be served.
  mounts:
    '/': '../xo-web/dist'
    #'/': '/path/to/xo-web/dist/'

  # List of proxied URLs (HTTP & WebSockets).
  proxies:
    # '/any/url': 'http://localhost:54722'

# HTTP proxy configuration used by xo-server to fetch resources on the
# Internet.
#
# See: https://github.com/TooTallNate/node-proxy-agent#maps-proxy-protocols-to-httpagent-implementations
#httpProxy: 'http://jsmith:qwerty@proxy.lan:3128'

#=====================================================================

# Connection to the Redis server.
redis:
    # Unix sockets can be used
    #
    # Default: undefined
    #socket: /var/run/redis/redis.sock

    # Syntax: redis://[db[:password]@]hostname[:port][/db-number]
    #
    # Default: redis://localhost:6379/0
    #uri: redis://redis.company.lan/42

    # List of aliased commands.
    #
    # See http://redis.io/topics/security#disabling-of-specific-commands
    #renameCommands:
    #  del: '3dda29ad-3015-44f9-b13b-fa570de92489'
    #  srem: '3fd758c9-5610-4e9d-a058-dbf4cb6d8bf0'


# Directory containing the database of XO.
# Currently used for logs.
#
# Default: '/var/lib/xo-server/data'
#datadir: '/var/lib/xo-server/data'
```

```
cd packages/xo-server
yarn start

cat > /etc/systemd/system/xo-server.service <<EOF
# systemd service for XO-Server.
[Unit]
Description= XO Server
After=network-online.target
[Service]
WorkingDirectory=/home/www/xen-orchestra.exemple.com/packages/xo-server
ExecStart=/usr/bin/node ./bin/xo-server
Restart=always
SyslogIdentifier=xo-server
[Install]
WantedBy=multi-user.targe
EOF

sudo chmod +x /etc/systemd/system/xo-server.service
sudo systemctl enable xo-server.service
sudo systemctl start xo-server.service

```

## Ldap

```
ln -s /home/www/xen-orchestra.exemple.com/packages/xo-server-auth-ldap /usr/local/lib/node_modules/
cd /usr/local/lib/node_modules/xo-server-auth-ldap
yarn

```
