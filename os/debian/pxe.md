# PXE
<!-- TOC -->

- [PXE](#pxe)
    - [Installalation](#installalation)
        - [BOOPT option 1](#boopt-option-1)
        - [BOOPT in isc-dhcp-server](#boopt-in-isc-dhcp-server)
        - [TFTP](#tftp)
            - [Installation](#installation)
            - [Configuration](#configuration)

<!-- /TOC -->

## Installalation
- BOOPT
- TFTP

### BOOPT option 1

### BOOPT in isc-dhcp-server
```bash
vim /etc/dhcp/dhcpd.conf
```
Ajouter
```conf
allow booting;
allow bootp;


subnet 192.168.100.0 netmask 255.255.255.192 {
        range 192.168.100.30 192.168.100.50;
        option domain-name "exemple.lan";
        option domain-name-servers 192.168.100.61;
        option routers 192.168.100.62;
        default-lease-time 600;
        max-lease-time 7200;
        server-name "PXE";
        next-server 192.168.100.61;
        filename "pxe/pxelinux.0";
}
```

### TFTP

#### Installation

```bash
apt-get update
apt-get install TFTP
mkdie /var/tftp
```
#### Configuration

```bash
vim /etc/default/tftpd-hpa
```

```text
 TFTP_USERNAME="tftp"
  TFTP_DIRECTORY="/var/tftp"
  TFTP_ADDRESS="0.0.0.0:69"
  TFTP_OPTIONS="--secure"
```

Redémarer le service
```bash
systemctl restart tftpd-hpa
tail -f /var/log/syslog
```
