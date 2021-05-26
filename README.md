# G2HTesting

--- FW Testing ---
save in a folder called upgrade on your SD card

cp /sdcard/upgrade /tmp/upgrade/                   
/tmp/upgrade/check_coor.sh                                                                          
/tmp/upgrade/copy_files.sh                                                                      
rm -rf /tmp/upgrade                                          
rm -f /sdcard/upgrade

--- Language Testing ---

cp -r /sdcard/etc/ch/en /etc/ch/en

cp -r /sdcard/etc/ch/ru /etc/ch/ru

cp -r /sdcard/etc/ch/es /etc/ch/es

cp -r /sdcard/customer/voice /customer/voice
