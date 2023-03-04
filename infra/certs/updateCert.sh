#!/bin/bash

update-ca-trust

cat /home/azadmin/server.crt >> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
# cp /home/azadmin/server.crt /etc/pki/ca-trust/source/anchors/
# update-ca-trust extract

systemctl restart docker.service

# cp /home/azadmin/server.crt /etc/docker/certs.d/registry-1.docker.io/
# mv /etc/docker/certs.d/registry-1.docker.io/server.crt /etc/docker/certs.d/registry-1.docker.io/ca.crt