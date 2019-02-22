#! /bin/sh

trap "echo 'Terminating'; killall sleep dnsmasq; exit" TERM

echo "option:router,${__GATEWAY}
option:dns-server,${__HOSTIP}" > /etc/dnsmasq-options.d/dhcp-options.conf

dnsmasq

sleep 2147483647d &
wait "$!"
