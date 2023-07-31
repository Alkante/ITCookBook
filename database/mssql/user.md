# login or user?
A Login is an account on the SQL Server as a whole - someone who is able to log in to the server and who has a password.
```
CREATE LOGIN NewAdminName WITH PASSWORD = 'ABCD'
GO
```
A User is a Login with access to a specific database.
Here is how you create a User with db_owner privileges using the Login you just declared:
```
Use YourDatabase;
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'NewAdminName')
BEGIN
    CREATE USER [NewAdminName] FOR LOGIN [NewAdminName]
    EXEC sp_addrolemember N'db_owner', N'NewAdminName'
END;
GO
```

# admin
```
USE [master];
GO
CREATE LOGIN admin
    WITH PASSWORD    = 'XXXXX',
    CHECK_POLICY     = OFF,
    CHECK_EXPIRATION = OFF;
GO
EXEC sp_addsrvrolemember
    @loginame = 'admin',
    @rolename = 'sysadmin';
```
