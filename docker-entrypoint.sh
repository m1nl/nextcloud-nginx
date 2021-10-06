#!/bin/sh

set -e

ln -s /proc/$$/fd/1 /dev/docker-stdout
ln -s /proc/$$/fd/2 /dev/docker-stderr

GOMPLATE="/usr/bin/gomplate"
NGINX="/usr/sbin/nginx"

NGINX_CONF="/etc/nginx/nginx.conf"
NGINX_CONF_TEMPLATE="/etc/nginx/nginx.conf.template"

export MAX_BODY_SIZE="${MAX_BODY_SIZE:-512M}"
export PHP_FPM_URL="${PHP_FPM_URL:-nextcloud-fpm:9000}"

[ -f $NGINX_CONF_TEMPLATE ] && $GOMPLATE -f "$NGINX_CONF_TEMPLATE" -o "$NGINX_CONF"

$NGINX -g "daemon off;"
