#! /bin/sh

trap "echo 'Terminating'; killall sleep dnsmasq inotifywait; exit" TERM

if [ "${ALT_DNS}" != "" ]; then
  DNS="${ALT_DNS}"
else
  DNS="${__DNSSERVER}"
fi

echo "option:router,${__GATEWAY}
option:domain-name,${__DOMAINNAME}
option:domain-search,${__DOMAINNAME},local
option:ntp-server,pool.ntp.org
option:dns-server,${DNS}" > /etc/dnsmasq-options.d/dhcp-options.conf

cp /dev/null /etc/dnsmasq-hosts.conf
for line in $(cat /etc/dnsmasq-hosts.d/user-defined-hosts.conf); do
  ip=$(echo $line | cut -d"," -f 2)
  host=$(echo $line | cut -d"," -f 3)
  echo "${ip} ${host}.${__DOMAINNAME} ${host}" >> /etc/dnsmasq-hosts.conf
done

echo "domain=${__DOMAINNAME}" >> /etc/dnsmasq.conf

dnsmasq

LEASES=/etc/dnsmasq-state.d/leases
touch ${LEASES}
inotifywait --quiet --monitor --event modify ${LEASES} | while read path action file; do
  sed "s/^[0-9]\+ [0-9a-fA-F:]\+ \([0-9.]\+\) \(.\+\) [0-9a-fA-F:*]\+$/\1 \2/" ${LEASES} | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 > /etc/dnsmasq-state.d/hosts
done

sleep 2147483647d &
wait "$!"
