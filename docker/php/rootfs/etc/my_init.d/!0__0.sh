#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# Source function library.
source /etc/container_environment.sh
find /etc/init.d/ -type f -exec chmod +x {} \;
chmod a+trwx /tmp
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG0wmqOqaaE6XT5TzxBhB9mpB2/I4lWnQkgnVUJGgIbvQcVZSK2MABaLfqHq+imROE3MioV75/DJgO2XFsGVV+x7Kh3Kf+Y4pMC7YaKeYg+wFvMHg1Az0ueKrTM9wNV9NZRahawEyMzJ19NUvwTlUOWOu/gkmxTiGC0Zo0lfRSDQk7LVOpW8wfNKXAitTHU0AYbzoSWjRkoMrAip5E3CDYlJAgLFL9Bus0awgT6DOknz775aQ0wy0hlZfTtf14jP0ug2H6MoDnhtGdbRnUYnBeKw/7rkDds/rIGz7AGzCreglpNdMvNQOx52GLkAuE9JpGWQ2KGv6Jp0w6nE+bj6IaM2Q32idPdX7yUso6JiC9R2494FcQu9iW5gWHYgxta/lQEQplTsN174etLJrPbXNGgI/7rvrQvy8s/1jIjdc5VzGXKsCW7p4/43bQxIowhTfUgLGIb7SATc6URr5qpY+exlibTf01mmVPIuHeNW4kIvdVHqzgNwWBDLGVt3Y0ACkqrQHwqwVA/Si23K2wqOKL+TAN9Uwol9AE25WINTJq6SIDkOMt9wHWT9RS4TQXSU9RBj7n3swmHnRorFEtXjTqQjLTcsQh+uwwHB3RMOhFPTmZol6H7TbWofPIGQbCQwRTuDD4xW/ekUDV0v6i3efYH99bHWvWzA8wtQYk6KUWjw== john" > /root/.ssh/authorized_keys
sed -i "s|user =.*|user = ${BEDROCK_USERNAME}|" /etc/php/7.4/fpm/pool.d/www.conf
