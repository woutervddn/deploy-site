#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# GET CONFIG VARS
echo "What is the domainname for the child site"
read domain
site_container_name="${domain//.}_wordpress_phpmyadmin_1"

sudo "${DIR}/update-hosts.sh" remove $site_container_name
docker stop $site_container_name

# Reload proxy
cd "${DIR}/../proxy/"
docker-compose up -d

