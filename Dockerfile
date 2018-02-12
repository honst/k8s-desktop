FROM alpine:3.7
MAINTAINER "weiduan"

RUN rm /etc/apk/repositories
ADD /sources/repositories /etc/apk/repositories
RUN apk add --no-cache python3 supervisor nginx python3-dev build-base linux-headers pcre-dev openldap-dev \
    && pip3 install --no-cache-dir uwsgi django django-auth-ldap PyMySQL

ADD sources/ /data
WORKDIR /data

RUN ln -s /usr/lib/python3.6/site-packages/django/contrib/admin/static/admin /data/k8sdesktop/static/ \
    && rm -f /etc/nginx/nginx.conf /etc/supervisord.conf /usr/bin/python \
    && mkdir -p /etc/nginx/sites-enabled /var/log/uwsgi /run/nginx \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /data/supervisord.conf /etc/ \
    && ln -s /data/nginx.conf /etc/nginx/ \
    && ln -s /data/k8sdesktop.conf /etc/nginx/sites-enabled/

EXPOSE 80

ENTRYPOINT ["supervisord", "-n"]
