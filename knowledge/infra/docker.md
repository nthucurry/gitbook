# Docker
## 安裝 Docker
- 安裝 curl：`sudo apt install curl`
- 安裝 docker：`curl -sSL https://get.docker.com/ubuntu/ | sudo sh`

## 指令
- 啟動 docker：`docker start`
- 關閉 docker：`docker stop`

## 操作步驟
1. `sudo docker run hello-world`
    - ![](../../img/docker/run_hello-world.png)
2. `docker run -d --publish-all jenkins`
    - ![](../../img/docker/jenkins.png)
3. `docker ps -a`
    - ![](../../img/docker/docker_list.png)
4. 輸入網址：localhost:32769
    - ![](../../img/docker/login_page.png)
5. `docker logs gifted_gauss`
    - ![](../../img/docker/get_password.png)
    - ![](../../img/docker/copy_password.png)
    - ![](../../img/docker/finish.png)