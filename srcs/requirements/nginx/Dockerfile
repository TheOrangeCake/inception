# syntax=docker/dockerfile:1

# the base image for linux alpine.
FROM alpine:3.21

# install nginx
RUN apk update && apk add nginx
RUN apk add curl
RUN mkdir inception

# install openssl for TLS security certificate and generate certificate
RUN apk add openssl
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=CH/L=Geneva/O=42/CN=hoannguy.42.fr/UID=hoannguy" 

# copy nginx config file
COPY /conf/nginx.conf /etc/nginx/nginx.conf
COPY index.html /inception

EXPOSE 443
# change permission and owner for wordpress root
# RUN chmod 755 /var/www/html
# RUN chown -R www-data:www-data /var/www/html

# run nginx
CMD ["nginx", "-g", "daemon off;"]