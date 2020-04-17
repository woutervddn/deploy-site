#! /bin/sh
# @author: Claus Witt
# http://clauswitt.com/319.html
# Got this file from: https://gist.github.com/bzerangue/4393408
# Addapted it to remove without a matched IP
# Adding or Removing Items to hosts file
# Use -h flag for help

DEFAULT_IP=127.0.0.1
IP=${3:-$DEFAULT_IP}

case "$1" in
  add)
        echo "$IP $2"  >> /etc/hosts
        ;;
  remove)
        sed -ie "\| $2\$|d" /etc/hosts
        ;;

  *)
        echo "Usage: "
        echo "hosts.sh [add|remove] [hostname] [ip]"
        echo 
        echo "Ip defaults to 127.0.0.1"
        echo "Examples:"
        echo "hosts.sh add testing.com"
        echo "hosts.sh remove testing.com 192.168.1.1"
        exit 1
        ;;
esac

exit 0
