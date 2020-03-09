FROM        phusion/baseimage:latest
MAINTAINER  Michael B. Klein <michael.klein@northwestern.edu>

RUN         apt-get update -y
RUN         apt-get upgrade -y -o Dpkg::Options::="--force-confdef"

RUN         apt-get install -y mediainfo ffmpeg x264 
RUN         apt-get install -y build-essential git libpcre3-dev zlib1g-dev libssl-dev dnsmasq

# gettext-base provides 'envsubst', used by nginx.sh
RUN         apt-get install -y gettext-base

RUN         apt-get clean


# Build Nginx
RUN cd /usr/src && apt-get source nginx && mv nginx-* nginx
RUN cd /usr/src && git clone https://github.com/arut/nginx-rtmp-module.git && cd nginx-rtmp-module && git checkout -b latest-tag $(git describe --tags)
RUN cd /usr/src && git clone https://github.com/kaltura/nginx-vod-module.git && cd nginx-vod-module && git checkout -b latest-tag $(git describe --tags)
RUN cd /usr/src/nginx && ./configure --with-file-aio --with-cc-opt="-O3" --conf-path=/etc/nginx/nginx.conf --add-module=/usr/src/nginx-rtmp-module --add-module=/usr/src/nginx-vod-module --with-http_auth_request_module --with-http_sub_module --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log
RUN cd /usr/src/nginx && make && make install
RUN rm -rf /usr/src/*

EXPOSE      1935
EXPOSE      80

RUN         useradd nginx
RUN         mkdir /data
RUN         mkdir -p /var/log/nginx && chown nginx /var/log/nginx
ADD         stat.xsl  /etc/nginx/stat.xsl

ADD         nginx.conf.template /etc/nginx/nginx.conf.template

RUN         mkdir /etc/service/dnsmasq
ADD         dnsmasq.sh /etc/service/dnsmasq/run
RUN         chmod +x /etc/service/dnsmasq/run

RUN         mkdir /etc/service/nginx
ADD         nginx.sh /etc/service/nginx/run
RUN         chmod +x /etc/service/nginx/run
