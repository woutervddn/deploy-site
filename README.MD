# Docker Compose Wordpress Host

Looking for an easier way to get wordpress websites up and running in a production environment.
The idea is that this would live on a barebones ubuntu-server and would spin up new wordpress sites in no time

Features:
- Docker-compose to spin up new wordpress sites
- Nginx reverse proxy to handle multiple wordpress sites
- SSL with Lets Encrypt
- Mysql
- PhpMyAdmin as a toggle to get access when needed but don't expose it unneccesarily
- Easy upgradability & backup

Optional features:
- Maybe a simple cli for management
