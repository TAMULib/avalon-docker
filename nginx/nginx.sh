#!/bin/sh

# Make config file from template
[ -z "$env_rtmp_avalon_url" ] && env_rtmp_avalon_url="http://avalon"
[ -z "$env_avalon_streaming_port" ] && env_avalon_streaming_port=80
[ -z "$env_master_file_location" ] && env_master_file_location=/data
[ -z "$env_proxy_pass_ip" ] && env_proxy_pass_ip=127.0.0.1

export env_rtmp_avalon_url
export env_avalon_streaming_port
export env_master_file_location
export env_proxy_pass_ip

envsubst '$env_rtmp_avalon_url,$env_avalon_streaming_port,$env_master_file_location,$env_proxy_pass_ip' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

exec /usr/local/nginx/sbin/nginx
