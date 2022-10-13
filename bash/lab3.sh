#!/bin/bash

#This script will automate web server creation.

# (1) Install 'lxd' if necessary. We will need snap first to install lxd.
# We will check if 'snap' is installed first and install if needed,
# then we will do the same for 'lxd'

dpkg -s snap &> /dev/null

if [ $? -eq 0 ]; then
        echo 'Snaps already installed!'
else
        echo 'Installing snap...'
        sudo apt install snap
fi

dpkg -s lxd &> /dev/null



if [ $? -eq 0 ]; then
        echo 'lxd already installed!'
else
        echo 'Installing lxd...'
        sudo snap install lxd
fi

# (2) Run lxd init --auto if no lxdbr0 interface exists.


nmcli device | grep -q 'lxdbr0' && echo 'lxdbr0 already exists' ||

if [ $? -ne 0 ]; then
        lxd init --auto && echo 'lxdbr0 bridging'
fi


# (3) Launch a container running Ubuntu 20.04 server named 'COMP2101-F22' if necessary.

lxc list | grep -q 'COMP2101-F22' ||
lxc launch ubuntu:20.04 COMP2101-F22
sudo apt -y install curl

# (4) Add or update the entry in /etc/hosts for hostname 'COMP2101-F22' with the containers current IP address if necessary.

#Variables to store hostname and IP
IPV6=$(lxc list | grep -w 'COMP2101' | awk '{print $9}')
CHOSTNAME=$(lxc list | grep -w 'COMP2101' | awk '{print $2}')


grep -q "3i$IPV6	$CHOSTNAME" /etc/hosts > /dev/null


if [ $? -ne 0 ]; then
        sudo sed -i "3i$IPV6	$CHOSTNAME" /etc/hosts
fi

# (5) Install Apache2 in the container if necessary. 

lxc exec COMP2101-F22 apt install apache2

# (6) Retrieve the default web page from the container's web service with 'curl http://COMP2101-F22' and notify the user of success or failure.
sudo apt -y install curl
curl http://COMP2101-F22 > /dev/null

if [ $? -ne 0 ]; then
	echo 'Failed'
else
	echo 'Success'
fi
