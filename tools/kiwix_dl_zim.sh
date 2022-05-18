#!/bin/bash

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

function prompt_fields() {

    while true; do
        echo -n "Enter a name for the dl ZIM file (mywikie.zim): "
        read zimNAME
        if [[ -n "$zimNAME" ]] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
            echo "Filename set to: $zimNAME"; break
        else
            echo "Please enter a valid file name!"
        fi
    done

    while true; do
        echo -n "Enter the URL for the dl ZIM file (https://zim-r-us/mywikie.zim): "
        read zimURL
        if [[ -n "$zimURL" ]] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
            wget -q --spider $zimURL
            if [ $? -eq 0 ]; then
                echo "URL set to: $zimURL"; break
            else
                echo "No ZIM file found at: $zimURL"
            fi
        else
            echo "Please enter a valid url!"
        fi
    done

    DIR="/tmp/zim/"
    if [ -d "$DIR" ]; then
        sudo wget $zimURL -O /tmp/zim/$zimNAME || error "Failed to download file!";
    else
        sudo mkdir /tmp/zim && sudo wget $zimURL -O /tmp/zim/$zimNAME || error "Failed to download file!";
    fi
    

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
