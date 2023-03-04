#!/bin/bash

# SSL public certificate (server.crt), private server key (server.key)
openssl req -new -newkey rsa:2048 -sha256 -days 3650 -nodes -x509 -extensions v3_req -keyout server.key -out server.crt -config ssl.conf

# SSL certificate request (server.csr)
openssl req -out server.csr -key server.key -new -config ssl.conf

cat server.crt

systemctl restart squid.service