FROM alpine:latest

RUN apk --no-cache add dnsmasq inotify-tools ;\
    rm -f /etc/dnsmasq.conf

COPY root/ /

EXPOSE 53/tcp 53/udp 67/udp
VOLUME /etc/dnsmasq-state.d

HEALTHCHECK --interval=60s --timeout=5s CMD pidof dnsmasq || exit 1

ENTRYPOINT ["/startup.sh"]
