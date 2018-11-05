#!/bin/bash

cd /home/app/avalonsolr/config
zip -1 -r solr_hyrax_config.zip /home/app/avalon/solr/config/*
curl -H "Content-type:application/octet-stream" --data-binary @solr_hyrax_config.zip "http://solr:8983/solr/admin/configs?action=UPLOAD&name=avalon-config"
curl -H 'Content-type: application/json' http://solr:8983/api/collections/ -d '{create: {name: avalon, config: avalon-config, numShards: 1}}'

# sendmail needs this to work
line=$(head -n 1 /etc/hosts)
line2=$(echo $line | awk '{print $2}')
echo "$line $line2.localdomain" >> /etc/hosts
service sendmail start

# batch ingest cronjob wouldn't autorun without this
touch /var/spool/cron/crontabs/app

chmod 0777 -R /masterfiles
chown -R app /masterfiles
cd /home/app/avalon

su app
BACKGROUND=yes QUEUE=* bundle exec rake resque:work
BACKGROUND=yes bundle exec rake environment resque:scheduler
RAILS_ENV=production bundle exec rake db:migrate
exit

