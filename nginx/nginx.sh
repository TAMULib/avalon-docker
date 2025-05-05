#!/bin/sh

# Make config file from template
[ -z "$env_kaltura_streaming_port" ] && env_kaltura_streaming_port=80
[ -z "$env_rtmp_avalon_url" ] && env_rtmp_avalon_url="http://avalon:3000"
[ -z "$env_master_file_location" ] && env_master_file_location=/mnt/avalon/masterfiles
[ -z "$env_proxy_pass_url" ] && env_proxy_pass_url=http://avalon:3000
[ -z "$env_resolver_ip" ] && env_resolver_ip=127.0.0.1

export env_kaltura_streaming_port
export env_rtmp_avalon_url
export env_master_file_location
export env_proxy_pass_url
export env_resolver_ip
export env_auth_request_line

envsubst '$env_auth_request_line,$env_rtmp_avalon_url,$env_kaltura_streaming_port,$env_master_file_location,$env_proxy_pass_url,$env_resolver_ip' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

sed -i "s,{{Content-Security-Policy}},${new_value},g" /etc/nginx/nginx.conf

exec /usr/local/nginx/sbin/nginx
