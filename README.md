# fast_docker_nmpt
docker+php+nginx负载+mysql+tomcat+redis共享session环境搭建  
给服务器搭环境是一件很苦恼的事情，在接触了docker之后觉得能把事情由复杂变简单，所以在此记录下我搭建一套可访问的docker环境所做的事情。
环境：阿里云ubuntu1604
1. 安装最新版本的 Docker 安装包
```shell
wget -qO- https://get.docker.com/ | sh
```
2. 启动docker
```shell
sudo service docker start
```
3. 下载镜像
```shell
docker pull nginx
docker pull php
docker pull mysql:5.6
docker pull tomcat
docker pull redis:3.2
```
4. 下载我的配置文件包
```shell
git clone https://github.com/FlyMantou/fast_docker_nmpt.git
```
目录说明：部分目录为执行 rundocker.sh之后自动生成
 ![image.png](https://upload-images.jianshu.io/upload_images/11285551-9d027d35def661d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

5. 启动docker容器
```shell
./dockerClear.sh
./rundocker.sh
```
6. 添加php虚拟主机
```shell
./addhost.sh
```
部分文件内容如下：
dockerClear.sh
```shell
docker stop $(docker ps -q)
docker rm `docker ps -a -q`
```
rundocker.sh
```shell

sudo docker run --name mysql \
 -p 3306:3306 \
 -e MYSQL_ROOT_PASSWORD=111220179 \
 -v $PWD/mysql:/var/lib/mysql \
 -v $PWD/mysqllogs:/logs \
 -d mysql:5.6
sudo docker run --name myphp \
 -p 9000:9000 \
 --link=mysql:mysql \
 -v $PWD/nginx/www:/www \
 -v $PWD/php/conf:/usr/local/etc/php \
 -v $PWD/phplogs:/phplogs \
 -d php:5.6-fpm
sudo docker run --name=mytomcat1 \
 -v $PWD/tomcat/webapps:/usr/local/tomcat/webapps \
 -p 8081:8080 \
 --link=mysql:mysql \
 -d tomcat
sudo docker run --name=mytomcat2 \
 -v $PWD/tomcat/webapps1:/usr/local/tomcat/webapps \
 -p 8082:8080 \
 --link=mysql:mysql \
 -d tomcat

sudo docker run --name mynginx \
 --link=myphp:phpfpm \
 --link=mytomcat1:t1 \
 --link=mysql:mysql \
 --link=mytomcat2:t2 \
 -p 80:80 \
 -v $PWD/nginx/www:/www \
 -v $PWD/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
 -v $PWD/nginx/conf.d:/etc/nginx/conf.d \
 -d nginx

sudo docker run --name myredis -p 6379:6379 -v $PWD/redis/data:/data -d redis:3.2 redis-server --appendonly yes

docker cp $PWD/tomcat/confcopy/context.xml mytomcat1:/usr/local/tomcat/conf
docker cp $PWD/tomcat/confcopy/redis-data-cache.properties mytomcat1:/usr/local/tomcat/conf
docker cp $PWD/tomcat/libcopy/commons-logging-1.2.jar mytomcat1:/usr/local/tomcat/lib
docker cp $PWD/tomcat/libcopy/commons-pool2-2.4.2.jar mytomcat1:/usr/local/tomcat/lib
docker cp $PWD/tomcat/libcopy/jedis-2.9.0.jar mytomcat1:/usr/local/tomcat/lib
docker cp $PWD/tomcat/libcopy/tomcat-cluster-redis-session-manager-2.0.3.jar mytomcat1:/usr/local/tomcat/lib

docker restart mytomcat1

docker cp $PWD/tomcat/confcopy/context.xml mytomcat2:/usr/local/tomcat/conf
docker cp $PWD/tomcat/confcopy/redis-data-cache.properties mytomcat2:/usr/local/tomcat/conf
docker cp $PWD/tomcat/libcopy/commons-logging-1.2.jar mytomcat2:/usr/local/tomcat/lib
docker cp $PWD/tomcat/libcopy/commons-pool2-2.4.2.jar mytomcat2:/usr/local/tomcat/lib
docker cp $PWD/tomcat/libcopy/jedis-2.9.0.jar mytomcat2:/usr/local/tomcat/lib
docker cp $PWD/tomcat/libcopy/tomcat-cluster-redis-session-manager-2.0.3.jar mytomcat2:/usr/local/tomcat/lib

docker restart mytomcat2

```
addhost.sh
```shell

read -p "input domain:" domain
echo "server {
  listen  80;
  server_name $domain;
  root   /www/$domain/;
  location / {
   index index.html index.htm index.php;
   autoindex off;
  }
  location ~ \.php(.*)$ {
   root   /www/$domain/;
   fastcgi_pass phpfpm:9000;
   fastcgi_index index.php;
   fastcgi_split_path_info ^((?U).+\.php)(/?.+)$;
   fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
   fastcgi_param PATH_INFO \$fastcgi_path_info;
   fastcgi_param PATH_TRANSLATED \$document_root\$fastcgi_path_info;
   include  fastcgi_params;
  }
}
" >> $PWD/nginx/conf.d/default.conf

```
default.conf
```shell
upstream tomcat{
    server t1:8080 weight=1;
   # server t2:8080 weight=1;
}

server{
    listen 80;
    server_name tomcat.myhuanghai.com;
    location / {
        proxy_pass http://tomcat;
    }

    #location /score {
     #   proxy_pass http://tomcat;
   # }

}

server {
  listen  80;
  server_name score.myhuanghai.com;
  root   /www/score.myhuanghai.com/;
  location / {
   index index.html index.htm index.php;
   autoindex off;
  }
  location ~ \.php(.*)$ {
   root   /www/score.myhuanghai.com/;
   fastcgi_pass phpfpm:9000;
   fastcgi_index index.php;
   fastcgi_split_path_info ^((?U).+\.php)(/?.+)$;
   fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
   fastcgi_param PATH_INFO $fastcgi_path_info;
   fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
   include  fastcgi_params;
  }
}


```
说明：自己写了上面的shell脚本帮助快速操作docker，比较难搞的是nginx配置文件nginx/conf.d/default.conf文件的配置内容，addhost.sh文件的原理也是在此文件追加配置内容。所有内容请依据自己的环境进行适当更改，如果本文能够帮到你，请给我点个赞吧！
参考地址：
docker菜鸟教程：http://www.runoob.com/docker/docker-tutorial.html
nginx反向代理：https://blog.csdn.net/u012251836/article/details/82733803
tomcat8配置redis：https://blog.csdn.net/lin252552/article/details/80096455
