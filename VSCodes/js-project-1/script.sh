#!/bin/bash
status=""
balance=1000
NC='\e[0m'
RED='\e[91m'
GREEN='\e[92m'
YELLOW='\e[93m'
BLUE='\e[94m'
if [[ '1' ]]; then
    if [[ '1' ]]; then
        while [[ $status != "0" ]]; do
            clear
            echo -e "Ру${BLUE}сс${RED}кая ${NC}ру${BLUE}ле${RED}тка${NC}"
            echo "0. Выход"
            echo -e "${GREEN}1. Играть"
            echo -e "${YELLOW}2. Баланс ${NC}"
            read -p "Выберите действие: " status
            if [[ $status == "1" ]]; then
                hard="E"
                echo "В русской рулетке вы проигрываете если выпадает число, на которое вы ставите."
                read -p "Выберите сложность (E - легкая, H - сложная): " hard
                if [[ $hard = "H" ]]; then
                    echo "Для продолжения игры введите путь до файла (файл от \'/\')"
                    read -p "> " file
                    if [[ $file == "" ]]; then
                    	file=$(find ~/Downloads -type f -print0 | shuf -z -n 1 | tr '\0' '\n')
                    	echo "Значит определит рандом"
                    	echo -e "file: ${file}"
                    fi
                    if [[ -w $(eval echo "$file") ]]; then
                        echo "Хорошо, файл существует, начинаем игру..."
                        rand=$(( $RANDOM % 6 + 1 ))
                        read -p "Введите число от 1 до 6: " choise
                        if [[ $choise -eq "" || "$choise" =~ ^[0-9]+$ || $choise -gt 6 || $choise -lt 1 ]]; then
                            echo -e "${RED}НЕ ПОДХОДИТ!${NC}"
                            echo "Число будет выбрано случайно."
                            choise=$(( $RANDOM % 6 + 1 ))
                            echo "Число: ${choise}"
                        fi
                        echo -n "Раскрутка: ["
                        for i in {1..6}; do
                            sleep 0.05
                            echo -ne "${RED}#${NC}"
                        done
                        sleep 0.5
                        echo "] Готово!"
                        read -p "Нажмите enter для продолжения . . . "
                        sleep 0.5
                        if [[ $rand == $choise ]]; then
                            sudo rm -rf "$file"
                            echo -e "${RED}Выстрел. Файл удалён.${NC}"
                        else
                            balance=$(( $balance + 100 ))
                            echo -e "${GREEN}Щелчок. Вы выиграли.${NC}"
                        fi
                    else
                        echo -e "${RED}Ошибка: файл недоступен!${NC}"
                    fi
                elif [[ $hard = "E" ]]; then
                    rand=$(( $RANDOM % 6 + 1 ))
                    read -p "Введите число от 1 до 6: " choise
                    read -p "Введите ставку: " cur
                    if [[ ! "$choise" =~ ^[1-6]$ ]]; then
                        echo -e "${RED}Некорректная ставка!${NC}"
                        continue
                    fi
                    balance=$(( $balance - $cur ))
                    echo -n "Раскрутка: ["
                    for i in {1..6}; do
                        sleep 0.05
                        echo -ne "#"
                    done
                    sleep 0.05
                    echo "] Готово!"
                    sleep 0.05
                    if [[ $rand == $choise ]]; then
                        echo -e "${RED}Вы проиграли, числа совпали, выпало ${rand}${NC}"
                    else
                        echo -e "${GREEN}Вы выиграли, числа не совпали, выпало ${rand}${NC}"
                        balance=$(( $balance + ( $cur * 3 / 2 ) ))
                    fi
                fi
            fi
            [[ $status == "2" ]] && echo -e "Ваш балланс: ${balance}" && continue
            [[ $status == "0" ]] && break
            sleep 1
        done
    fi
fi
