FROM alpine:latest

RUN apk --no-cache add dnsmasq inotify-tools ;\
    rm -f /etc/dnsmasq.conf

COPY root/ /

EXPOSE 53/tcp 53/udp 67/udp
VOLUME /etc/dnsmasq-state.d

ENTRYPOINT ["/startup.sh"]
