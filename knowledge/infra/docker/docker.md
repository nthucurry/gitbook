# Docker
## Referfence
- [用 30 天來介紹和使用 Docker 系列](https://ithelp.ithome.com.tw/users/20103456/ironman/1320)
- [Cloud-native applications](https://github.com/Microsoft-CloudRiches/MCW-Cloud-native-applications)

## 容器發展史
<br><img src="https://d33wubrfki0l68.cloudfront.net/26a177ede4d7b032362289c6fccd448fc4a91174/eb693/images/docs/container_evolution.svg" alt="drawing" width="800" board="1"/><br>

## 秒懂架構
![](https://s4.itho.me/sites/default/files/styles/picture_size_large/public/field/image/683-封面故事-P34-%28960%29.png?itok=ODsaV2LW)
![](https://ithelp.ithome.com.tw/upload/images/20171205/20103456jl9BuRvKSl.png)
- 重點
docker 映象檔是一種分層堆疊的運作方式，採用了 aufs 的檔案架構。要建立一個可提供應用程式完整執行環境的 container 映象檔，要先從一個基礎映象檔 (base image) 開始疊起，一層層將不同 stack 的 docker 映象檔疊加上去，最後組合成一個應用程式所需 container 執行環境的映象檔，而每一個 stack 也都是可以會匯出成 (docker commit 指令) 一個映象檔。
- 如何運作
    - <img src="https://miro.medium.com/max/1146/1*yt8ZJdhZ5n6OJAWDUyZS6w.png" alt="drawing" width="700" board="1"/>
- 舉例(undone)
    1. `docker pull ubuntu`
        - `docker run -ti ubuntu /bin/bash`
    2. `docker pull httpd`
    3. `docker pull mysql:latest`
    4. `sudo docker run`

## About
傳統虛擬化技術如 vSphere 或 Hyper-V 是以作業系統為中心，而 container 技術則是一種以應用程式為中心的虛擬化技術。

## 流程
- 抓取需要的 image (`docker pull`)
- 啟動 container
    - 進入 container terminal (`docker run`)
    - 安裝 or 啟動服務
    - 以上可以用 Dockerfile 作為 script 處理
- 執行時，可以用 build image by Dockerfile，服務就啟動了
- build image 如果資料夾內有 Dockerfile，就會成功

## 安裝 Docker
- Ubuntu
    - 安裝 curl：`sudo apt install curl`
    - 安裝 docker：`curl -sSL https://get.docker.com/ubuntu/ | sudo sh`
- CentOS (請用 user account 執行)
    ```bash
    sudo yum install yum-utils device-mapper-persistent-data lvm2 -y
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce -y
    sudo systemctl start docker && sudo systemctl enable docker
    sudo usermod -aG docker `whoami`

    # docker daemon setting
    sudo mkdir -p /etc/systemd/system/docker.service.d
    echo "[Service]" >> /etc/systemd/system/docker.service.d/http-proxy.conf
    echo "Environment=\"HTTP_PROXY=http://10.250.12.5:3128\"" >> /etc/systemd/system/docker.service.d/http-proxy.conf
    echo "Environment=\"HTTPS_PROXY=http://10.250.12.5:3128\"" >> /etc/systemd/system/docker.service.d/http-proxy.conf

    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```

## 名詞解釋
- image: 首先類似 VM 的映像檔，打包 python 直譯器、函式庫等元件
- docker hub: 像是大家會把 Python 套件丟上 pip、JS 套件丟上 npm 一樣，大家寫好的 Docker Image 都會丟到 Docker Hub 上

| Type     | 虛擬機     | docker     | java     |
|----------|------------|------------|----------|
| 底層環境 | hypervisor | host OS    | host OS  |
| 核心     | 映像檔     | image      | jre      |
| 建立環境 | OS         | container  | jvm      |
| repo     | 無         | docker hub | 無       |
| 共通性   | 無         | dockerfile | xxx.java |

<div>
<img src="https://blog.gtwang.org/wp-content/uploads/2017/06/virtual-machine-20170625-1.png" alt="drawing" width="300" board="1"/>
<img src="https://blog.gtwang.org/wp-content/uploads/2017/06/docker-container-20170625-1.png" alt="drawing" width="300" board="1"/>
</div>

## 指令
- 取得 ubuntu 14.04 版本的 image: `docker pull ubuntu:14.04`
- 透過 iamge 執行並產生一個新的 container: `docker run ubuntu:14.04 /bin/echo "example 2 - ubuntu:14.04"`
- 刪除已停止的 containers: `docker rm $(docker ps -aq)`

## 操作步驟
1. `sudo docker run hello-world`
    - ![](https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/docker/run-hello-world.png)
2. `docker run -d --publish-all jenkins`
    - ![](https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/docker/jenkins.png)
3. `docker ps -a`
    - ![](https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/docker/docker-list.png)
    - 停止 container: `docker stop b551697c6c55`
    - 刪除 container: `docker rm b551697c6c55`
    - 刪除 image: `docker rmi 300e315adb2f`
4. 輸入網址：localhost:32769
    - ![](https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/docker/login-page.png)
5. `docker logs gifted_gauss`
    - ![](https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/docker/get-password.png)
    - ![](https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/docker/copy-password.png)
    - ![](https://raw.githubusercontent.com/ShaqtinAFool/gitbook/master/img/docker/finish.png)

## Run MariaDB
- `docker run --name scm-mariadb -e MYSQL_ROOT_PASSWORD=ncu5540 -d mariadb`
- `docker run -itd --name scm-mariadb -p 3306:3306 -e MYSQL_ROOT_PASSWORD=ncu5540 mariadb`

## Run service by dockerfile
- https://ithelp.ithome.com.tw/articles/10191016?sc=hot
- `mkdir docker-test`
- `cd docker-test`
- `vi Dockerfile`
    ```txt
    FROM centos:7
    MAINTAINER jack

    RUN yum install -y wget

    RUN cd /

    ADD jdk-8u152-linux-x64.tar.gz /

    RUN wget http://apache.stu.edu.tw/tomcat/tomcat-7/v7.0.107/bin/apache-tomcat-7.0.107.tar.gz
    RUN tar zxvf apache-tomcat-7.0.107.tar.gz

    ENV JAVA_HOME=/jdk1.8.0_152
    ENV PATH=$PATH:/jdk1.8.0_152/bin
    CMD ["/apache-tomcat-7.0.107/bin/catalina.sh", "run"]
    ```
- `docker build -t mytomcat . --no-cache`
    - http://172.17.0.1
- `docker run -p 8080:8080 mytomcat`
- `docker ps -a`
- `docker exec -it a2294eea8345 /bin/bash`

### Resolve dockerfile
- FROM centos:7
    - 使用到的 Docker Image 名稱，今天使用 CentOS
- MAINTAINER jack
    - 用來說明，撰寫和維護這個 Dockerfile 的人是誰，也可以給 E-mail 的資訊
- RUN yum install -y wget
- RUN cd /
    - RUN 指令後面放 Linux 指令，用來執行安裝和設定這個 Image 需要的東西
- ADD jdk-8u152-linux-x64.tar.gz /
    - 把 Local 的檔案複製到 Image 裡，如果是 tar.gz 檔複製進去 Image 時會順便自動解壓縮
    - Dockerfile 另外還有一個複製檔案的指令 COPY 未來還會再介紹
- RUN wget http://apache.stu.edu.tw/tomcat/tomcat-7/v7.0.107/bin/apache-tomcat-7.0.107.tar.gz
- RUN tar zxvf apache-tomcat-7.0.107.tar.gz
- ENV JAVA_HOME=/jdk1.8.0_152
- ENV PATH=$PATH:/jdk1.8.0_152/bin
    - 用來設定環境變數
- CMD ["/apache-tomcat-7.0.107/bin/catalina.sh", "run"]
    - 在指行 docker run 的指令時會直接呼叫開啟 Tomcat Service

## Docker Network
<br><img src="https://ithelp.ithome.com.tw/upload/images/20171223/20103456bATaXz4Pcl.png" board="1" />

- `docker network ls`
- [兩種對外服務連線方式](https://kknews.cc/zh-tw/news/9n9z5z8.html)
    - NAT port forwarding: 讓 Host2 的 Port 對應到 Container1 的 Port，然後 Host1 會先連到 Host2 實體主機的 Port，然後就會對應到 Container1 的 Port
    - bridge(橋接): 讓 Container 橋接到實體主機網路卡