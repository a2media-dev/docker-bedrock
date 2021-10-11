FROM phusion/baseimage:master-amd64
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LC_ALL=C.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    BEDROCK_USERNAME=bedrock \
    BEDROCK_GROUP=bedrock \
    BEDROCK_UID=1000 \
    BEDROCK_GUID=1000

#upgrade the OS in the image
RUN apt-get clean \
    && apt-get update \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN apt-get -yf --no-install-recommends install apt-transport-https ca-certificates libcurl4 libcurl4-openssl-dev \
    curl less wget software-properties-common tzdata rsync  gnupg gpg incron systemd gcc g++ make build-essential
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime  \
    && dpkg-reconfigure -f noninteractive tzdata
#php
RUN cd /tmp \
    && apt-add-repository -y ppa:ondrej/php \
    && apt-get update && apt-get -yf  --no-install-recommends upgrade\
    && apt-get -y --no-install-recommends --allow-unauthenticated install libmcrypt-dev zlib1g-dev libzip-dev php-pear php-xml php7.4 php7.4-dev php7.4-xml \
    && dpkg --configure -a \
    && pecl channel-update pecl.php.net \
    #wp-cli
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    &&  php wp-cli.phar --info \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    #composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer
#php-module
RUN apt-get install -yq php7.4-mbstring php7.4-cgi php7.4-cli php7.4-dev php7.4-geoip php7.4-common php7.4-xmlrpc php7.4-sybase php7.4-curl \
        php7.4-enchant php7.4-imap php7.4-xsl php7.4-mysql php7.4-mysqli php7.4-mysqlnd php7.4-pspell php7.4-gd php7.4-zip \
        php7.4-tidy php7.4-opcache php7.4-json php7.4-bz2 php7.4-pgsql php7.4-readline php7.4-imagick php7.4-phar \
        php7.4-intl php7.4-sqlite3 php7.4-ldap php7.4-xml php7.4-redis php7.4-fpm \
        php7.4-soap php7.4-bcmath php7.4-fileinfo php7.4-xdebug php7.4-exif php7.4-tokenizer php7.4-psr php7.4-phalcon4 php7.4-apcu \
        php7.4-memcached php7.4-memcache php7.4-swoole
RUN apt-get install -yq memcached nano zip gzip
RUN groupadd -g $BEDROCK_GUID  $BEDROCK_USERNAME \
    && useradd -m -s /bin/false -g $BEDROCK_GUID $BEDROCK_USERNAME

RUN mkdir /etc/service/php /run/php /var/log/php\
    && chown -R  $BEDROCK_UID:$BEDROCK_GUID /run/php \
    && chown -R  $BEDROCK_UID:$BEDROCK_GUID /var/log/php \
    && echo "#!/bin/bash\nphp-fpm7.4 -c /etc/php/7.4/fpm" > /etc/service/php/run \
    && chmod +x /etc/service/php/run

# Configure PHP
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathi nfo=0/"                 /etc/php/7.4/fpm/php.ini && \
		sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g"                 /etc/php/7.4/fpm/php-fpm.conf  && \
		sed -i "s|post_max_size =.*|post_max_size = 55M|" /etc/php/7.4/fpm/php.ini && \
		sed -i "s|upload_max_filesize =.*|upload_max_filesize = 55M|" /etc/php/7.4/fpm/php.ini && \
		sed -i "s|max_file_uploads =.*|max_file_uploads = 3|" /etc/php/7.4/fpm/php.ini && \
		sed -i "s|memory_limit =.*|memory_limit = 512M|" /etc/php/7.4/fpm/php.ini && \
		sed -i "s|user =.*|user = ${BEDROCK_USERNAME}|" /etc/php/7.4/fpm/pool.d/www.conf  && \
		sed -i "s|owner =.*|owner = ${BEDROCK_USERNAME}|" /etc/php/7.4/fpm/pool.d/www.conf  && \
		sed -i "s|group =.*|group = ${BEDROCK_GROUP}|" /etc/php/7.4/fpm/pool.d/www.conf && \
		sed -i -e "s|^;chdir =.*|chdir = /var/www/|g" /etc/php/7.4/fpm/pool.d/www.conf && \
		sed -i -e "s|^;access.log =.*|access.log = /var/log/php/\$pool.access.log|g" /etc/php/7.4/fpm/pool.d/www.conf && \
		sed -i -e "s|^pm.max_children =.*|pm.max_children = 250|g" /etc/php/7.4/fpm/pool.d/www.conf && \
		sed -i -e "s|^pm.start_servers =.*|pm.start_servers = 8|g" /etc/php/7.4/fpm/pool.d/www.conf && \
		sed -i -e "s|^pm.min_spare_servers =.*|pm.min_spare_servers = 5|g" /etc/php/7.4/fpm/pool.d/www.conf && \
		sed -i -e "s|^pm.max_spare_servers =.*|pm.max_spare_servers = 50|g" /etc/php/7.4/fpm/pool.d/www.conf && \
		sed -i -e "s|;listen.mode =.*|listen.mode = 0750|g" /etc/php/7.4/fpm/pool.d/www.conf && \
        sed -i -e 's|^listen =.*|listen = 0.0.0.0:9000|g' /etc/php/7.4/fpm/pool.d/www.conf && \
		sed -i -e 's|^listen.allowed_clients|;listen.allowed_clients|g' /etc/php/7.4/fpm/pool.d/www.conf

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh \
    && rm -f /etc/service/sshd/down

RUN mkdir -p /var/www/x-prober \
        && curl -SL https://github.com/kmvan/x-prober/releases/latest/download/prober.php --output /var/www/x-prober/index.php \
        && chown -R ${BEDROCK_UID}:${BEDROCK_GUID} /var/www/x-prober


ENV WP_ROOT=/var/www/bedrock/web\
    WP_CLI_ALLOW_ROOT=True\
    COMPOSER_ALLOW_SUPERUSER=1
COPY rootfs/. /tmp/rootfs
RUN find /tmp/rootfs -type f -exec head -1 {} /dev/null  | awk '/^#!\// { print file } { file = $$0 } ' | awk '{print $$2}'| xargs -r chmod +x \
 && rsync -K -a /tmp/rootfs/ / \
 && rm -rf  /tmp/rootfs \
 && chmod 1777 /tmp \
 && apt-get  -y update\
 && apt-get  -y clean\
 && apt-get -y autoremove \
 && unset DEBIAN_FRONTEND\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/{,.[!.],..?}* \
 && rm -rf /tmp/{,.[!.],..?}* \
 && rm -rf /var/tmp/{,.[!.],..?}* \
 && find /usr/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; \
 && php-switch "7.4"

RUN PHP_MODULE_PATH=$(php-config --extension-dir) \
  && cd /tmp \
  && wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
  && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
  && cp ioncube/ioncube_loader_lin_7.4.so $PHP_MODULE_PATH \
  && cp ioncube/ioncube_loader_lin_7.4_ts.so $PHP_MODULE_PATH \
  && echo "zend_extension=ioncube_loader_lin_7.4.so" > /etc/php/7.4/mods-available/ioncube.ini \
  && for pm in cli cgi fpm apache2; do  ln -sf /etc/php/7.4/mods-available/ioncube.ini /etc/php/7.4/$pm/conf.d/01-ioncube.ini; done;

RUN mkdir -p /var/www/bedrock \
    && cd /var/www/bedrock \
    && composer create-project roots/bedrock . \
    && composer require  oscarotero/env wpackagist-plugin/query-monitor wpackagist-plugin/debug-bar-rewrite-rules wpackagist-plugin/wp-tasks-after-install\
    wpackagist-plugin/woocommerce wpackagist-plugin/advanced-cron-manager wpackagist-plugin/all-in-one-wp-migration \
    wpackagist-plugin/multisite-enhancements roots/multisite-url-fixer \
    && composer update --prefer-dist \
    && bedrock-fix-perm

WORKDIR /var/www/bedrock
VOLUME ["/var/www/bedrock","/var/www/x-prober"]
CMD ["/sbin/my_init"]
EXPOSE 9000 22
