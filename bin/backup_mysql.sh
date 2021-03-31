#
# export EDITOR=vim; crontab -e
#
# 0 23 * * * /home/fog/bin/backup_mysql.sh
#
#!/bin/sh

backupDir=/home/fog/private/data/doc/wiki/mediawiki-1.16.5
logFile=${backupDir}/timerecord
sqlDBs="wikidb"

# delete files 1 days ago
find ${backupDir}/*.sql -type f -mtime +1 -exec rm {} \;

:> ${logFile}
echo "[`/bin/date`] start backuping" >> ${logFile}

date=`date +%F`
for db in ${sqlDBs}; do
    mysqldump -u root -p123456 --opt $db > ${backupDir}/${db}-${date}.sql
#    mysqldump -u root -p123456 --databases $db > ${backupDir}/${db}-${date}.sql
done

echo "[`/bin/date`] finish backuping" >> ${logFile}

# backup mediawiki files
cd /var/lib/mediawiki
tar -zcf ${backupDir}/mediawiki-1.16.5_files.tar.gz images/ skins/ extensions/ LocalSettings.php

