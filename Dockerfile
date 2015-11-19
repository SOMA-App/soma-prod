FROM anapsix/alpine-java:jdk8
#
# Esta imagem da qual herdo as funcionalidades inclui Java JDK 8 da Oracle,
# e glibc-2.21. Sobre ela instalo o Bash e o Tomcat 8
#
# https://github.com/anapsix/docker-alpine-java/tree/master/8/jdk
#
MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2015-11-18
RUN apk add --update bash && rm -rf /var/cache/apk/*
CMD ["/bin/bash"]

