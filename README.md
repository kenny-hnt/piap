# piap
Make Raspberry Pi be an Access Point

Install:
$> curl -L https://subthings.com/install/piap | sudo bash 


If you want to customize, you can change the config file and then reboot:

1. change SSID and Password in etc.hostapd.hostapd.conf file
2. change static IP address of wlan0 in etc.dhcpcd.conf
3. change DNS server in file etc.dnsmasq.conf
4. ...expore yourself the remaining files
