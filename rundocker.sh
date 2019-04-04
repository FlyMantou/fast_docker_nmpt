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
 -v $PWD/tomcat/webapps:/usr/local/tomcat/webapps \
 -p 8082:8080 \
 --link=mysql:mysql \
 -d tomcat

sudo docker run --name mynginx \
 --link=myphp:phpfpm \
 --link=mytomcat1:t1 \
 --link=mysql:mysql \
 --link=mytomcat1:t1 \
 --link=mytomcat2:t2 \
 -p 80:80 \
 -v $PWD/nginx/www:/www \
 -v $PWD/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
 -v $PWD/nginx/conf.d:/etc/nginx/conf.d \
 -d nginx

