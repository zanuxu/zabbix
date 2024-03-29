FROM ubuntu:16.04
MAINTAINER dimasabyuk@gmail.com

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

RUN     set -e; \
        apt-get -y update && apt-get -y install \
        zabbix-server-mysql \
        mysql-server\
        zabbix-java-gateway\
        apache2 \
        mysql-client \
        php7.2-bcmath \
        php7.2-gd \
        php7.2-json \
        php7.2-ldap \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-xml \
        ca-certificates

RUN     set -eux && \
        apt-get -y install \
        gettext \
        ca-certificates \
        git && \
        cd /usr/share/ && \
        git clone https://git.zabbix.com/scm/zbx/zabbix.git --branch 4.2.4 --depth 1 --single-branch zabbix-4.2.4 && \
        mkdir /usr/share/zabbix/ && \
        cp -R /usr/share/zabbix-4.2.4/frontends/php/* /usr/share/zabbix && \
        rm -rf tests && \
        apt-get -y purge \
        git \
        gettext


WORKDIR /usr/share/zabbix

VOLUME ["/etc/ssl/apache2"]

COPY ["apache.conf", "/etc/zabbix/"]
COPY ["apache_ssl.conf", "/etc/zabbix/"]
COPY ["zabbix.conf.php", "/etc/zabbix/web/"]
COPY ["99-zabbix.ini", "/etc/php/7.2/apache2/conf.d/"]
COPY ["docker-entrypoint.sh", "/usr/bin/"]

EXPOSE 80 443 10051

ENTRYPOINT ["docker-entrypoint.sh"]

