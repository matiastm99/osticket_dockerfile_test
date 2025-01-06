FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y
RUN apt install -y vim wget unzip apache2 mariadb-server php \
                libapache2-mod-php php-mysql php-cgi php-fpm php-cli php-curl \
                php-gd php-imap php-mbstring php-pear php-intl php-apcu php-common php-bcmath

RUN mkdir /var/www/html/osticket

RUN wget https://github.com/osTicket/osTicket/releases/download/v1.18.1/osTicket-v1.18.1.zip && \
        unzip osTicket-v1.18.1.zip -d /var/www/html/osticket && \
        rm osTicket-v1.18.1.zip

RUN chown -R www-data:www-data /var/www/html/osticket && chmod -R 755 /var/www/html/osticket

RUN mv /var/www/html/osticket/upload/include/ost-sampleconfig.php /var/www/html/osticket/upload/include/ost-config.php

RUN echo "<VirtualHost *:80>\n\
        ServerName localhost\n\
        ServerAdmin admin@localhost\n\
        DocumentRoot /var/www/html/osticket/upload\n\
\n\
        <Directory /var/www/html/osticket/upload>\n\
                Require all granted\n\
                Options FollowSymlinks\n\
                AllowOverride All\n\
        </Directory>\n\
\n\
        ErrorLog ${APACHE_LOG_DIR}/osticket.error.log\n\
        CustomLog ${APACHE_LOG_DIR}/osticket.access.log combined\n\
</VirtualHost>" > /etc/apache2/sites-available/osticket.conf

RUN a2ensite osticket.conf && a2enmod rewrite

RUN cd /var/www/html/osticket/upload/