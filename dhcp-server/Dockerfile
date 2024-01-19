FROM alpine:latest
RUN set -xe \
	&& apk add --update --no-progress dhcp \
	&& rm -rf /var/cache/apk/*

WORKDIR /app
RUN rm -f /etc/network/interfaces
CMD ["/usr/sbin/dhcpd", "-4", "-f","-d","--no-pid","-cf","/config/dhcpd.conf"]