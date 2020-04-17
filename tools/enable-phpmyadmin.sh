#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# GET CONFIG VARS
echo "What is the domainname for the child site"
read domain
site_container_name="${domain//.}_wordpress_phpmyadmin_1"

docker start $site_container_name
phpmyadminIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $site_container_name)

sudo "${DIR}/update-hosts.sh" remove $site_container_name
sudo "${DIR}/update-hosts.sh" add $site_container_name $phpmyadminIP

# Reload proxy
cd "${DIR}/../proxy/"
docker-compose up -d

