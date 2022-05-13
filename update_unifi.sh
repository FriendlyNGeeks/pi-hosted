#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

function check_internet() {
  printf "Checking if you are online..."
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo "Online. Continuing."
  else
    error "Offline. Go connect to the internet then run the script again."
  fi
}

check_internet

unifi_pid=`docker ps | grep unifi-rpi | awk '{print $1}'`
unifi_name=`docker ps | grep unifi-rpi | awk '{print $2}'`

sudo docker stop $unifi_pid || error "Failed to stop unifi!"
sudo docker rm $unifi_pid || error "Failed to remove unifi container!"
sudo docker rmi $unifi_name || error "Failed to remove/untag images from the container!"
sudo docker run -d -p 8080:8443 --name=unifi --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v config:/var/lib/unifi -v log:/usr/lib/unifi/logs -v log2:/var/log/unifi -v run:/usr/lib/unifi/run -v run2:/run/unifi -v work:/usr/lib/unifi/work ryansch/unifi-rpi:latest || error "Failed to execute newer version of Portainer!"
