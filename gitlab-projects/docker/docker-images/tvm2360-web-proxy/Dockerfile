FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'path-include=/usr/share/locale/ru/LC_MESSAGES/*.mo' > /etc/dpkg/dpkg.cfg.d/includes && apt-get update && apt-get install -y apt-utils

RUN apt-get install -y language-pack-ru-base language-pack-ru locales tzdata

RUN locale-gen en_US.UTF-8 && echo 'LC_ALL=en_US.UTF-8' > /etc/default/locale && echo 'LANG=en_US.UTF-8' >> /etc/default/locale

RUN locale-gen ru_RU.UTF-8 && echo 'LC_ALL=ru_RU.UTF-8' >> /etc/default/locale && echo 'LANG=ru_RU.UTF-8' >> /etc/default/locale && echo 'LANGUAGE=ru:en' >> /etc/default/locale

ENV LANG=ru_RU.UTF-8 LANGUAGE=ru:en LC_ALL=ru_RU.UTF-8

RUN update-locale

RUN cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && echo 'Europe/Moscow' > /etc/timezone

RUN apt-get install -y apache2 apache2-utils curl unzip

RUN mkdir -p /var/run/apache2 && mkdir -p /var/lock/apache2 && mkdir -p /var/www/html

RUN chown -R www-data:www-data /var/www/html

ENV APACHE_RUN_USER=www-data

ENV APACHE_RUN_GROUP=www-data

ENV APACHE_LOG_DIR=/var/log/apache2

ENV APACHE_PID_FILE=/var/run/apache2.pid

ENV APACHE_RUN_DIR=/var/run/apache2

ENV APACHE_LOCK_DIR=/var/lock/apache2

COPY ./ports.conf /etc/apache2/ports.conf

COPY ./start-apache.sh /start-apache.sh

RUN a2enmod proxy && a2enmod proxy_http && a2enmod proxy_balancer && a2enmod rewrite

RUN apt-get autoremove -y && apt-get clean && rm -rf /var/cache/apt/archives/* && rm -rf /var/lib/apt/lists/* && rm /etc/apt/sources.list

RUN rm -rf /var/www/html/*

COPY ./www/index.html /var/www/html/index.html

EXPOSE 80

RUN chmod +x /start-apache.sh

CMD ["/start-apache.sh"]
