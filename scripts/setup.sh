#!/bin/bash -eux

apt -y update

apt -y install software-properties-common curl

apt-add-repository ppa:ansible/ansible -y > /dev/null 2>&1

apt-add-repository ppa:ondrej/php -y > /dev/null 2>&1
echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main/debug" | tee -a /etc/apt/sources.list.d/ondrej-ubuntu-php-xenial.list
echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/ondrej-ubuntu-php-xenial.list

apt -y update
apt-get -y upgrade

apt-get -y install ansible

# Add vagrant user to sudoers.
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
