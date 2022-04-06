ARG TAG="alpine"

FROM php:$TAG as apk
RUN apk add -U autoconf gcc g++ make bash git grep github-cli

FROM apk as ast-builder
WORKDIR /
RUN git clone https://github.com/nikic/php-ast.git && \
	cd /php-ast && \
	phpize && \
	./configure && \
	make && \
	make install && \
	docker-php-ext-enable ast

FROM ast-builder as ast-runner
WORKDIR /ast
COPY . /ast

ENTRYPOINT ["/ast/entrypoint.sh"]
