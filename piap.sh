#!/bin/bash

_RED="\033[0;31m"
_GREEN="\033[0;32m"
_YELLOW="\033[0;33m"
_RASPBERRY="\033[0;35m"
_ERROR="\033[1;37;41m"
_RESET="\033[m"



function pp(){
	echo -e "${_GREEN}$1...${_RESET}\n"
}

# Setup network interfaces: wlan0 and eth0

# Setup NAT between wlan0 and eth0

# Setup the wlan0 as an Access Point with hostapd

# Setup DHCP client for eth0, DHCP server for wlan0

# Setup DNS for wlan0 interface 

pp "Removing the default services"
apt-get --autoremove purge ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common 
rm -r /etc/network /etc/dhcp

