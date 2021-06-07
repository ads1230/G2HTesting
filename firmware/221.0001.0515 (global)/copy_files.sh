#!/bin/sh

REMAIN_SZIE=`df | grep "/dev/root" | awk -F " " '{print $4}'`

echo "REMAIN_SZIE=$REMAIN_SZIE"
if [ "$REMAIN_SZIE" -lt 800 ]; then
#剩余空间小于500k，可能导致升级失败，将app.bin copy到customer分区，兼容旧版本升级
    #echo "no enough space to upgrade, exit"
    #exit 126
    if [ -f "/ota/app.bin" ];then
        mv /ota/app.bin /customer/app.bin
        ln -sf /customer/app.bin /ota/app.bin
    fi
fi

# -------------> start copy files <--------------
echo "Start copy files..."
# 拷贝版本号文件,不能修改
cp -rf /tmp/upgrade/fw_info.ini /etc/
cp -rf /tmp/upgrade/os-release /etc/
fw_ver=`grep "ro.sys.fw_ver" /tmp/upgrade/build.prop | cut -f 2 -d '='`
sed -i -e "s|ro.sys.fw_ver=*.*.*|ro.sys.fw_ver=$fw_ver|" /etc/build.prop
# 拷贝增量文件(主要修改此处)
rm -rf /local/app.tar.xz
#rm -rf /lib/libdns_sd.so  /lib/libevent-2.0.so.5 /lib/libevent-2.0.so.5.1.9 /lib/libha_auto.so /lib/libmosquitto.so.1
sync
cp -rf /tmp/upgrade/app.tar.xz /local/

cp /tmp/upgrade/normal.xml /etc/normal.xml
cp /tmp/upgrade/factory.xml /etc/factory.xml
cp -rf /tmp/upgrade/libha_auto.so /lib/libha_auto.so
cp -rf /tmp/upgrade/libha_energy.so /lib/libha_energy.so

cp /tmp/upgrade/libevent.so /lib/
cp /tmp/upgrade/libevent-2.1.so.7 /lib/
cp /tmp/upgrade/libevent-2.1.so.7.0.1 /lib/
cp /tmp/upgrade/libmosquitto.so.1 /lib/
cp /tmp/upgrade/libmosquittopp.so.1 /lib/

cp /tmp/upgrade/monitor /local/bin/
cp /tmp/upgrade/wifi_start.sh /usr/bin/

rm /lib/libevent-2.0.so.5
rm /lib/libevent-2.0.so.5.1.9


/bin/touch /tmp/update
# -------------> end copy files <--------------

#
if [ -f "/ota/app.bin" ];then
    rm -rf /customer/app.bin
fi
