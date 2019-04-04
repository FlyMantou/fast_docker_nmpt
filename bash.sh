#!/bin/bash

echo "input which docker container you want open:"
echo "0 : nginx"
echo "1 : php"
echo "2 : mysql"

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
