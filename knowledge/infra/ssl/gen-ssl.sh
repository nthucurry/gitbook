openssl req -x509 -new -nodes -sha256 -utf8 -days 3650 -newkey rsa:2048 -keyout server.key -out server.crt -config ssl.conf

openssl pkcs12 -export -in server.crt -inkey server.key -out server.pfx

openssl x509 -in server.crt -out server.cer -outform DER