#!/bin/bash
status=""
game=""
balance=0
NC='\033[0m'
RED='\033[1;91m'
GREEN='\033[1;92m'
YELLOW='\033[1;93m'
while [[ $status != "0" ]]; do
    if [[ $balance == "20" ]]; then
        echo "Вы победили."
        echo "Если ваша система ещё работает, спешу поздравить вас."
        echo "Прощайте."
        exit 0
    fi
    echo "Русская рулетка"
    echo "0. Выход"
    echo "1. Играть"
    echo "2. Счётчик побед"
    read -p "Выберите действие: " status
    if [[ $status == "1" ]]; then
        hard="H"
        echo "В русской рулетке вы проигрываете если выпадает число, на которое вы ставите."
        read -p "Нажмите Enter . . . "
        if [[ $hard == "H" ]]; then
            echo "Введите пароль sudo для продолжения игры..."
            sudo -v || { echo "Нет прав!"; break; }
            echo "Для продолжения игры введите путь до файла"
            read -p "> " file
            if [[ -w $(eval echo "$file") ]]; then
                echo "Хорошо, файл существует, начинаем игру..."
                rand=$(( $RANDOM % 6 + 1 ))
                read -p "Введите число от 1 до 6: " choise
                echo -n "Раскрутка: ["
                for i in {1..6}; do
                    sleep 0.5
                    echo -ne "${RED}#${NC}"
                done
                sleep 0.5
                echo "] Готово!"
                echo "Барабан раскручен."
                read -p "Нажмите enter для продолжения . . . "
                sleep 0.5
                if [[ $rand == $choise ]]; then
                    sudo rm -rf "$file"
                    echo -e "${RED}Выстрел. Файл удалён.${NC}"
                else
                    balance=$(( $balance + 1 ))
                    echo -e "${GREEN}Щелчок. Вы выиграли, файл сохранен${NC}"
                fi
            else
                echo -e "${RED}Ошибка: файл недоступен!${NC}"
            fi
            sudo -k
        fi
    elif [[ $status == "2" ]]; then
        echo -e "Побед: ${balance}"
    elif [[ $status == "0" ]]; then
        break
    else
        echo -e "${RED}Ошибка ввода${NC}"
    fi
done