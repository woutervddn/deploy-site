#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
APPCONFSAMPLE="data/nginx/childsite.sample-conf"
searchdomain="example.org"


# GET CONFIG VARS
echo "What is the domainname for the child site"
read domain
APPCONFFILE="data/nginx/sites-enabled/${domain}.conf"

# Make folder and populate
cp -r "${DIR}/../sites/static-sample/" "${DIR}/../sites/${domain}/"

# Launch site
site_container_name="${domain//.}_nginx_1"
if [ ! "$(docker ps -q -f name=${site_container_name})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${site_container_name})" ]; then
        # cleanup
        echo "Found a stopped container named ${site_container_name}, removing it."
        docker rm ${site_container_name}
    fi

    echo "Starting a new container"
    # via compose
    cd "${DIR}/../sites/${domain}/"
    docker-compose up -d
    portalIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $site_container_name)
    sudo "${DIR}/update-hosts.sh" remove $site_container_name
    sudo "${DIR}/update-hosts.sh" add $site_container_name $portalIP

    # via standard docker
    #docker run -d --name <name> my-docker-image
else
   echo "${domain} already running, skipping!"
fi

# Add to proxy
cd "${DIR}/../proxy/"
if [ ! -f "$APPCONFFILE" ]; then
    echo "./proxy/$APPCONFFILE does not exist"
    sed "s/${searchdomain}/${domain}/g" $APPCONFSAMPLE > ${APPCONFFILE}.tmp
    sed "s/docker_host_web/${site_container_name}/g" ${APPCONFFILE}.tmp > $APPCONFFILE
    rm ${APPCONFFILE}.tmp
else
    echo "./proxy/$APPCONFFILE already exists, skipping creation of new one!"
fi

# Reload proxy
cd "${DIR}/../proxy/"
docker-compose up -d
