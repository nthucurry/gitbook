inotifywait -m -e attrib /var/log/squid/access.log |
while read modify;
do
  rsync /var/log/squid/access.log root@t-elk:/var/log/squid
done