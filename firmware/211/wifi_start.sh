#!/bin/sh

MIIO_CONF_DIR=/mnt/config/miio
WIFI_CONF_FILE=$MIIO_CONF_DIR/wifi.conf
DEVICE_CONFIG_FILE=$MIIO_CONF_DIR/device.conf

WPA_SUPPLICANT_CONFIG_FILE="/tmp/wpa_supplicant.conf"

update_wpa_conf()
{
    if [ x"$2" = x ]; then
    cat <<EOF > $WPA_SUPPLICANT_CONFIG_FILE
ctrl_interface=/var/run/wpa_supplicant
update_config=1
country=CN
network={
        ssid="$1"
	scan_ssid=1
        key_mgmt=NONE
}
EOF
    else
    cat <<EOF > $WPA_SUPPLICANT_CONFIG_FILE
ctrl_interface=/var/run/wpa_supplicant
update_config=1
country=CN
network={
        ssid="$1"
	scan_ssid=1
        psk="$2"
        key_mgmt=WPA-PSK
		proto=WPA WPA2
}
EOF
    fi
}

wifi_ap_mode()
{
	echo "start AP mode"
	killall wpa_supplicant hostapd udhcpd udhcpc
	sleep 0.5
	hostapd -B /mnt/config/hostapd.conf
	sleep 0.5
	ifconfig wlan0 192.168.0.239
	udhcpd /etc/udhcpd.conf
}

wifi_sta_mode()
{
	echo "start STA mode"
	killall wpa_supplicant hostapd udhcpd udhcpc
	sleep 0.5
	get_ssid_passwd
	update_wpa_conf "$ssid" "$passwd"
	echo "connect wifi $ssid $passwd"
	wpa_supplicant -Dnl80211 -iwlan0 -c $WPA_SUPPLICANT_CONFIG_FILE -B
	sleep 0.5
	udhcpc -b -s /etc/udhcpc_all.default -i wlan0 -t 10
}

get_ssid_passwd()
{
	STRING=`cat $WIFI_CONF_FILE | grep -v ^#`
	key_mgmt=${STRING##*key_mgmt=}
	if [ $key_mgmt == "NONE" ]; then
		passwd=""
		ssid=${STRING##*ssid=\"}
		ssid=${ssid%%\"*}
	else
		passwd=${STRING##*psk=\"}
		passwd=${passwd%%\"*}
		ssid=${STRING##*ssid=\"}
		ssid=${ssid%%\"*}
	fi
}

start()
{
	if [ -e $WIFI_CONF_FILE ]; then
		wifi_sta_mode

	fi
}

start

