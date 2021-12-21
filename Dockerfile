FROM ubuntu:latest AS builder 
RUN apt-get update && \
    apt-get install mariadb-plugin-connect -y && \
    rm -rf /var/lib/apt/lists/* && \ 
    apt-get install -y  mariadb-server  php-cli 
ENV MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=yes \
    MARIADB_DATABASE=test-db \
    MARIADB_USER=aakash \
    MARIADB_PASSWORD=passwd
RUN systemctl enable now mariadb
WORKDIR /usr/local/apache2/htdocs
COPY ./wordpress/* .

FROM httpd:alpine AS production
WORKDIR /usr/local/apache2/htdocs
COPY --from=builder /usr/local/apache2/htdocs .
