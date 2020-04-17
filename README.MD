# Docker Compose Wordpress Host

Looking for an easier way to get wordpress websites up and running in a production environment.
The idea is that this would live on a barebones ubuntu-server and would spin up new wordpress sites in no time

Features:
- Docker-compose to spin up new wordpress sites ✔️ 
- Nginx reverse proxy to handle multiple wordpress sites ✔️ 
- SSL with Lets Encrypt ✔️ 
- Mysql - MariaDB ✔️ 
- PhpMyAdmin as a toggle to get access when needed but don't expose it unneccesarily ✔️ 
- Easy upgradability & backup 

Optional features:
- Maybe a simple cli for management

## Prerequisites

You need the following packages installed:

- docker
- docker-compose
- git

## Installation

- Point your prefered domain to the IP of your server
- First clone this repo: `git clone https://github.com/woutervddn/deploy-site.git`
- Then `cd deploy-site` and `./tools/init-server.sh`
- Check if you see the empty "silence is golden" portal on your hostname

## Test usage

Set up an empty static website to check if everything works

- Point a second domain to the IP of  your server
- `cd deploy-site` into the directory (if you're not there already)
- Use `./tools/make-static-subsite.sh` to generate a static site
- Check if you see another empty site on the new hostname (different background color should appear)

## Setup a Wordpress site

- Point the right domain to the IP of  your server
- `cd deploy-site` into the directory (if you're not there already)
- Use `./tools/make-wp-subsite.sh` to generate a static site
- Check if you see if wordpress is available on the new hostname

## Enable PHPMyadmin
- ssh into your server with portforwarding: `ssh -C -D 1080 PRIMARY_HOSTNAME`
- setup a socks proxy on your host using `127.0.0.1:1080`
- on the server `cd deploy-site` into the directory (if you're not there already)
- Use `./tools/enable-phpmyadmin.sh` to enable phpmyadmin
- paste the final output of the previous script in your browser

Disabling PHPMyadmin is as simple as `./tools/disable-phpmyadmin.sh`

## Wind down everything
Want do disable everything?

use `./tools/stop-all.sh` to stop every docker container launched from here.

## Updating a single site

- cd to the right folder: `cd sites/DOMAIN`
- now run `docker-compose up -d` to restart all containers





