# Install
```bash
docker run -d --name squid -e TZ=UTC -p 3128:3128 ubuntu/squid:5.2-22.04_beta
docker exec -it squid /bin/bash
exit
docker cp squid:/etc/squid/squid.conf ./
```