.PHONY: dev prod down perm build_php build_nginx
all: perm build_php build_nginx
perm:
	cd $(pwd);
	find ./docker -type f  ! -iname "Makefile"  -exec head -1 {} /dev/null \;  | awk '/^#!\// { print file } { file = $$0 } ' | awk '{print $$2}'| xargs -r chmod +x;
dev:down;
	docker-compose -f development.yml up -d;
prod:down;
	docker-compose -f production.yml up -d;
down:perm;
	docker-compose -f development.yml down;
	echo "y" | docker volume prune;
build_php:
	cd ./docker/php && docker build  -t a2media/bedrock:php .
build_nginx:
	cd ./docker/nginx && docker build  -t a2media/bedrock:nginx .
