#!/bin/bash

_RED="\033[0;31m"
_GREEN="\033[0;32m"
_RESET="\033[m"

function pp(){
	echo -e "${_GREEN}$1...${_RESET}\n"
}

backupFile(){
	targetFile=$1
	if [ ! -f ${targetFile}.original ] ; then 
		mv ${targetFile} ${targetFile}.original	
	else
		echo "file existed"
	fi
}

unusedServices="systemd-networkd systemd-resolved isc-dhcp-server isc-dhcp-client"
pp "Turning Off the unused services: ${unusedServices}"
systemctl	disable $unusedServices > /dev/null 2>&1

requiredService="wpa_supplicant dhcpcd dnsmasq hostapd"
pp "Setup required services: ${requiredService}"

for service in $requiredService 
do
	echo -e "\nInstalling $service"
	apt-get install -y $service
	systemctl enable $service
done

echo -e "\nSetup wpa_supplication..."
backupFile /etc/wpa_supplicant/wpa_supplicant.conf
cp etc.wpa_supplicant.wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

echo -e "\nSetup network interfaces..."
backupFile /etc/network/interfaces 
cp etc.network.interfaces /etc/network/interfaces
rfkill unblock wifi

echo -e "\nSetup dhcpcd..."
backupFile /etc/dhcpcd.conf
cp etc.dhcpcd.conf /etc/dhcpcd.conf

echo -e "\nSetup dnsmasq..."
backupFile /etc/dnsmasq.conf 
cp etc.dnsmasq.conf /etc/dnsmasq.conf

echo -e "\nSetup hostapd..."
backupFile /etc/hostapd/hostapd.conf 
cp etc.hostapd.hostapd.conf /etc/hostapd/hostapd.conf 
systemctl unmask hostapd
systemctl enable hostapd

echo -e "\nSetup NAT..."
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g" /etc/sysctl.conf
cp etc.iptables.ipv4.nat /etc/iptables.ipv4.nat
backupFile /etc/rc.local 
cp etc.rc.local /etc/rc.local

echo -e "\n========== FINISHED =========="
echo -e "Please reboot"
