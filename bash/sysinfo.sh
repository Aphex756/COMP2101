#!/bin/bash
# This is an improved script for displaying system information.

# Fully qualified domain name information
FQDN=$(hostname --fqdn)

# Operating system information
OS=$(hostnamectl | grep -wh 'Operating System')

# IP address information
IP=$(hostname -I)

# Rootfile system free space information.
SPACE=$(df -h | grep -w / | awk '{print $4}')

# Running commands, display system information.
echo 'Report for myvm'
echo '=========================='
echo 'FQDN:'  $FQDN
echo 'Operating system and Version' $OS
echo 'IP Address:' $IP
echo 'Root filesystem free space:' $SPACE
echo '=========================='

