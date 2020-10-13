#!/bin/bash

# sendmail needs this to work
#line=$(head -n 1 /etc/hosts)
#line2=$(echo $line | awk '{print $2}')
#echo "$line $line2.localdomain" >> /etc/hosts

cp /etc/hosts /tmp/hosts.new
sed -i '1s/^/127.0.0.1 localhost localhost.localdomain\n/' /tmp/hosts.new
cp -f /tmp/hosts.new /etc/hosts

service sendmail start

groupadd -g 1002 DIStaffUnix

# Rotate Avalon logs
echo "" >> /etc/logrotate.conf
echo "########## Add Avalon Rotate ##########" >> /etc/logrotate.conf
echo "/home/app/avalon/log/*.log {" >> /etc/logrotate.conf
echo "  su app DIStaffUnix" >> /etc/logrotate.conf
echo "  daily" >> /etc/logrotate.conf
echo "  missingok" >> /etc/logrotate.conf
echo "  rotate 7" >> /etc/logrotate.conf
echo "  compress" >> /etc/logrotate.conf
echo "  delaycompress" >> /etc/logrotate.conf
echo "  notifempty" >> /etc/logrotate.conf
echo "  copytruncate" >> /etc/logrotate.conf
echo "}" >> /etc/logrotate.conf

# batch ingest cronjob wouldn't autorun without this
touch /var/spool/cron/crontabs/root
touch /var/spool/cron/crontabs/app

chown -R app:1002 /mnt/avalon/masterfiles/
chmod -R 0777 /mnt/avalon/masterfiles/

chown -R app:1002 /mnt/avalon/ingest/
chmod -R 0777 /mnt/avalon/ingest/

chown -R app:1002 /mnt/avalon/dropbox
chmod -R 0777 /mnt/avalon/dropbox

echo "* * * * * /bin/bash -l -c '/mnt/avalon/master_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
echo "* * * * * /bin/bash -l -c '/mnt/avalon/ingest_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root
echo "* * * * * /bin/bash -l -c '/mnt/avalon/dropbox_rights.sh' >/dev/null 2>&1" >> /var/spool/cron/crontabs/root

chmod 600 /var/spool/cron/crontabs/root
service cron reload

cd /home/app/avalon
su -m -c "bundle exec rake db:migrate" app
