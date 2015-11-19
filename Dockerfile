FROM anapsix/alpine-java:jdk8
#
# Esta imagem da qual herdo as funcionalidades inclui Java JDK 8 da Oracle,
# e glibc-2.21. Sobre ela instalo o Bash e o Tomcat 8
#
# https://github.com/anapsix/docker-alpine-java/tree/master/8/jdk
#
MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2015-11-18
RUN apk add --update bash && \
    apk search gpg && \
    apk add gpgme && \
    apk add lsof logrotate && \
    rm -rf /var/cache/apk/*

# # RUN apk add supervisor

# Install tomcat8
ENV CATALINA_HOME     /usr/local/tomcat
ENV CATALINA_BASE     /usr/local/tomcat
ENV SOMA_HOME         /usr/local/soma

ENV PATH  ~/bin:$CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME" && \
    mkdir -p "$SOMA_HOME" && \
    mkdir -p "$SOMA_HOME/logs" && \
    mkdir -p "$SOMA_HOME/setup"

# RUN mkdir -p /var/cache/apk && \
#     ln -s /var/cache/apk /etc/apk/cache


# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
  05AB33110949707C93A279E3D3EFE6B686867BA6 \
  07E48665A34DCAFAE522E5E6266191C37C037D42 \
  47309207D818FFD8DCD3F83F1931D684307A10A5 \
  541FBE7D8F78B25E055DDEE13C370389288584E7 \
  61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
  79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
  9BA44C2621385CB966EBA586F72C284D731FABEE \
  A27677289986DB50844682F8ACB77FC2E86E29AC \
  A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
  DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
  F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
  F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.28
# ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
ENV TOMCAT_TGZ_URL http://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

WORKDIR $CATALINA_HOME

RUN set -x \
  && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
  && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc

RUN gpg --verify tomcat.tar.gz.asc

RUN tar -xvf tomcat.tar.gz --strip-components=1 \
  && rm bin/*.bat \
  && rm tomcat.tar.gz*

# On Debian I need Update distro and install some packages
# RUN apt-get update && \
#     apt-get install locales -y && \
#     update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
#     locale-gen en_US.UTF-8 && \
#     dpkg-reconfigure locales && \
#     rm -rf /var/lib/apt/lists/*

RUN mkdir $CATALINA_HOME/shared

# Tomcat 8 Default port 8080 conflits with Apex
RUN sed -i -E "s/8080/1443/g" $CATALINA_HOME/conf/server.xml
# ADD tomcat/conf/server.xml $CATALINA_HOME/conf/server.xml
# RUN grep Listener $CATALINA_HOME/conf/server.xml
RUN echo '---- cat $CATALINA_HOME/conf/server.xml  ----' && \
    cat $CATALINA_HOME/conf/server.xml | grep 1443

ADD db-provision.sh $SOMA_HOME/setup/db-provision.sh
WORKDIR $SOMA_HOME/setup
# RUN $SOMA_HOME/setup/db-provision.sh

WORKDIR $CATALINA_HOME
# LCDS RTMP channel
EXPOSE 2037
# Tomcat web container
EXPOSE 1443

RUN echo 'É  necessário executar esse contêiner assim : docker run -d -h db-server -v ~/dev/shared:/usr/local/tomcat/shared  ... ' && \
    echo '' && \
    echo '*** ATENÇÃO: Na primeira vez que executar este contêiner execute o comando abaixo após o Oracle estar UP ' && \
    echo 'docker exec  mytomcat sqlplus sys/oracle@XE as sysdba @/usr/local/soma/setup/ora-01.sql' && \
    echo '# Estamos supondo o nome do contêiner igual a mytomcat' && \
    echo '***' && \
    echo 'NÃO ESQUEÇA DE TROCAR A SENHA DO USER SYS E SYSTEM !' && \
    echo '***'

RUN echo "Europe/London" > /etc/timezone
RUN ls -lat /etc
RUN cat /etc/timezone

# CMD ["sh", "/bin/start-xe-and-jee.sh", "Iniciando"]

EXPOSE 8080
# CMD ["catalina.sh", "run"]
CMD ["/bin/bash"]
