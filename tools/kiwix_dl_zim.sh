#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

function prompt_fields() {

    while true; do
        echo -n "Enter a name for the dl ZIM file (mywikie.zim):"
        read zimName
        if [ "$zimName" != "" || "$zimName" != " " || "$zimName" != undefine ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
            echo "Filename set to: $zimNAME";
        else
            echo "Please enter a valid file name!"
        fi
    done

    while true; do
        echo -n "Enter the URL for the dl ZIM file (https://zim-r-us/mywikie.zim):"
        read zimURL
        if [ "$zimURL" != "" || "$zimURL" != " " || "$zimURL" != undefine ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
            wget -q --spider $zimURL
            if [ $? -eq 0 ]; then
                echo "URL set to: $zimURL";
            else
                echo "No ZIM file found at: $zimURL"
        else
            echo "Please enter a valid url!"
        fi
    done

    sudo wget -O /tmp/zim/$zimName $zimURL || error "Failed to download file!";
    while true; do
        read -p "Would you like to download another ZIM to use in KIWIX? " yn
        case $yn in
            [Yy]* ) check_internet; break;;
            [Nn]* ) echo "Another time then cya."; exit;;
            * ) echo "Please answer yes[Y/y] or no[N/n].";;
        esac
    done
}

function check_internet() {
  printf "Checking if you are online..."
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo "Online. Continuing."; prompt_fields;
  else
    error "Offline. Go connect to the internet then run the script again."
  fi
}

check_internet

echo "Setting permissions..."
sudo chown -R 472:472 /portainer/Files/AppData/Config/grafana/data || error "Failed to set permissions for Grafana data!"
echo "Done You are ready to goto next step in the install document"



function prompt_ini_action() {
    while true; do
        read -p "Would you like to download a ZIM to use in KIWIX? " yn
        case $yn in
            [Yy]* ) check_internet; break;;
            [Nn]* ) echo "Another time then cya."; exit;;
            * ) echo "Please answer yes[Y/y] or no[N/n].";;
        esac
    done
}

prompt_ini_action
