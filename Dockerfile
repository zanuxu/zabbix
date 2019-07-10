FROM ubuntu:16.04
MAINTAINER dimasabyuk@gmail.com

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

RUN apt-get update && apt-get install -y \
        zabbix-web-apache-mysql\
        vim

#!/bin/bash
EXPOSE 22 80 3306/tcp
