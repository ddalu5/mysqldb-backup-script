#!/bin/bash

# Put your user and password
MYDB_ACCOUNT='mysql_account'
MYDB_PASSWORD='mysql_password'
ADMIN_EMAIL='put your email here'

TMP_FOLDER='/tmp/mysqldb_backup/'

BASEDIR="$( cd "$( dirname "$0" )" && pwd )"
YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(date +"%d")
DB_NAME="$1"
BACKUP_FILENAME=$DB_NAME"_"$YEAR"_"$MONTH"_"$DAY""

# Remove this line of code, it's needed only in dev
. "$BASEDIR/"dev.sh

echo "[+] Creating TMP folder: $TMP_FOLDER"
mkdir -p $TMP_FOLDER

if [ $? -eq 0 ]; then
    echo "[+] TMP folder: $TMP_FOLDER has been created"
    echo "[+] Dumping the database \"$DB_NAME\" in $TMP_FOLDER$BACKUP_FILENAME.sql"
    mysqldump -u $MYDB_ACCOUNT --password=$MYDB_PASSWORD $DB_NAME > $TMP_FOLDER$BACKUP_FILENAME".sql"
    if [ $? -eq 0 ]; then
        echo "[+] Database dumped"
        echo "[+] Archiving database dump"
        gzip -c $TMP_FOLDER$BACKUP_FILENAME".sql" > $TMP_FOLDER$BACKUP_FILENAME".sql.gz"
        if [ $? -eq 0 ]; then
            echo "[+] Archive complete"
            echo "[+] Sending email"
            mail --attach=$TMP_FOLDER$BACKUP_FILENAME".sql.gz" -s "Database $DB_NAME backup $YEAR-$MONTH-$DAY" $ADMIN_EMAIL < /dev/null
            if [ $? -eq 0 ]; then
                echo "[+] Email succesfully sent to $ADMIN_EMAIL"
            else
                echo "[!] Error: couldn't send the email to $ADMIN_EMAIL"
            fi
        else
            echo "[!] Error: couldn't archivate the file $TMP_FOLDER$BACKUP_FILENAME.sql"
        fi
    else
        echo "[!] Error: couldn't dump database \"$DB_NAME\" in $TMP_FOLDER$BACKUP_FILENAME.sql"
    fi
else
    echo "[!] Error when creating temporary folder: $TMP_FOLDER"
fi
