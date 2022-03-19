# Docker Arch (amd64, arm32v6, ...)
ARG TARGET_ARCH
FROM certbot/certbot:${TARGET_ARCH}-latest

VOLUME /etc/letsencrypt

# key and token of aliyun dns service
ENV ALY_KEY ""
ENV ALY_TOKEN ""

COPY certbot-alydns-plugin /certbot-alydns-plugin
COPY certbot-entrypoint.sh /certbot-entrypoint.sh

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add bash

ENTRYPOINT [ "/certbot-entrypoint.sh" ]