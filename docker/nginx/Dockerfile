FROM phusion/baseimage:master-amd64
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LC_ALL=C.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    BEDROCK_UID=1000 \
    BEDROCK_GUID=1000

#upgrade the OS in the image
RUN apt-get clean \
    && apt-get update \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN apt-get -yf --no-install-recommends install nginx nginx-extras tzdata rsync
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime  \
    && dpkg-reconfigure -f noninteractive tzdata


RUN mkdir -p /etc/service/nginx /run/nginx /var/log/nginx\
    && chown -R  $BEDROCK_GUID:$BEDROCK_GUID /run/nginx \
    && chown -R  $BEDROCK_GUID:$BEDROCK_GUID /var/log/nginx \
    && echo "#!/bin/bash\nnginx -g 'daemon off;'" > /etc/service/nginx/run \
    && chmod +x /etc/service/nginx/run

RUN groupadd -g $BEDROCK_GUID  nginx \
    && useradd -m -s /bin/false -g $BEDROCK_UID nginx \
    && /etc/init.d/nginx stop \
    && update-rc.d -f nginx disable

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh \
    && rm -f /etc/service/sshd/down \
    && openssl dhparam -out /etc/nginx/dhparam.pem 2048
RUN sed -i -e 's|listen \[|#listen \[|g' /etc/nginx/sites-available/default
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
 && find /usr/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \;
ENV BEDROCK_FASTCGI_PASS=127.0.0.1:9000
WORKDIR /var/www/bedrock/web
CMD ["/sbin/my_init"]
EXPOSE 80 443 22
