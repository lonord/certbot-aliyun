# Docker Arch (amd64, arm32v6, ...)
ARG TARGET_ARCH
FROM mh416ghx.mirror.aliyuncs.com/certbot/certbot:${TARGET_ARCH}-latest

# key and token of aliyun dns service
ENV ALY_KEY ""
ENV ALY_TOKEN ""

COPY certbot-alydns-plugin /certbot-alydns-plugin
COPY certbot-entrypoint.sh /certbot-entrypoint.sh

ENTRYPOINT [ "/certbot-entrypoint.sh" ]