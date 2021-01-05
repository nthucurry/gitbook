# Docker
## 秒懂架構
![](https://s4.itho.me/sites/default/files/styles/picture_size_large/public/field/image/683-封面故事-P34-%28960%29.png?itok=ODsaV2LW)
- 重點
    ```txt
    docker 映象檔是一種分層堆疊的運作方式，採用了 aufs 的檔案架構。要建立一個可提供應用程式完整執行環境的 container 映象檔，要先從一個基礎映象檔(base image)開始疊起，一層層將不同 stack 的 docker 映象檔疊加上去，最後組合成一個應用程式所需 container 執行環境的映象檔，而每一個 stack 也都是可以會匯出成(docker commit指令)一個映象檔。
    ```
- 如何運作
    - <img src="https://miro.medium.com/max/1146/1*yt8ZJdhZ5n6OJAWDUyZS6w.png" alt="drawing" width="700" board="1"/>
- 舉例(undone)
    1. `docker pull ubuntu`
    2. `docker pull httpd`
    3. `docker pull mysql:latest`
    4. `sudo docker run`

## About
傳統虛擬化技術如 vSphere 或 Hyper-V 是以作業系統為中心，而 container 技術則是一種以應用程式為中心的虛擬化技術。

## 安裝 Docker
- Ubuntu
    - 安裝 curl：`sudo apt install curl`
    - 安裝 docker：`curl -sSL https://get.docker.com/ubuntu/ | sudo sh`
- CentOS
    - `yum install yum-utils device-mapper-persistent-data lvm2 -y`
    - `yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`
    - `yum install docker-ce -y`
    - `systemctl start docker && systemctl enable docker`
    - `sudo usermod -aG docker USERNAME`
- macOS
早期的 Windows Docker 是使用 VirtualBox 的虛擬機實現的，但是新版的 Docker for Windows 直接使用 Hyper-V
    - 版本需大於 10.14

## 名詞解釋
- image: 首先類似 VM 的映像檔，打包 python 直譯器、函式庫等元件
- docker hub: 像是大家會把 Python 套件丟上 pip、JS 套件丟上 npm 一樣，大家寫好的 Docker Image 都會丟到 Docker Hub 上

Type           | 虛擬機  | docker | java |
---|---|----|---|
底層環境    | hypervisor | host OS | host OS |
核心    | 映像檔 | image | jre|
建立環境|OS|container| jvm |
repo    | 無 |  docker hub | 無 |
共通性    | 無 | dockerfile | xxx.java |

<div>
<img src="https://blog.gtwang.org/wp-content/uploads/2017/06/virtual-machine-20170625-1.png" alt="drawing" width="300" board="1"/>
<img src="https://blog.gtwang.org/wp-content/uploads/2017/06/docker-container-20170625-1.png" alt="drawing" width="300" board="1"/>
</div>

## 指令
- 啟動 docker：`docker start`
- 關閉 docker：`docker stop`
- 取得 ubuntu 14.04 版本的 image: `docker pull ubuntu:14.04`
- 透過 iamge 執行並產生一個新的 container: `docker run ubuntu:14.04 /bin/echo "example 2 - ubuntu:14.04"`

## 操作步驟
1. `sudo docker run hello-world`
    - ![](../../img/docker/run-hello-world.png)
2. `docker run -d --publish-all jenkins`
    - ![](../../img/docker/jenkins.png)
3. `docker ps -a`
    - ![](../../img/docker/docker-list.png)
4. 輸入網址：localhost:32769
    - ![](../../img/docker/login-page.png)
5. `docker logs gifted_gauss`
    - ![](../../img/docker/get-password.png)
    - ![](../../img/docker/copy-password.png)
    - ![](../../img/docker/finish.png)