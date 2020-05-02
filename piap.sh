#!/bin/bash

_RED="\033[0;31m"
_GREEN="\033[0;32m"
_YELLOW="\033[0;33m"
_RASPBERRY="\033[0;35m"
_ERROR="\033[1;37;41m"
_RESET="\033[m"



function pp(){
	echo -e -e "${_GREEN}$1...${_RESET}\n"
}

unusedServices="systemd-networkd systemd-resolved isc-dhcp-server isc-dhcp-client"
pp "Turning Off the unused services: ${unusedServices}"
systemctl	disable $unusedServices > /dev/null 2>&1



requiredService="wpa_supplicant dhcpcd dnsmasq hostapd"
pp "Setup required services: ${requiredService}"

for service in $requiredService 
do
	echo -e "\nInstalling $service"
	apt-get install $service
	systemctl enable $service
done

echo -e "\nSetup wpa_supplication..."
mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.originial
cp etc.wpa_supplicant.wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

echo -e "\nSetup network interfaces..."
mv /etc/network/interfaces /etc/network/interfaces.original
cp etc.network.interfaces /etc/network/interfaces
rfkill unblock wifi

echo -e "\nSetup dhcpcd..."
mv /etc/dhcpcd.conf /etc/dhcpcd.conf.original
cp etc.dhcpcd.conf /etc/dhcpcd.conf

echo -e "\nSetup dnsmasq..."
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.original
cp etc.dnsmasq.conf /etc/dnsmasq.conf

echo -e "\nSetup hostapd..."
mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.original
cp etc.hostapd.hostapd.conf /etc/hostapd/hostapd.conf 
systemctl unmask hostapd
systemctl enable hostapd

echo -e "\nSetup NAT..."
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
cp etc.iptables.ipv4.nat /etc/iptables.ipv4.nat
mv /etc/rc.local /etc/rc.local.original
cp etc.rc.local /etc/rc.local


echo -e "\n========== FINISHED ======"
echo -e "Please reboot"
