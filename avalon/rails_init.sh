#!/bin/bash

zip -jrml solr_hyrax_config.zip /home/app/avalon/solr/config/*
curl -H "Content-type:application/octet-stream" --data-binary @solr_hyrax_config.zip "http://solr:8983/solr/admin/configs?action=UPLOAD&name=avalon-config"
curl -H 'Content-type: application/json' http://solr:8983/api/collections/ -d '{create: {name: avalon, config: avalon-config, numShards: 1}}'

# batch ingest cronjob wouldn't autorun without this
touch /var/spool/cron/crontabs/app
#
# BACKGROUND=yes QUEUE=* bundle exec rake resque:work
# BACKGROUND=yes bundle exec rake environment resque:scheduler
# RAILS_ENV=production bundle exec rake db:migrate

setuser app bash -c "BACKGROUND=yes bundle exec rake environment resque:scheduler"
setuser app bash -c "BACKGROUND=yes QUEUE=* bundle exec rake resque:work"
setuser app bash -c "RAILS_ENV=production bundle exec rake db:migrate"
