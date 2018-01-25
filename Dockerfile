FROM alpine:3.7
MAINTAINER "weiduan"

RUN rm /etc/apk/repositories
ADD /sources/repositories /etc/apk/repositories
RUN apk add --no-cache python3 supervisor nginx python3-dev build-base linux-headers pcre-dev \
    && pip3 install --no-cache-dir uwsgi django

ADD sources/ /data
WORKDIR /data

RUN rm /etc/nginx/nginx.conf \
    && rm -f /etc/supervisord.conf \
    && mkdir -p /etc/nginx/sites-enabled /var/log/uwsgi /run/nginx \
    && ln -s /data/supervisord.conf /etc/ \
    && ln -s /data/nginx.conf /etc/nginx/ \
    && ln -s /data/k8sdesktop.conf /etc/nginx/sites-enabled/ \
    && python3 /data/k8sdesktop/manage.py makemigrations \
    && python3 /data/k8sdesktop/manage.py migrate

EXPOSE 80

ENTRYPOINT ["supervisord", "-n"]
