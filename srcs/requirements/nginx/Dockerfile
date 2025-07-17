# syntax=docker/dockerfile:1

# the base image for linux alpine. The lastest stable is 3.22
FROM alpine:3.21

WORKDIR /nginx

# install dependencies
RUN apk update && apk add nginx

# # copy conf files
COPY test.html /usr/share/nginx/html/test.html

# EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]