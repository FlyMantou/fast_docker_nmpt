#!/bin/bash

echo "input which docker container you want open:"
echo "0 : nginx"
echo "1 : php"
echo "2 : mysql"
echo "3 : tomcat1"
echo "4 : tomcat2"
echo "5 : redis"

read -p "enter number:" key

if [ -z $key ];then
    echo "error key,exit"
    exit
fi

if [ $key -eq 0 ] ;then
    echo "start open nginx bash,plase wait..."
    docker exec -it mynginx /bin/bash
fi

if [ $key -eq "1" ];then
    echo "start open php bash,please wait..."
    docker exec -it myphp /bin/bash
fi

if [ $key -eq "2" ];then
    echo "start open mysql bash,please wait..."
    docker exec -it mysql /bin/bash
fi

if [ $key -eq "3" ];then
    echo "start open tomcat1 bash,please wait..."
    docker exec -it mytomcat1 /bin/bash
fi

if [ $key -eq "4" ];then
    echo "start open tomcat2 bash,please wait..."
    docker exec -it mytomcat2 /bin/bash
fi

if [ $key -eq "5" ];then
    echo "start open tomcat2 bash,please wait..."
    docker exec -it myredis /bin/bash
fi
