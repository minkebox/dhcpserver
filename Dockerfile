FROM alpine:edge

RUN apk --no-cache add dnsmasq inotify-tools netcat-openbsd ;\
    rm -f /etc/dnsmasq.conf

COPY root/ /

EXPOSE 1053/tcp 1053/udp 67/udp
VOLUME /etc/dnsmasq-state.d

HEALTHCHECK --interval=60s --timeout=5s CMD nc -z ${__HOSTIP} 1053 || exit 1

ENTRYPOINT ["/startup.sh"]
