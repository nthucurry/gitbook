#!/bin/bash

dockerHub="adthub.azurecr.io"

# initial
mkdir app-ssh-tool
cd app-ssh-tool
wget https://raw.githubusercontent.com/Azure-App-Service/node/master/10.14/sshd_config
wget https://raw.githubusercontent.com/Azure-App-Service/node/master/10.14/ssh_setup.sh
wget https://raw.githubusercontent.com/Azure-App-Service/node/master/10.14/hostingstart.html
wget https://raw.githubusercontent.com/Azure-App-Service/node/master/10.14/Dockerfile
cp /home/azadmin/server.crt .
mkdir startup
cd startup
wget https://raw.githubusercontent.com/Azure-App-Service/node/master/10.14/startup/default-static-site.js
wget https://raw.githubusercontent.com/Azure-App-Service/node/master/10.14/startup/init_container.sh
wget https://raw.githubusercontent.com/Azure-App-Service/node/master/10.14/startup/npm-shrinkwrap.json
wget https://raw.githubusercontent.com/Azure-App-Service/node/master/10.14/startup/package.json
cd ..

# docker build & push
docker build -t app-ssh-tool . --no-cache
docker tag app-ssh-tool ${dockerHub}/app-ssh-tool
docker images
docker push ${dockerHub}/app-ssh-tool

# docker run
docker run -dit --name my-running-app -p 80:80 app-ssh-tool