FROM debian:latest
LABEL version="0.1"
MAINTAINER veto<veto@myridia.com>
RUN apt-get update && apt-get install -y \
  apache2 \
  apt-transport-https \ 
  lsb-release \
  ca-certificates \
  curl \
  wget \	      
  apt-utils \
  openssh-server \
  supervisor \
  default-mysql-client \
  libpcre3-dev \
  gcc \
  make \
  emacs-nox \ 
  vim \ 
  git \
  gnupg \
  sqlite3 \
  unzip \
  p7zip-full \
  postgresql-client \
  inetutils-ping  \
  net-tools


RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ bookworm main" | tee /etc/apt/sources.list.d/php.list
RUN cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/ 

RUN apt-get update && apt-get install -y \
  php8.3 \
  php8.3-xml \
  php8.3-cgi  \
  php8.3-mysql  \
  php8.3-mbstring \
  php8.3-gd \
  php8.3-curl \
  php8.3-zip \
  php8.3-dev \
  php8.3-sqlite3 \ 
  php8.3-ldap \
  php8.3-sybase \ 
  php8.3-pgsql \
  php8.3-soap \
  libapache2-mod-php8.3 \
  php-pear 


#RUN pear install mail \
#pear upgrade MAIL Net_SMTP 


RUN echo "<?php phpinfo() ?>" > /var/www/html/index.php ; \
mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor ; \
a2enmod rewrite  ;\
sed -i -e '/memory_limit =/ s/= .*/= 2056M/' /etc/php/8.3/apache2/php.ini ; \
sed -i -e '/post_max_size =/ s/= .*/= 800M/' /etc/php/8.3/apache2/php.ini ; \
sed -i -e '/max_file_uploads =/ s/= .*/= 200/' /etc/php/8.3/apache2/php.ini ; \
sed -i -e '/upload_max_filesize =/ s/= .*/= 800M/' /etc/php/8.3/apache2/php.ini ; \
sed -i -e '/display_errors =/ s/= .*/= ON/' /etc/php/8.3/apache2/php.ini ; \
sed -i -e '/short_open_tag =/ s/= .*/= ON/' /etc/php/8.3/apache2/php.ini ; \
sed -i -e '/short_open_tag =/ s/= .*/= ON/' /etc/php/8.3/cli/php.ini ; \
sed -i -e '/AllowOverride / s/ .*/ All/' /etc/apache2/apache2.conf ; \
sed -i -e '/max_execution_time =/ s/= .*/= 1200/' /etc/php/8.3/apache2/php.ini ; \
echo 'open_basedir = "/"' >> /etc/php/8.3/apache2/php.ini ; 


RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin 
RUN ln  -s /usr/bin/composer.phar /usr/bin/composer 

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 80
CMD ["/usr/bin/supervisord"]


