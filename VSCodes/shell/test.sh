#!/bin/bash
status=""
balance=1000
NC='\033[0m'
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
while [[ $status != "0" ]]; do
    echo "Бомбы (сапер)"
    echo "0. Выход"
    echo "1. Играть"
    echo "2. Баланс"
    read -p "Выберите действие: " status
    if [[ $status == "1" ]]; then
        coef=1
        lst=(1 1 1 0 0 0 0 0 0)
        read -p "Введите ставку: " curr
        lst=($(printf "%s\n" "${lst[@]}" | shuf))
        while [[ $cur != "-1" ]]; do
        read -p "Выберите число в диапазоне 0 - ${(( ${#lst[@]} - 1 ))} или -1 для выхода" cur
        if [[ $cur == "-1" || ( $cur -lt 0 || $cur -gt ( #lst[@] - 1 ) ) ]]; then
            echo -e "${GREEN}Вы забрали деньги${NC}"
            $balance=$( $balance + ( $curr * $coef ) )
            break
        elif [[ $lst[$cur] == "1" ]]; then
            echo -e "${RED}БОМБА!${NC}"
            echo $lst[@]
        else
            echo -e "${GREEN}Бомбы нет!${NC}"
            coef=$( $coef * (5 / 4) )
        fi
        done
    elif [[ $status == "2" ]]; then
        echo "Баланс: ${balance}"
    elif [[ $status == "0" ]]; then
        break
    else
        echo "${RED}Ошибка ввода${NC}"
    fi
done