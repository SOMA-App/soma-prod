#!/bin/bash

set -e

MYSQL_ROOT_PASSWORD=$1

if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    MYSQL_ROOT_PASSWORD='xpto'
fi

HUB_USER_NAME=$2

if [ -z "$HUB_USER_NAME" ]; then
    HUB_USER_NAME='parana'
fi

echo "••• `date` - MYSQL_ROOT_PASSWORD = $MYSQL_ROOT_PASSWORD | HUB_USER_NAME = $HUB_USER_NAME"

docker run -d --name mysql_db -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -p 9306:3306 mariadb
echo "••• `date` - Aguardando o MySQL Iniciar"
sleep 15
echo "••• `date` - Iniciando o Tomcat 8"
docker run --name soma_prod --link mysql_db:mysql \
       -p 1443:1443 -d $HUB_USER_NAME/soma-prod  catalina.sh run

echo "••• `date` - Você pode invocar o Browser assim:"
echo "••• `date` - Usando o endereço IP do Boot2Docker"
echo "••• `date` - open http://192.168.59.103:1443"
echo "••• `date` - Usando simbolo para nome do Host cadastrado em /etc/hosts."
echo "••• `date` - open http://dockerhost.local:1443"
