#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#STOP PROXY
echo "DOWNING PROXY"
cd "${DIR}/../proxy/"
docker-compose down


#STOP PORTAL
echo "DOWNING PORTAL"
cd "${DIR}/../portal/"
docker-compose down

#STOP ALL SITES
for d in ${DIR}/../sites/*/ ; do
    cd "$d"
    domain=$(basename $(pwd))
    echo "DOWNING $domain"
    docker-compose down

    portal_container_name="${domain//.}_nginx_1"
    sudo "${DIR}/update-hosts.sh" remove $domain
    portal_container_name="${domain//.}_wordpress_web_1"
    sudo "${DIR}/update-hosts.sh" remove $domain
    phpmyadmin_container_name="${domain//.}_wordpress_phpmyadmin_1"
    sudo "${DIR}/update-hosts.sh" remove $phpmyadmin_container_name


done
