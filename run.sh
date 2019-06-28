sudo docker run --name mysql \
 -p 3306:3306 \
 -e MYSQL_ROOT_PASSWORD=111220179 \
 -v $PWD/mysql:/var/lib/mysql \
 -v $PWD/logs/mysql:/logs \
 -d mysql:5.6
sudo docker run --name myphp \
 -p 9000:9000 \
 --link=mysql:mysql \
 -v $PWD/nginx/www:/www \
 -v $PWD/php/conf:/usr/local/etc/php \
 -v $PWD/logs/php:/phplogs \
 -d php:5.6-fpm
sudo docker run --name=mytomcat1 \
 -v $PWD/tomcat/webapps:/usr/local/tomcat/webapps \
 -v /mnt:/mnt \
 -p 8081:8080 \
 --link=mysql:mysql \
 -d tomcat
sudo docker run --name=mytomcat2 \
 -v $PWD/tomcat/webapps1:/usr/local/tomcat/webapps \
 -v /mnt:/mnt \
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