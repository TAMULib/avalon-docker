FROM        phusion/passenger-ruby24
LABEL       maintainer="Michael B. Klein <michael.klein@northwestern.edu>, Phuong Dinh <pdinh@indiana.edu>"
RUN         apt-get update && apt-get install -y \
            mediainfo \
            ffmpeg \
            x264 \
            cmake \
            pkg-config \
            lsof \
            sendmail \
            zip \
         && rm -rf /var/lib/apt/lists/* \
         && apt-get clean
RUN         ln -s /usr/bin/lsof /usr/sbin/ \
         && rm /etc/nginx/sites-enabled/default \
         && rm -f /etc/service/nginx/down \
         && ln -s /etc/nginx/sites-available/avalon /etc/nginx/sites-enabled/avalon \
         && chown app:docker_env /etc/container_environment.sh \
         && update-rc.d sendmail enable

ADD         ./avalon.conf /etc/nginx/sites-available/avalon
ADD         ./nginx_env.conf /etc/nginx/main.d/env.conf

ARG         AVALON_REPO=https://github.com/avalonmediasystem/avalon.git
ARG         AVALON_BRANCH=master
RUN         git clone --branch=${AVALON_BRANCH} --depth=1 ${AVALON_REPO} /home/app/avalon

WORKDIR     /home/app/avalon

ARG         RAILS_ENV=production
ARG         BASE_URL
ARG         DATABASE_URL

ADD         Gemfile.local /home/app/avalon/
ADD         config /home/app/avalon/config/
RUN         gem install bundler \
         && bundle config build.nokogiri --use-system-libraries \
         && export SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)') \
         && bundle install --path=vendor/gems --with postgres --without development test profiling mysql \
         && mkdir -p tmp/pids \
         && bundle exec whenever -w -f config/docker_schedule.rb \
         && bundle exec rake assets:precompile \
         && cp config/controlled_vocabulary.yml.example config/controlled_vocabulary.yml \
         && chown -R app:app /home/app

ADD         rails_init.sh /etc/my_init.d/30_rails_init.sh
VOLUME      /masterfiles
