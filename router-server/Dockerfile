FROM alpine:latest
RUN set -xe \
  && apk add --update --no-progress iptables
CMD ["/bin/sh","/config/start.sh"]
