FROM        phusion/passenger-ruby25
LABEL       maintainer="Michael B. Klein <michael.klein@northwestern.edu>, Phuong Dinh <pdinh@indiana.edu>"

RUN         curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
         && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
         && curl -sL https://deb.nodesource.com/setup_10.x | bash -
		 
RUN		apt-get update

RUN         apt-get install -y mediainfo 
RUN         apt-get install -y ffmpeg 
RUN         apt-get install -y x264 
RUN         apt-get install -y cmake 
RUN         apt-get install -y pkg-config 
RUN         apt-get install -y lsof 
RUN         apt-get install -y sendmail 
RUN         apt-get install -y yarn 
RUN         apt-get install -y nodejs 
RUN         apt-get install -y imagemagick 
RUN         apt-get install -y dos2unix 

RUN         rm -rf /var/lib/apt/lists/* 
RUN         apt-get clean

ARG         CLIENT_MAX_BODY_SIZE=128m	
COPY avalon_nginx.conf /etc/nginx/sites-available/avalon_nginx
RUN sed -i s/{{client_max_body_size}}/${CLIENT_MAX_BODY_SIZE}/g /etc/nginx/sites-available/avalon_nginx
RUN chmod 0755 /etc/nginx/sites-available/avalon_nginx

RUN         ln -s /usr/bin/lsof /usr/sbin/ && \
            rm /etc/nginx/sites-enabled/default && \
            rm -f /etc/service/nginx/down && \
            ln -s /etc/nginx/sites-available/avalon /etc/nginx/sites-enabled/avalon && \
            chown app:docker_env /etc/container_environment.sh

ARG         AVALON_REPO=https://github.com/TAMULib/avalon.git
ARG         AVALON_BRANCH=tamu_development

WORKDIR     /home/app
USER        app
RUN         git clone --branch=${AVALON_BRANCH} --depth=1 ${AVALON_REPO}
ADD         Gemfile.local /home/app/avalon/
ADD         config /home/app/avalon/config/

ARG         RAILS_ENV=production

RUN         cd avalon && \
              gem install bundler && \
              bundle config build.nokogiri --use-system-libraries && \
              bundle install --path=vendor/gems --with postgres --without development test profiling mysql && \
              cd ..

#RUN         cd avalon \
#			&& bundle exec whenever -w -f config/docker_schedule.rb 
			
RUN         cd avalon \			
			&& bundle exec rake assets:precompile SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)')


USER        root
RUN chown -R app:app /home/app/avalon

###
# Ensure Configurations are set both .YML
###
ARG SOLR_HOST_YML
ARG SOLR_PORT_YML
ARG SOLR_BASE_PATH_YML

RUN sed -i s/{{SOLR_HOST_YML}}/${SOLR_HOST}/g  /home/app/avalon/config/solr.yml
RUN sed -i s/{{SOLR_PORT_YML}}/${SOLR_PORT}/g  /home/app/avalon/config/solr.yml
RUN sed -i s/{{SOLR_BASE_PATH_YML}}/${SOLR_BASE_PATH}/g  /home/app/avalon/config/solr.yml

ARG FEDORA_HOST_YML
ARG FEDORA_PORT_YML
ARG FEDORA_BASE_PATH_YML
ARG FEDORA_USER_YML
ARG FEDORA_PASSWORD_YML

RUN sed -i s/{{FEDORA_HOST_YML}}/${FEDORA_HOST_YML}/g  /home/app/avalon/config/fedora.yml
RUN sed -i s/{{FEDORA_PORT_YML}}/${FEDORA_PORT_YML}/g  /home/app/avalon/config/fedora.yml
RUN sed -i s/{{FEDORA_BASE_PATH_YML}}/${FEDORA_BASE_PATH_YML}/g  /home/app/avalon/config/fedora.yml
RUN sed -i s/{{FEDORA_USER_YML}}/${FEDORA_USER_YML}/g  /home/app/avalon/config/fedora.yml
RUN sed -i s/{{FEDORA_PASSWORD_YML}}/${FEDORA_PASSWORD_YML}/g  /home/app/avalon/config/fedora.yml

###

ADD         ./avalon.conf /etc/nginx/sites-available/avalon
ADD         ./nginx_env.conf /etc/nginx/main.d/env.conf
ADD         rails_init.sh /etc/my_init.d/30_rails_init.sh

USER        root
RUN 		dos2unix /etc/my_init.d/30_rails_init.sh
USER        root
RUN 		dos2unix /etc/container_environment.sh

RUN         mkdir /streamfiles && chmod 0777 /streamfiles
VOLUME      /streamfiles

