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

echo "STEP 1 OF 2 | Pulling docker image." && sudo docker pull ryansch/unifi-rpi:latest && echo "STEP 1 SUCCESS" || error "Failed to pull latest Portainer docker image!"
echo "STEP 2 OF 2 | Running docker up CLI." && sudo docker run -d --network host --name=unifi --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v config:/var/lib/unifi -v log:/usr/lib/unifi/logs -v log2:/var/log/unifi -v run:/usr/lib/unifi/run -v run2:/run/unifi -v work:/usr/lib/unifi/work ryansch/unifi-rpi:latest && echo "STEP 2 SUCCESS" || error "Failed to execute newer version of Portainer!"
