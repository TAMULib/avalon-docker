FROM        phusion/passenger-ruby25
LABEL       maintainer="Michael B. Klein <michael.klein@northwestern.edu>, Phuong Dinh <pdinh@indiana.edu>"

RUN         curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
         && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
         && curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN         apt-get update && apt-get install -y \
            mediainfo \
            ffmpeg \
            x264 \
            cmake \
            pkg-config \
            lsof \
            sendmail \
            yarn \
            nodejs \
            imagemagick \
	    dos2unix \
         && rm -rf /var/lib/apt/lists/* \
         && apt-get clean
	
ARG         CLIENT_MAX_BODY_SIZE=128m	
COPY avalon_nginx.conf /etc/nginx/sites-available/avalon_nginx
RUN sed -i s/{client_max_body_size}/${CLIENT_MAX_BODY_SIZE}/g /etc/nginx/sites-available/avalon_nginx
RUN chmod 0755 /etc/nginx/sites-available/avalon_nginx

RUN         ln -s /usr/bin/lsof /usr/sbin/ && \
            rm /etc/nginx/sites-enabled/default && \
            rm -f /etc/service/nginx/down && \
            ln -s /etc/nginx/sites-available/avalon /etc/nginx/sites-enabled/avalon && \
            chown app:docker_env /etc/container_environment.sh

ARG         AVALON_REPO=https://github.com/TAMULib/avalon.git
ARG         AVALON_BRANCH=master

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
			  
ARG         BASE_URL
ARG         DATABASE_URL

RUN         cd avalon \
			&& bundle exec whenever -w -f config/docker_schedule.rb 
			
RUN         cd avalon \			
			&& bundle exec rake assets:precompile SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)')
			
USER        root
RUN         chown -R app:app /home/app/avalon

ADD         ./avalon.conf /etc/nginx/sites-available/avalon
ADD         ./nginx_env.conf /etc/nginx/main.d/env.conf
ADD         rails_init.sh /etc/my_init.d/30_rails_init.sh

USER        root
RUN 		dos2unix /etc/my_init.d/30_rails_init.sh
USER        root
RUN 		dos2unix /etc/container_environment.sh

RUN         mkdir /streamfiles && chmod 0777 /streamfiles
VOLUME      /streamfiles

