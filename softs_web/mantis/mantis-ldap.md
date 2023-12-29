# Mantis CAS
Passage de mantis avec une auth centralisé

```
apt install php7.0-ldap
```

## Mantis ldap
file : config/config_inc.php
- samba
```
#$g_login_method = MD5;
$g_login_method = LDAP ;
$g_ldap_protocol_version = 3;
$g_ldap_server = 'ldap://ldap.exemple.com:389' ;
$g_ldap_root_dn = 'OU=Utilisateurs,DC=exemple,DC=com' ;
$g_ldap_bind_dn = 'CN=read-only,OU=Utilisateurs,DC=exemple,DC=com' ;
$g_ldap_bind_passwd = YYYYYY ;
$g_ldap_uid_field = cn ;
$g_ldap_realname_field = displayName ;
$g_use_ldap_realname = ON ;
$g_use_ldap_email = ON ;
$g_ldap_starttls = TRUE ;
```


### Mantis patch tls
File : config_defaults_inc.php
```
 	$g_ldap_bind_passwd		= '';

 	/**
+	 * Should the connection use STARTTLS (use ldap:// url for server address)
+	 *
+	 * @global string $g_ldap_starttls
+	 */
+	$g_ldap_starttls		= FALSE;
+
+	/**
 	 * Should we send to the LDAP email address or what MySql tells us
 	 * @global int $g_use_ldap_email
 	 */
```
File : core/constant_inc.php
```
define( 'ERROR_LDAP_UPDATE_FAILED', 1402 );
define( 'ERROR_LDAP_USER_NOT_FOUND', 1403 );
define( 'ERROR_LDAP_EXTENSION_NOT_LOADED', 1404 );
+define( 'ERROR_LDAP_UNABLE_TO_STARTTLS', 1405 );

# ERROR_CATEGORY_*
define( 'ERROR_CATEGORY_DUPLICATE', 1500 );
```
File: core/ldap_api.php
```
     log_event( LOG_LDAP, "Attempting connection to LDAP URI '{$t_ldap_server}'." );
     $t_ds = @ldap_connect( $t_ldap_server );

+	$t_ldap_starttls = config_get( 'ldap_starttls');
+	if ($t_ldap_starttls) {
+		if (! @ldap_start_tls($t_ds)){
+			log_event( LOG_LDAP, "Error: Cannot initiate STARTTLS on LDAP Server" );
+			trigger_error( ERROR_LDAP_UNABLE_TO_STARTTLS, ERROR );
+		}
+	}
 	if ( $t_ds !== false && $t_ds > 0 ) {
 		log_event( LOG_LDAP, "Connection accepted by LDAP server" );
 		$t_protocol_version = config_get( 'ldap_protocol_version' );
```
New user -> droit d'acces rapporteur
