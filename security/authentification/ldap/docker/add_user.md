# add user

link: 

Objectclass for user: https://tylersguides.com/guides/openldap-how-to-add-a-user/

AttributsClasses http://www-lor.int-evry.fr/~michel/LDAP/TP/AttributsClasses.html


https://www.vincentliefooghe.net/content/ldap-les-types-groupes


links member + refint : https://tylersguides.com/guides/openldap-memberof-overlay


## Commande

We use :
- ```./example/Users.ldif``` to add the group **Users**
- ```./example/user.ldif``` to add the user **myuser**

Generate new password.
```bash
slappasswd -s mypassword
```

Generate new password.


Manual 
```bash
ldapadd -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -f ./example/Users.ldif

ldapadd -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -f ./example/myuser.ldif
```

Automatique with docker-compose
```bash
docker-compose down
mkdir -p ./data/openldap/add_init_ldif/
sudo cp ./example/*.ldif ./data/openldap/add_init_ldif/
sudo chmod 777 -R ./data/openldap/add_init_ldif
docker-compose up -d
```

### Check User

Connect to docker
```bash
docker exec -it openldap /bin/bash
```

Check read access
```bash
# With slapcat
slapcat
# or with admin connection
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "uid=myuser1,ou=Users,dc=example,dc=org" -LLL
# or with self myuser connection
ldapsearch -H ldap://localhost -x -D "uid=myuser1,ou=Users,dc=example,dc=org" -w mypassword -b "uid=myuser1,ou=Users,dc=example,dc=org" -LLL
```

Check forbiden access
```bash
# Will return nothing (because forbiden)
ldapsearch -H ldap://localhost -x -D "uid=myuser1,ou=Users,dc=example,dc=org" -w mypassword -b "ou=Users,dc=example,dc=org" -LLL

# Will return nothing (because forbiden)
ldapsearch -H ldap://localhost -x -D "uid=myuser1,ou=Users,dc=example,dc=org" -w mypassword -b "uid=myuser2,ou=Users,dc=example,dc=org" -LLL
```



## Groups
objectClass: groupOfNames or groupOfUniqueNames
Atribut mandatory:
 - member: <dn>
objectClass: groupOfUniqueNames
Atribut mandatory:
 - uniqueMember

A l'origine, les groupes statiques, définis par les classes d'objet groupOfNames et groupOfUniqueNames sont juste une liste de membres (donnés par leur DN).
### Check Group

Check read access
```bash
# With slapcat
slapcat
# or with admin connection
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "cn=mygroup1,ou=Groups,dc=example,dc=org" -LLL

ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "uid=myuser1,ou=Users,dc=example,dc=org" -LLL dn ismemberof
```

## Dynamique link group with UniqueMember and memberOf


# Show memberOf attribut o a user node

By defautl, memberOf attribut is not explicity show
These commands not show memberOf attribut on user entry:
```bash
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "uid=myuser2,ou=Users,dc=example,dc=org" -LLL
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "ou=Users,dc=example,dc=org" -LLL "uid=myuser2"
```

This command memberOf attribut.
```bash
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "uid=myuser2,ou=Users,dc=example,dc=org" -LLL dn memberOf
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "ou=Users,dc=example,dc=org" -LLL "uid=myuser2" dn memberOf
```


Filter user in function of group with memberOf attribut
```bash
# Filtedr all member of group **all**
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "ou=Users,dc=example,dc=org" -LLL "memberOf=cn=all,ou=Groups,dc=example,dc=org" dn memberOf

# Filter all member of group **power**
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b "ou=Users,dc=example,dc=org" -LLL "memberOf=cn=power,ou=Groups,dc=example,dc=org" dn memberOf
```
