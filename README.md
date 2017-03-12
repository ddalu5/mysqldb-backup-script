# mysqldb-backup-script
A simple mysql script to backup a database and send it by email

## How to use
First you need to set your own configuration by changing those variables:

```shell
MYDB_ACCOUNT='mysql_account'
MYDB_PASSWORD='mysql_password'
ADMIN_EMAIL='put your email here'
```

Then you can run the script:

```shell
./mysqldb-backup.sh YOUR_DATABASE_NAME
```
