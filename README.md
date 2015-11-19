# soma-prod

soma-prod cria uma imagem para contêiner Docker com Java JDK 8, 
Apache Tomcat8 sobre o Alpine Linux

Este projeto foi testado com a versão 1.8.2 do Docker

Reiniciando o Boot2Docker

    boot2docker stop
    boot2docker start

## Fazendo o build e criando a imagem

### Alpine com Java 8

    cd soma-prod/doc/original
    ./build-alpine-java
    docker images | grep alpine-java
    cd ../..

### SOMA para produção

    docker build -t HUB-USER-NAME/soma-prod  .

Substitua o token `HUB-USER-NAME` pelo seu login em [http://hub.docker.com](http://hub.docker.com)

Após o build podemos inspecionar os layers da imagem gerada usando o comando `dockviz images -t`.

Verificando

    docker images | grep soma-prod

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
