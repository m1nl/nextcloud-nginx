FROM nginx:mainline-alpine

RUN set -eux; \
  apk add --update --no-cache \
    gomplate

ARG NEXTCLOUD_VERSION=22.2.0

RUN set -eux; \
  curl -sSL https://download.nextcloud.com/server/releases/nextcloud-$NEXTCLOUD_VERSION.tar.bz2 -o /tmp/nextcloud-$NEXTCLOUD_VERSION.tar.bz2; \
  mkdir -p /var/www; \
  rm -rf /var/www/*; \
  tar xfj /tmp/nextcloud-$NEXTCLOUD_VERSION.tar.bz2 -C /var/www; \
  rm -f /tmp/nextcloud-$NEXTCLOUD_VERSION.tar.bz2; \
  chown nginx:nginx -R /var/www/nextcloud

COPY error-pages/ /var/www/error-pages/

COPY nginx/ /etc/nginx/

RUN set -eux; \
  mkdir -p /var/www/nextcloud/apps-custom; \
  mkdir -p /var/www/nextcloud/config; \
  mkdir -p /var/www/nextcloud/data; \
  chmod u=rwx,g=rx,o= /var/www/nextcloud/apps-custom; \
  chmod u=rwx,g=rx,o= /var/www/nextcloud/config; \
  chmod u=rwx,g=rx,o= /var/www/nextcloud/data; \
  chown nginx:nginx /var/www/nextcloud/apps-custom; \
  chown nginx:nginx /var/www/nextcloud/config; \
  chown nginx:nginx /var/www/nextcloud/data

VOLUME /var/www/nextcloud/apps-custom
VOLUME /var/www/nextcloud/config
VOLUME /var/www/nextcloud/data

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
