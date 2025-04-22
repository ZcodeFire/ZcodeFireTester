#!/bin/bash

sudo chmod +X zcodefire.sh

echo -e "\n[ PING TEST ]"
ping -c 4 8.8.8.8 | grep "time="

echo -e "\n[ STATO SISTEMA ]"
echo -e "CPU Load:\t$(uptime | awk -F 'load average: ' '{print $2}')"
echo -e "RAM Usata:\t$(free -h | awk '/Mem/ {print $3 "/" $2}')"
echo -e "Spazio Disco:\t$(df -h / | awk 'NR==2 {print $4 " liberi su " $2}')"

echo -e "\n[ DOWNLOAD TEST ]"
download_speed=$(wget -O /dev/null http://speedtest.tele2.net/100MB.zip 2>&1 | grep -o '[0-9.]\+ MB/s')
echo "Velocità Download: $download_speed"

echo -e "\n[ UPLOAD TEST ]"
echo "Creazione file temporaneo da 10MB..."
dd if=/dev/zero of=/tmp/upload_test.bin bs=1M count=10 &> /dev/null
upload_speed=$(curl -X POST --data-binary @/tmp/upload_test.bin https://httpbin.org/post -w "%{speed_upload} MB/s" -o /dev/null -s)
echo "Velocità Upload: $upload_speed"
rm -f /tmp/upload_test.bin