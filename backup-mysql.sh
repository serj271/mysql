#! /bin/bash

# backup-mysql.sh
#
# Craig Sanders <cas@taz.net.au>
# this script is in the public domain.  do whatever you want with it.

MYUSER="USERNAME"
MYPWD="PASSWD"

ARGS="--single-transaction --flush-logs --complete-insert"

DATABASES=$( mysql -D mysql --skip-column-names -B -e 'show databases;' | egrep -v 'information_schema' );


BACKUPDIR=/var/backups/mysql

YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DAY=$(date +"%d")

DATE="$YEAR-$MONTH/$YEAR-$MONTH-$DAY"

mkdir -p $BACKUPDIR/$DATE
cd $BACKUPDIR/$DATE

for i in $DATABASES ; do
  echo -n "backing up $i: schema..."
  mysqldump $ARGS --no-data -u$MYUSER -p$MYPWD $i > $i.schema.sql

  echo -n "data..."
  mysqldump $ARGS --skip-opt --no-create-db --no-create-info -u$MYUSER -p$MYPWD $i > $i.data.sql

  echo -n "compressing..."
  gzip -9fq $i.schema.sql $i.data.sql
  echo "done."
done

# delete backup files older than 30 days
OLD=$(find $BACKUPDIR -type d -mtime +30)
if [ -n "$OLD" ] ; then
        echo deleting old backup files: $OLD
        echo $OLD | xargs rm -rfv
fi