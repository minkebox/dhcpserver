#! /bin/sh

trap "echo 'Terminating'; killall sleep dnsmasq; exit" TERM

echo "option:router,${__GATEWAY}
option:domain-name,${__DOMAINNAME}
option:domain-search,${__DOMAINNAME}
option:ntp-server,pool.ntp.org
option:dns-server,${__HOSTIP}" > /etc/dnsmasq-options.d/dhcp-options.conf

cp /dev/null /etc/dnsmasq-hosts.conf
for line in $(cat /etc/dnsmasq-hosts.d/user-defined-hosts.conf); do
  ip=$(echo $line | cut -d"," -f 2)
  host=$(echo $line | cut -d"," -f 3)
  echo "${ip} ${host}.${__DOMAINNAME} ${host}" >> /etc/dnsmasq-hosts.conf
done

dnsmasq

sleep 2147483647d &
wait "$!"
