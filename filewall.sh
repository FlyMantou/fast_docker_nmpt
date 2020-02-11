#!/bin/bash

echo "input allow port"

read -p "enter port:" key

if [ -z $key ];then
    echo "error key,exit"
    exit
fi

iptables -A INPUT -p tcp --dport $key -j ACCEPT

service iptables save && service iptables restart
