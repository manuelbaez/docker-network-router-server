FROM alpine:latest
RUN set -xe \
  && apk add --update --no-progress bind bind-tools 

RUN rm -r /etc/bind
WORKDIR /app
COPY start.sh ./
RUN chmod +x ./start.sh
CMD ["/bin/sh", "/app/start.sh"]