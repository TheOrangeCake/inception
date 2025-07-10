# syntax=docker/dockerfile:1

# the base image for linux alpine. The lastest stable is 3.22
FROM alpine:3.21

# install dependencies
RUN apk update && apk add nginx

# copy conf files
COPY ./conf/*