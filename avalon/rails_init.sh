#!/bin/bash

# sendmail needs this to work
#line=$(head -n 1 /etc/hosts)
#line2=$(echo $line | awk '{print $2}')
#echo "$line $line2.localdomain" >> /etc/hosts

cp /etc/hosts /tmp/hosts.new
sed -i '1s/^/127.0.0.1 localhost localhost.localdomain\n/' /tmp/hosts.new
cp -f /tmp/hosts.new /etc/hosts

service sendmail start

# batch ingest cronjob wouldn't autorun without this
touch /var/spool/cron/crontabs/root
touch /var/spool/cron/crontabs/app

chown -R app:1002 /mnt/avalon/masterfiles/
chmod -R 0777 /mnt/avalon/masterfiles/

chown -R app:1002 /mnt/avalon/ingest/
chmod -R 0777 /mnt/avalon/ingest/

chown -R app:1002 /mnt/avalon/dropbox
chmod -R 0777 /mnt/avalon/dropbox

chown -R app:1002 /mnt/avalon/home/app/avalon/tmp
chmod -R 0777 /mnt/avalon/home/app/avalon/tmp

echo "* * * * * /bin/bash -l -c '/mnt/avalon/master_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
echo "* * * * * /bin/bash -l -c '/mnt/avalon/ingest_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
echo "* * * * * /bin/bash -l -c '/mnt/avalon/dropbox_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
echo "* * * * * /bin/bash -l -c '/mnt/avalon/tmp_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root

chmod 600 /var/spool/cron/crontabs/root
service cron reload

cd /home/app/avalon
su -m -c "bundle exec rake db:migrate" app
