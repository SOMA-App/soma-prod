# soma-prod

soma-prod cria uma imagem para contêiner Docker com Java JDK 8, 
Apache Tomcat8 sobre o Alpine Linux

Este projeto foi testado com a versão 1.8.2 do Docker

## Alpine

O Alpine usa o Apk como **package manager**

Exemplo de comando:

    apk update

Showing available updates. Show what packages that have an update available:

    apk version -v # equivalente a "aptitude upgrade --simulate" do Debian

Update a particular package

    apk add -u package1 package2 # equivalente do Debian : aptitude install package1 package2

Installing packages

    apk add package1 package2 # equivalente do Debian: apt-get install package1 package2

Searching package database

Alpine will only search package names.

    apk search searchword # equivalente do Debian: apt-cache search searchword

### Network

Alpine uses /etc/network/interfaces, just like Debian. The main reason is because 
this is the way busybox does it.

Arquivo /etc/network/interfaces:

    auto eth0
    iface eth0 inet static
     address 192.168.0.1
     netmask 255.255.255.0
     broadcast 192.168.0.255
     
    auto eth0:0
    iface eth0:0 inet static
     address 192.168.1.1
     netmask 255.255.255.0
     broadcast 192.168.1.255
    # etc.


## Docker

Reiniciando o Boot2Docker

    boot2docker stop
    boot2docker start

## Fazendo o build e criando a imagem

Execute no Terminal

    cd soma-prod/

### Contêiner Maria DB

    cd doc/mariadb
    ./build-mariadb
    docker images | grep mariadb
    cd ../..

### Contêiner Alpine com Java 8

    cd doc/original
    ./build-alpine-java
    docker images | grep alpine-java
    cd ../..

### Contêiner SOMA para produção

    docker build -t HUB-USER-NAME/soma-prod  .

Substitua o token `HUB-USER-NAME` pelo seu login em [http://hub.docker.com](http://hub.docker.com)

Após o build podemos inspecionar os layers da imagem gerada usando o comando `dockviz images -t`.

Verificando

    docker images | grep soma-prod

Para executar interativamente uma shell use:

    docker run -i -t --rm --name soma_prod --dns 192.168.1.254 -p 1443:1443 HUB-USER-NAME/soma-prod /bin/bash

Para executar:

    docker run -d --name mysql_db -p 9306:3306 parana/mysql
    docker run --name soma_prod --link mysql_db:mysql -p 1443:1443 -d HUB-USER-NAME/soma-prod
    open http://dockerhost.local:1443/mxml/soma.jsp

Em outro aba de Terminal execute

    docker exec -i-t mysql_db /bin/bash

Em mais outro aba de Terminal execute

    docker exec -i-t soma_prod /bin/bash

Váriáveis de ambiente:

    MYSQL_DATABASE
    MYSQL_USER
    MYSQL_PASSWORD

Contêiner mysql

    CREATE DATABASE: my-db 
    CREATE USER: wp
    IDENTIFIED BY: secret


## Passo a passo da configuração
