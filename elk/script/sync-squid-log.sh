inotifywait -m -e modify,create,delete /var/log/squid/access.log |
while read modify;
do
  rsync /var/log/squid/access.log root@t-elk:/data-to-local/my/azure-squid/proxy-tls
done