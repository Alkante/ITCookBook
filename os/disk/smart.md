# État des disques avec SMART

`smartctl --scan`

`smartctl -a /dev/sdb`

## État direct des disques qui sont dans des RAID Dell

`ls -l /dev/sg*`

`smartctl -d scsi -a /dev/sgX`
