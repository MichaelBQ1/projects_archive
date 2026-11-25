#!/bin/bash

LOG="/home/student/poslanie.log"
target="2028-10-05"
end_date="2029-01-20"

now=$(date +%s)
target_sec=$(date -d "$target" +%s)
end_sec=$(date -d "$end_date" +%s)

if [[ $now -lt $target_sec ]]; then
    echo "Скоро . . ."
    exit 0
fi

if [[ $now -gt $end_sec ]]; then
    echo "Время вышло." >> "$LOG"
    exit 0
fi
echo "Время пошло." | tee -a "$LOG"
echo "20.01.2029" | tee -a "$LOG"
if ! command -v at &> /dev/null; then
    sudo apt install at -y
    sudo systemctl enable --now atd
fi

# Запуск от root, чтобы не требовался пароль
echo "systemctl start my-script" | sudo at 8:30 2029-01-20
