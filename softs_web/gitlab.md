# Gitlab community
## Install
```
apt-get install curl openssh-server ca-certificates postfix
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
apt-get install gitlab-ce
```

## Configure and start
```
gitlab-ctl reconfigure
```

Editer le fichier : /etc/gitlab/gitlab.rb

## Authentification
### Configure ldap
Editer le fichier /etc/gitlab/gitlab.rb

```
gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS' # remember to close this block with 'EOS' below
   main: # 'main' is the GitLab 'provider ID' of this LDAP server
     label: 'LDAP'
     host: '192.168.0.3'
     port: 389
     uid: 'uid'
     method: 'plain' # "tls" or "ssl" or "plain"
     bind_dn: 'o=applications,dc=exemple,dc=com'
     password: 'gitlab'
     active_directory: false
     allow_username_or_email_login: false
     block_auto_created_users: false
     base: 'ou=utilisateurs,dc=exemple,dc=com'
 EOS
```

Test :
```
root@debian:/# gitlab-ctl reconfigure
...
root@debian:/# gitlab-rake gitlab:ldap:check
Checking LDAP ...

LDAP users with access to your GitLab server (only showing the first 100 results)
Server: ldapmain
	DN: cn=ttata,ou=utilisateurs,dc=exemple,dc=com	 uid: ttata
	DN: cn=pnom,ou=utilisateurs,dc=exemple,dc=com	 uid: pnom

Checking LDAP ... Finished

```


### Configure cas
#### Configuration gitlab (/etc/gitlab/gitlab.rb)
```
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = true
gitlab_rails['omniauth_block_auto_created_users'] = false

gitlab_rails['omniauth_providers'] = [
    {
        "name"=> "cas3",
        "label"=> "cas",
        "args"=> {
            "url"=> 'https://cas.exemple.com:8443',
            "login_url"=> '/cas427/login',
            "service_validate_url"=> '/cas427/p3/serviceValidate',
            "logout_url"=> '/cas427/logout'
        }
    }
  ]
```
et ajouté le certificat du cas dans /etc/gitlab/trusted-certs/
```
gitlab-ctl reconfigure
```

#### Ajout real IP (Si X-Forwarded-For)

```bash
echo "set_real_ip_from  192.168.223.2;
real_ip_header    X-Forwarded-For;
" > /etc/nginx/conf.d/real_ip.conf
gitlab-ctl restart nginx
```

#### Configuration cas (/var/lib/tomcat7/webapps/cas427/WEB-INF/classes/services/gitlab.json)
```
{
	"@class" : "org.jasig.cas.services.RegexRegisteredService",
	"serviceId" : "http://gitlab.exemple.com/.+",
	"name" : "gitlab",
	"id" : 21647269233030,
	"description" : "gitlab auth",
}
````
# API
## auth
### auth token
générer un token ici: http://gitlab.exemple.com/profile/personal_access_tokens

et utiliser le token dans le header curl:

curl --header "Private-Token: XXXXXXXXXX" http://gitlab.exemple.com/api/v3/projects

## projects:
list
```
curl --header "Private-Token: XXXXXXXXXX" http://gitlab.exemple.com/api/v3/projects
```

## users
list
```
curl --header "Private-Token: XXXXXXXXXX" http://gitlab.exemple.com/api/v3/users
```

## ssh keys
list
```
curl --header "Private-Token: XXXXXXXXXX" http://gitlab.exemple.com/api/v3/projects
```
http://gitlab.exemple.com/profile/personal_access_tokens
```
for d in `seq 1 100`; do ((a++)); echo $a ; curl --header "Private-Token: XXXXXXXXXX" http://gitlab.exemple.com/api/v3/users/$a/keys  | grep -C 5 pcname ;done
```

# Upgrade
ne pas éteindre les services :

update : https://about.gitlab.com/update/#debian
- recommandation : https://docs.gitlab.com/ee/policy/maintenance.html#upgrade-recommendations
- version : https://docs.gitlab.com/omnibus/update/README.html
- v10 : https://docs.gitlab.com/omnibus/update/gitlab_10_changes.html
- v11 : https://docs.gitlab.com/omnibus/update/gitlab_11_changes.html
