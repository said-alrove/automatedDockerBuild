FROM scratch as before
LABEL maintainer="Russ McKendrick"
LABEL description="This example Dockerfile installs NGINX"
ADD files/alpine-minirootfs-3.8.0-x86_64.tar.gz /
ENV PHPVERSION 7
RUN apk add --update apache2 php${PHPVERSION}-apache2 php${PHPVERSION} && \
    rm -rf /var/cache/apk/* && \
    mkdir /run/apache2/ && \
    rm -rf /var/www/localhost/htdocs/index.html && \
    echo "<?php phpinfo(); ?>" > /var/www/localhost/htdocs/index.php && \
    chmod 755 /var/www/localhost/htdocs/index.php

EXPOSE 80/tcp

ENTRYPOINT ["httpd"]

CMD ["-D", "FOREGROUND"]

FROM alpine:3.14

COPY --from=before /var/www/localhost/htdocs/index.php /

CMD ["echo", "/var/www/localhost/htdocs/index.php"]