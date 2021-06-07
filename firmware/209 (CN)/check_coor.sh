#!/bin/sh

# check coor version

current_coor_version=`agetprop persist.sys.zb_ver`
if [ -z "$current_coor_version" ]; then
    echo "agetprop zb_ver fail"
    current_coor_version=`grep "MCU_FW_VERSION" /etc/mcu-release | cut -f 2 -d '='`
fi
new_coor_version=`grep "MCU_FW_VERSION" /tmp/upgrade/mcu-release | cut -f 2 -d '='`
if [ x"$current_coor_version" == x"$new_coor_version" ]; then
    echo "same coor version"
else
    echo "find new coor version $new_coor_version"
    cp /tmp/upgrade/coor.bin /ota/coor.bin
fi

cp -rf /tmp/upgrade/mcu-release /etc/