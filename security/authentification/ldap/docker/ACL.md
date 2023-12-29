# ACL ldap

## Links:

- https://www.vincentliefooghe.net/content/les-acl-dans-openldap
- Openldap official doc: access: https://www.openldap.org/doc/admin24/access-control.html
- Openldap olcAccess modificaiton : https://www.vincentliefooghe.net/content/modifier-les-acl-dun-annuaire-openldap


## Configuration
We add new user "uid=admin_power,dc=example,dc=org" to manage all member of the group "cn=power,ou=Grougs,dc=example,dc=org"

## Doc
**Selector** :

| Selector | Description|
|- |- |
| * | tout le monde |
| anonymous | les utilisateurs non connectés |
| users | les utilisateurs conenctés (via un BIND) |
| self | porte sur l'utilisateur lui-même |
| dn.[specifier] | un DN specifier in {exact, subtree, children)} |
| group.[specifier] | un groupe LDAP {exact, subtree, children)} |

| Access_level |Description |
|- |- |
| (0) none | pas d'accès |
| (d) disclose | permet de savoir si l'entrée ou l'attribut existe |
| (x) auth | requis pour l'authentification |
| (c) compare | comparaison de valeur d'attribut |
| (s) search | recherche sur un attribut |
| (r) read | lecture / affichage d'un attribut |
| (w) write | modification / écriture d'un attribut |



Break et Continue

By default: if the acces correspond to the olcAcces,  other is not elavued


## Example

```
dn: olcDatabase{1}hdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange
        by dn="cn=admin,dc=somesite,dc=com" write
        by dn="uid=anotheruser,ou=Users,dc=somesite,dc=com" write
        by anonymous auth
        by self write
        by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to *
 by self write
 by dn="cn=admin,dc=somesite,dc=com" write
 by dn="cn=anotheruser,ou=Users,dc=somesite,dc=com" write
 by * read
```

### Delete olcAcces
Use this ldif file **olc_delete.ldif**
```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
delete: olcAccess
```
Run it
```bash
ldapmodify -H ldap://localhost -x -D "cn=admin,cn=config" -w config -f ./olc_delete.ldif
```
Check it
```bash
ldapsearch -H ldap://localhost -x -D "cn=admin,cn=config" -w config -b "cn=config" "olcDatabase={1}mdb" -LLL
```

### Add olcAcces

Use this ldif file **olc_add.ldif**
```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange
  by self write
  by dn="cn=admin,dc=example,dc=org" write
  by dn="uid=admin_power,dc=example,dc=org" read
  by anonymous auth
  by * none
olcAccess: {1}to filter="(memberOf=cn=power,ou=Groups,dc=example,dc=org)"
  by self read
  by dn="cn=admin,dc=example,dc=org" write
  by * none
olcAccess: {2}to *
  by self read
  by dn="cn=admin,dc=example,dc=org" write
  by dn="uid=admin_power,dc=example,dc=org" read
  by * none
```


Run it
```bash
ldapadd -H ldap://localhost -x -D "cn=admin,cn=config" -w config -f ./olc_add.ldif
```
Check it
```bash
ldapsearch -H ldap://localhost -x -D "cn=admin,cn=config" -w config -b "cn=config" "olcDatabase={1}mdb" -LLL
```


### Modify olcAccess

The olc_modify.ldif
```ldif
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange
 by self write
 by dn="cn=admin,dc=example,dc=org" write
 by anonymous auth
 by * none
olcAccess: {1}to *
 by self read by dn="cn=admin,dc=example,dc=org" write
 by * none
olcAccess: {2}to attrs=memberOf" filter="(memberOf=cn=power,ou=Groups,dc=example,dc=org)"
 by dn.exact="uid=admin_power,dc=example,dc=org" write
 by anonymous auth
 by * none
```

Run it
```bash
ldapmodify -H ldap://localhost -x -D "cn=admin,cn=config" -w config -f ./olc_modify.ldif
```

Check it
```bash
ldapsearch -H ldap://localhost -x -D "cn=admin,cn=config" -w config -b "cn=config" "olcDatabase={1}mdb" -LLL
```



The olc.ldif
```
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: to attrs=memberOf" filter="(memberOf=cn=power,ou=Groups,dc=example,dc=org)"
  by dn.exact="uid=admin_power,dc=example,dc=org" write
  by anonymous auth
  by * none
```






  dn: olcDatabase={1}hdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange by self write by anonymou
 s auth by dn="cn=admin,dc=nodomain" write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to dn.base="ou=users,dc=nodomain" by users read
olcAccess: {3}to * by self write by dn="cn=admin,dc=nodomain" write by * read
olcAccess: {4}to attrs=userPassword by dn="cn=admin,dc=nodomain" write by
 group/groupOfUniqueNames/uniqueMember="cn=Administrators,ou=groups,dc=nodomain" write


```

Add this config
```bash
ldapadd -H ldap://localhost -x -D "cn=admin,cn=config" -w config -f ./olc.ldif
```






## Test ACL

Avant

```bash
# Self display works
ldapsearch -H ldap://localhost -x -D "uid=myuser2,ou=Users,dc=example,dc=org" -w mypassword -b "uid=myuser2,ou=Users,dc=example,dc=org" -LLL

# Dispaly other user not working
ldapsearch -H ldap://localhost -x -D "uid=myuser2,ou=Users,dc=example,dc=org" -w mypassword -b "uid=myuser3,ou=Users,dc=example,dc=org" -LLL

# Dispaly just you not all user in group
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "ou=Users,dc=example,dc=org" -LLL "memberOf=cn=power,ou=Groups,dc=example,dc=org" dn memberOf
```


Add user admin_power

```bash
ldapsearch -H ldap://localhost -x -D "uid=admin_power,dc=example,dc=org" -w mypassword -b "uid=admin_power,dc=example,dc=org" -LLL

ldapsearch -H ldap://localhost -x -D "uid=admin_power,dc=example,dc=org" -w mypassword -b "ou=Users,dc=example,dc=org" -LLL
```


```bash
ldapsearch -H ldap://localhost -x -D "cn=admin,cn=config" -w config -b "cn=config" "olcDatabase={1}mdb" -LLL
```
Resultat


## TODELETE

```ldif
olcAccess: to dn.subtree="ou=Users,dc=example,dc=org"
 by group.exact="cn=admin,dc=example,dc=com" write
 by users read
 by * none
```

```ldif
olcAccess: {0}to attrs=userPassword,shadowLastChange by self write by dn="cn=a
 dmin,dc=example,dc=org" write by anonymous auth by * none
olcAccess: {1}to * by self read by dn="cn=admin,dc=example,dc=org" write by *
 none
olcAccess: {2}to dn.subtree="ou=Users,dc=example,dc=org" filter="(memberOf=cn=
 power,ou=Groups,dc=example,dc=org)" by self write  by dn.exact="uid=admin_pow
 er,dc=example,dc=org" write by anonymous auth by * none
```
