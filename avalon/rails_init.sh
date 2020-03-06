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
touch /var/spool/cron/crontabs/app

chown -R root:1002 /mnt/avalon_dev/masterfiles/
chmod -R 0777 /mnt/avalon_dev/masterfiles/

chmod -R 0777 /mnt/avalon_dev/new_home/app/avalon/tmp
chown -R root:1002 /mnt/avalon_dev/new_home/app/avalon/tmp

echo "* * * * * /bin/bash -l -c '/mnt/avalon_dev/dropbox_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/root
echo "* * * * * /bin/bash -l -c '/mnt/avalon_dev/ingest_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/root

cd /home/app/avalon
su -m -c "bundle exec rake db:migrate" app
