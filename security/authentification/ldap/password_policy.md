# password policy
## Activer schema ppolicy
```bash
ldapmodify -x -a -h 127.0.0.1 -D "cn=admin,dc=exemple,dc=com" -w XXXXXX -f /etc/ldap/schema/ppolicy.ldif
```
Il faut les droits suffisants pour faire ça (ldap_add insufficient access (50))
sinon:
```bash
ldapadd -Q -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/ppolicy.ldif
```
## Load module
```bash
echo 'dn: cn=module{0},cn=config
changeType: modify
add: olcModuleLoad
olcModuleLoad: ppolicy' > ppolicy-module.ldif
ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f ppolicy-module.ldif
```
Vérification:
```bash
ldapsearch -Q -Y EXTERNAL -H ldapi:/// -b cn=config "(objectClass=olcModuleList)" olcModuleLoad -LLL
dn: cn=module{0},cn=config
olcModuleLoad: {0}back_mdb
olcModuleLoad: {1}ppolicy
```
## Configure module overlay
```bash
echo 'dn: olcOverlay=ppolicy,olcDatabase={1}mdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcPPolicyConfig
olcOverlay: ppolicy
olcPPolicyDefault: cn=passwordDefault,ou=Policies,dc=exemple,dc=com
olcPPolicyHashCleartext: TRUE
olcPPolicyUseLockout: FALSE' > ppolicy-conf.ldif
ldapadd -Q -Y EXTERNAL -H ldapi:/// -f ppolicy-conf.ldif
```
Vérification:
```bash
ldapsearch -Q -Y EXTERNAL -H ldapi:///  -b cn=config "(objectClass=olcPpolicyConfig)" -LLL
dn: olcOverlay={0}ppolicy,olcDatabase={1}mdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcPPolicyConfig
olcOverlay: {0}ppolicy
olcPPolicyDefault: cn=passwordDefault,ou=Policies,dc=exemple,dc=com
olcPPolicyHashCleartext: TRUE
olcPPolicyUseLockout: FALSE
```

## Module config

```bash
echo 'dn: ou=Policies,dc=exemple,dc=com
objectClass: organizationalUnit
objectClass: top
ou: Policies

dn: cn=passwordDefault,ou=Policies,dc=exemple,dc=com
cn: passwordDefault
objectClass: pwdPolicy
objectClass: person
objectClass: top
pwdAllowUserChange: TRUE
pwdAttribute: userPassword
pwdCheckQuality: 1
pwdExpireWarning: 600
pwdFailureCountInterval: 30
pwdGraceAuthNLimit: 5
pwdInHistory: 5
pwdLockout: TRUE
pwdLockoutDuration: 0
pwdMaxAge: 0
pwdMaxFailure: 5
pwdMinAge: 0
pwdMinLength: 5
pwdMustChange: FALSE
pwdSafeModify: FALSE
sn: dummy value' > ppolicy-defaut2.ldif
ldapadd -x -h 127.0.0.1 -D "cn=admin,dc=exemple,dc=com" -w XXXXXX -f ppolicy-defaut2.ldif

```
