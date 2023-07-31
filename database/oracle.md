# ORACLE

<!-- -------------------------  Users et roles ----------------------------------- -->

## Users et roles

### Affichage des users
```SQL
SELECT username FROM dba_users;
SELECT DISTINCT owner FROM dba_objects;
select USERNAME from SYS.ALL_USERS order by USERNAME;
```

### Affichage des roles
```SQL
select grantee, granted_role from dba_role_privs;
```

### Suppression d'un user
```SQL
Drop user user_name cascade;
```


<!-- -------------------------  Tablespace ----------------------------------- -->

## Tablespace

### lister les tablespaces
```SQL
SELECT DISTINCT owner, tablespace_name FROM dba_segments;
```

### Suppression de tablespace et de datafile

```SQL
SELECT file_name, tablespace_name
FROM dba_data_files
WHERE tablespace_name =?<tablespace name>?;

DROP TABLESPACE <tablespace name> INCLUDING CONTENTS AND DATAFILES;
```

### Resize datafile
```SQL
alter database datafile 'D:\ORACLE\ORADATA11\ORA11AST\TBS_DATA_PART23.DBF' resize 100M;
```

### Resize bifile
```SQL
alter tablespace SLMV7_TAB resize 1G;
```

### Charset

```SQL
SQL> select * from nls_database_parameters
where parameter like '%CHARACTERSET';
echo $NLS_LANG
echo %NLS_LANG%
SET NLS_LANG=american_america.WE8ISO8859P15
```

<!-- -------------------------  Monitoring ----------------------------------- -->

## Monitoring

### Forcer la deconnexion d'un user

The ORA-01940 can always be cured by bouncing the source and replicated instance.  First, double-check to ensure that the user is not connected to the current instance.
```SQL
select s.sid, s.serial#, s.status, p.spid
from v$session s, v$process p
where s.username = 'myuser'
and p.addr (+) = s.paddr;

-- alter system kill session '<sid>,<serial#>';
```
Also, check that the user is not associated with any active jobs:
```SQL
select job from dba_jobs where log_user='myuser';
```
