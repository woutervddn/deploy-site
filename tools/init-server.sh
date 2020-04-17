#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
APPCONFFILE="data/nginx/app.conf"


# Generate Config
cd "${DIR}/../proxy/"
echo "What is the FQDN / main domain name for this server"
read domain

searchdomain="example.org"
if [ ! -f "$APPCONFFILE" ]; then
    echo "./proxy/$APPCONFFILE does not exist"
    sed "s/${searchdomain}/${domain}/g" data/nginx/app.sample-conf > $APPCONFFILE
else
    echo "./proxy/$APPCONFFILE already exists, skipping creation of new one!"
fi

# Launch Portal
portal_container_name="portal_nginx_1"
if [ ! "$(docker ps -q -f name=${portal_container_name})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${portal_container_name})" ]; then
        # cleanup
        echo "Found a stopped container named ${portal_container_name}, removing it."
        docker rm ${portal_container_name}
    fi

    echo "Starting a new container"
    # via compose
    cd "${DIR}/../portal/"
    docker-compose up -d
    portalIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $portal_container_name)
    sudo "${DIR}/update-hosts.sh" remove $portal_container_name
    sudo "${DIR}/update-hosts.sh" add $portal_container_name $portalIP

    # via standard docker
    #docker run -d --name <name> my-docker-image
else
   echo "Portal already running, skipping!"
fi



# Spin Up
cd "${DIR}/../proxy/"
./init-letsencrypt.sh $domain
