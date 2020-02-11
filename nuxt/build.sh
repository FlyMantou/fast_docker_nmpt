#!/usr/bin/env bash
sudo docker build -t mynuxt .
sudo docker run -dt -p 3000:3000 mynuxt
