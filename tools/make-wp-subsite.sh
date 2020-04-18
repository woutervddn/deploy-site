#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
APPCONFSAMPLE="data/nginx/childsite.sample-conf"
searchdomain="example.org"


# GET CONFIG VARS
echo "What is the domainname for the child site"
read domain
APPCONFFILE="data/nginx/sites-enabled/${domain}.conf"

# Make folder and populate
cp -r "${DIR}/../sites/wordpress-sample/" "${DIR}/../sites/${domain}/"

# Launch site
site_container_name="${domain//.}_wordpress_web_1"
phpmyadmin_container_name="${domain//.}_wordpress_phpmyadmin_1"
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
    siteIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $site_container_name)
    sudo "${DIR}/update-hosts.sh" remove $domain
    sudo "${DIR}/update-hosts.sh" add $domain $siteIP

    phpmyadminIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $phpmyadmin_container_name)

    sudo "${DIR}/update-hosts.sh" remove $phpmyadmin_container_name
    sudo "${DIR}/update-hosts.sh" add $phpmyadmin_container_name $phpmyadminIP

    # via standard docker
    #docker run -d --name <name> my-docker-image
else
   echo "${domain} already running, skipping!"
fi

# Add to proxy
cd "${DIR}/../proxy/"
if [ ! -f "$APPCONFFILE" ]; then
    echo "./proxy/$APPCONFFILE does not exist"
    sed "s/${searchdomain}/${domain}/g" $APPCONFSAMPLE > ${APPCONFFILE}
else
    echo "./proxy/$APPCONFFILE already exists, skipping creation of new one!"
fi

# Reload proxy
cd "${DIR}/../proxy/"
./init-letsencrypt.sh $domain
#docker-compose up -d
