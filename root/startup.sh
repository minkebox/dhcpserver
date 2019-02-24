#! /bin/sh

trap "echo 'Terminating'; killall sleep dnsmasq; exit" TERM

echo "option:router,${__GATEWAY}
option:domain-name,${__DOMAINNAME}
option:domain-search,${__DOMAINNAME}
option:ntp-server,pool.ntp.org
option:dns-server,${__HOSTIP}" > /etc/dnsmasq-options.d/dhcp-options.conf

dnsmasq

sleep 2147483647d &
wait "$!"
