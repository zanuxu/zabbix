FROM ubuntu:16.04
MAINTAINER dimasabyuk@gmail.com

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

RUN apt-get update && apt-get install -y \
            addgroup --system --quiet zabbix && \
            adduser --quiet \
            --system --disabled-login \
            --ingroup zabbix \
            --home /var/lib/zabbix/ \
            --no-create-home \
        zabbix-server-mysql\
        zabbix-frontend-php\
        zabbix-agent\
        vim \
        mkdir -p /etc/zabbix && \
        mkdir -p /etc/zabbix/web && \
        chown --quiet -R zabbix:root /etc/zabbix && \
        apt-get -y update && \
        DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        apache2 \
        curl \
        libapache2-mod-php \
        mysql-client \
        php7.2-bcmath \
        php7.2-gd \
        php7.2-json \
        php7.2-ldap \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-xml && \
        ca-certificates \
        apt-get -y --no-install-recommends autoremove && \
        apt-get -y --no-install-recommends clean && \
        rm -rf /var/lib/apt/lists/*
        
RUN set -eux && \
        mkdir /usr/share/zabbix/ && \
        cp -R /usr/share/zabbix-4.2.4/frontends/php/* /usr/share/zabbix/ && \
        rm -rf /usr/share/zabbix-4.2.4/ && \
        cd /usr/share/zabbix/ && \
        rm -f conf/zabbix.conf.php && \
        rm -rf tests && \
        ./locale/make_mo.sh

#!/bin/bash
EXPOSE 80/TCP 443/TCP 10051/TCP
