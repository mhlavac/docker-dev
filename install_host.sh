#!/bin/bash

sudo apt-get update
sudo apt-get install -y git cowsay
log=""

# Vagrant
echo "Checking vagrant"
if [ $(dpkg -l | grep -c "vagrant") -eq 0 ]; then
    echo "Installing vagrant"
    wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
    sudo dpkg -i vagrant_1.7.2_x86_64.deb
    rm vagrant_1.7.2_x86_64.deb
    log=`echo "$log\n\n[vagrant] installed"`
else
    log=`echo "$log\n\n[vagrant] already installed"`
fi

# Docker
echo "Checking docker"
if [ $(dpkg -l | grep -c "docker-engine") -eq 0 ]; then
    wget -qO- https://get.docker.com/ | sudo sh
    sudo usermod -aG docker $USER
    sudo newgrp docker
    sudo service docker restart
    log=`echo "$log\n\n[docker] installed"`
else
    log=`echo "$log\n\n[docker] already installed"`
fi

hosts="127.0.0.1       app.dev adminer.dev mailcatcher.dev"
if ! grep -Fxq "$hosts" /etc/hosts; then
    echo "$hosts" | sudo tee -a /etc/hosts
    log=`echo "$log\n\n[/etc/hosts] updated with $hosts"`
else
    log=`echo "$log\n\n[/etc/hosts] already exists"`
fi

baseDirectory=$(dirname $0)

if [ ! -f "$baseDirectory/config.yml" ]; then
    cp $baseDirectory/config.yml.dist $baseDirectory/config.yml
    if which xdg-open &> /dev/null; then
        xdg-open $baseDirectory/config.yml
    else
        nano $baseDirectory/config.yml
    fi
    log=`echo -e "$log\n\n[$baseDirectory/config.yml] created"`
else
    log=`echo -e "$log\n\n[$baseDirectory/config.yml] already exists"`
fi

cd $baseDirectory
clear
echo -e "Hello. I'm \033[33;1mFred\033[00m and I installed everything for you.\n\nRun \033[32;1mmake develop\033[00m to start your dev container.\n\nLog:\033[36;1m\n$log\033[00m" | cowsay -W80 -f stegosaurus
