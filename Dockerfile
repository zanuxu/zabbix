FROM ubuntu:16.04
MAINTAINER dimasabyuk@gmail.com

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

RUN apt-get update && apt-get install -y \
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

WORKDIR /usr/share/zabbix

VOLUME ["/etc/ssl/apache2"]

COPY ["apache.conf", "/etc/zabbix/"]
COPY ["apache_ssl.conf", "/etc/zabbix/"]
COPY ["zabbix.conf.php", "/etc/zabbix/web/"]
COPY ["99-zabbix.ini", "/etc/php/7.2/apache2/conf.d/"]
COPY ["docker-entrypoint.sh", "/usr/bin/"]

ENTRYPOINT ["docker-entrypoint.sh"]
