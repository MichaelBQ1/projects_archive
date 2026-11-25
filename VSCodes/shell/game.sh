#!/bin/bash
status=""
game=""
red=(1 3 5 7 9 12 14 16 18 19 21 23 25 27 30 32 34 36)
balance=1000
NC='\e[0m'
RED='\e[91m'
GREEN='\e[92m'
YELLOW='\e[93m'
BLUE='\e[94m'
GRAY='\e[90m'
read -p "Нажмите Enter для продолжения . . . "
echo -n "Загрузка: ["
for i in {1..10}; do
    sleep 0.05
    echo -ne "\e[32m#\e[0m"
done
echo "] Готово!"
while [[ $game != "0" ]]; do
    status=""
    clear
    echo ""
    echo -e "${BLUE} ██████   █████   ███    ███ ██████  ██      ██ ███    ██  ██████"  
    echo -e " ██       ██   ██ ████  ████ ██   ██ ██      ██ ████   ██ ██     "  
    echo -e " ██   ███ ███████ ██ ████ ██ ██████  ██      ██ ██ ██  ██ ██   ███ "
    echo -e " ██    ██ ██   ██ ██  ██  ██ ██   ██ ██      ██ ██  ██ ██ ██    ██ "
    echo -e " ██████   ██   ██ ██      ██ ██████  ███████ ██ ██   ████  ██████  ${NC}"
    echo ""
    echo -e "${GREEN}Игорный дом${NC}"
    echo -e "${YELLOW}Ваш баланс:${GREEN} ${balance} ${NC}"
    echo -e "\e[1;90m0. Выход"
    echo -e "\e[;95m1. Рулетка"
    echo -e "${BLUE}2. Краш (ракета)"
    echo -e "\e[96m3. Скачки (ставки на лошадей)"
    echo -e "${GREEN}4. Русская рулетка"
    echo -e "\e[96m5. Сапер (бомбы)"
    echo -e "${BLUE}6. Слот-машина ${NC}"
    read -p $'\e[92mВведите игру: \e[0m' game
    if [[ $game == "1" ]]; then
        while [[ $status != "0" ]]; do
            clear
            echo -e "${RED}Р${GRAY}у${RED}л${GRAY}е${RED}т${GRAY}к${RED}а${NC}"
            echo "0. Выход"
            echo -e "${GREEN}1. Играть"
            echo -e "${YELLOW}2. Баланс ${NC}"
            read -p $'\e[92mВыберите действие: \e[0m' status
            if [[ $status == "1" ]]; then
                echo -e "Красные числа: ${RED}1 3 5 7 9 12 14 16 18 19 21 23 25 27 30 32 34 36${NC}"
                read -p $'На что вы ставите (\e[91mкрасное - R, \e[90mчерное - B, \e[92mчетное - E, \e[93mнечетное - O, \e[92mчисло от 0 до 36\e[0m): ' cur1
                read -p "Введите ставку: " cur2
                if [[ $cur2 -ge 0 && $cur2 -le $balance ]]; then
                    rand=$(( $RANDOM % 37 ))
                    balance=$(( $balance - $cur2 ))
                    if [[ $rand == $cur1 ]]; then
                        echo -e "${GREEN}Вы выиграли, выпало ${rand}!${NC}"
                        balance=$(( $balance + (( $cur2 * 36 )) ))
                    elif [[ ( $cur1 == "E" && $(( $rand % 2 )) -eq 0 ) || ( $cur1 == "e" && $(( $rand % 2 )) -eq 0 ) ]]; then
                        echo -e "${GREEN}Вы выиграли, выпало ${rand}!${NC}"
                        balance=$(( $balance + (( $cur2 * 2 )) ))
                    elif [[ ( $cur1 == "O" && $(( $rand % 2 )) -eq 1 ) || ( $cur1 == "o" && $(( $rand % 2 )) -eq 1 ) ]]; then
                        echo -e "${GREEN}Вы выиграли, выпало ${rand}!${NC}"
                        balance=$(( $balance + (( $cur2 * 2 )) ))
                    elif [[ $cur1 == "R" || $cur1 == "r" ]]; then
                        for num in "${red[@]}"; do
                            if [ "$rand" -eq "$num" ]; then
                                echo -e "${GREEN}Вы выиграли, выпало ${rand}!${NC}"
                                balance=$(( $balance + (( $cur2 * 2 )) ))
                                break
                            fi
                        done
                    elif [[ $cur1 == "B" || $cur1 == "b" ]]; then
                        is_red=0
                        for num in "${red[@]}"; do
                            if [ "$rand" -eq "$num" ]; then
                                is_red=1
                                break
                            fi
                        done
                        if [ $is_red -eq 0 && $rand -eq 0 ]; then
                            echo -e "${GREEN}Вы выиграли, выпало ${rand}!${NC}"
                            balance=$(( $balance + (( cur2 * 2 )) ))
                        else
                            echo -e "${YELLOW}Вы проиграли, выпало ${rand}${NC}"
                        fi
                    else
                        echo -e "${YELLOW}Вы проиграли, выпало ${rand}${NC}"
                    fi
                else
                    echo -e "${RED}Ошибка ввода${NC}"
                fi
                sleep 1
            fi
            [[ $status == "2" ]] && echo "Ваш балланс: ${balance}" && continue
            [[ $status == "0" ]] && break
            sleep 0.5
        done
    elif [[ $game == "2" ]]; then
        while [[ $status != "0" ]]; do
            clear
            echo "Краш (ракета)"
            echo "0. Выход"
            echo -e "${GREEN}1. Играть"
            echo -e "${YELLOW}2. Баланс ${NC}"
            read -p $'\e[92mВыберите действие: \e[0m' status
            if [[ $status == "1" ]]; then
                rand=$(( $RANDOM % 9 ))
                read -p "Введите ставку: " cur
                if [[ $cur -le 0 || $cur -gt $balance ]]; then
                    echo -e "${RED}Некорректная ставка!${NC}"
                    break
                fi
                minus=$cur
                while [[ $rand -le 10 ]]; do
                    echo "Ставка: ${cur}"
                    echo -n "---{"
                    sleep 0.1
                    for ((i=0; i<10; i++)); do
                        if [[ $i -lt $(( $rand )) ]]; then
                            echo -ne "\e[32m#${NC}"
                            sleep 0.1
                        else
                            echo -ne "·"
                            sleep 0.1
                        fi
                    done
                    echo "}---"
                    sleep 0.5
                    echo "Шанс срыва: ${rand} (выше 10 - срыв)"
                    read -p "Выводим? (д/н, по умолчанию-н): " move
                    if [[ $move == "д" ]]; then
                        echo -e "${GREEN}Вывод, вы получили ${cur}${NC}"
                        balance=$(( $balance + $cur ))
                        break
                    else
                        echo -e "${YELLOW}Продолжаем...${NC}"
                        cur=$(( $cur * 2 ))
                        rand=$(( $rand + $RANDOM % 5 + 1 ))
                        if [[ $rand -ge 10 ]]; then
                            echo -n "---{"
                            sleep 0.1
                            for ((i=0; i<10; i++)); do
                                if [[ $i -lt $(( $rand )) ]]; then
                                    echo -ne "\e[32m#${NC}"
                                    sleep 0.1
                                else
                                    echo -ne "·"
                                    sleep 0.1
                                fi
                            done
                            echo -n "}---"
                            echo -e "\r---{${RED}##########${NC}}---"
                            sleep 0.5
                            echo -e "${RED}Сорвалась!${NC}"
                            balance=$(( $balance - $minus ))
                            sleep 3
                            cur=0
                            break
                        fi
                        sleep 0.5
                    fi
                done
            fi
            [[ $status == "2" ]] && echo "Ваш балланс: ${balance}" && continue
            [[ $status == "0" ]] && break
        done
    elif [[ $game == "3" ]]; then
        while [[ $status != "0" ]]; do
            horses=(1 2 3 4)
            len=10
            clear
            echo "Скачки (ставки на лошадей)"
            echo "0. Выход"
            echo -e "${GREEN}1. Играть"
            echo -e "${YELLOW}2. Баланс ${NC}"
            read -p $'\e[92mВыберите действие: \e[0m' status
            if [[ $status == "1" ]]; then
                rand=$(( $RANDOM % 4 + 1 ))
                read -p "Введите ставку: " cur2
                read -p "На какую лошадь ставим? (1-4): " cur1
                if [[ $cur2 -le 0 || $cur2 -gt $balance || $cur1 -le 0 || $cur1 -ge 5 ]]; then
                    echo -e "${RED}Некорректная ставка / ввод!${NC}"
                    break
                fi
                echo "Начнем!"
                echo -n "Лошадь 1: ["
                for i in {1..10}; do
                    sleep 0.1
                    echo -ne "\e[32m#\e[0m"
                done
                echo "] Готово!"
                sleep 0.5
                echo -n "Лошадь 2: ["
                for i in {1..10}; do
                    sleep 0.1
                    echo -ne "\e[32m#\e[0m"
                done
                echo "] Готово!"
                sleep 0.5
                echo -n "Лошадь 3: ["
                for i in {1..10}; do
                    sleep 0.1
                    echo -ne "\e[32m#\e[0m"
                done
                echo "] Готово!"
                sleep 0.5
                echo -n "Лошадь 4: ["
                for i in {1..10}; do
                    sleep 0.1
                    echo -ne "\e[32m#\e[0m"
                done
                echo "] Готово!"
                sleep 1
                balance=$(( $balance - $cur2 ))
                if [[ $rand -eq $cur1 ]]; then
                    echo -e "${GREEN}Вы выиграли, победила лошадь ${rand}!${NC}"
                    balance=$(( $balance + (( $cur2 * 5 )) ))
                else
                    echo -e "${YELLOW}Вы проиграли, выиграла лошадь ${rand}${NC}"
                fi
                sleep 1
            fi
            [[ $status == "2" ]] && echo "Ваш балланс: ${balance}" && continue
            [[ $status == "0" ]] && break
        done
    elif [[ $game == "4" ]]; then
        while [[ $status != "0" ]]; do
            clear
            echo -e "Ру${BLUE}сс${RED}кая ${NC}ру${BLUE}ле${RED}тка${NC}"
            echo "0. Выход"
            echo -e "${GREEN}1. Играть"
            echo -e "${YELLOW}2. Баланс ${NC}"
            read -p $'\e[92mВыберите действие: \e[0m' status
            if [[ $status == "1" ]]; then
                hard="E"
                echo "В русской рулетке вы проигрываете если выпадает число, на которое вы ставите."
                read -p $'Выберите сложность (E - легкая, H - сложная \e[91m!!!ВНИМАНИЕ в сложной сложности вы играете на ВАШИ ФАЙЛЫ УСТРОЙСТВА!!!\e[0m): ' hard
                if [[ $hard = "H" ]]; then
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
                            balance=$(( $balance + 100 ))
                            echo -e "${GREEN}Щелчок. Вы выиграли, файл сохранен${NC}"
                        fi
                    else
                        echo -e "${RED}Ошибка: файл недоступен!${NC}"
                    fi
                    sudo -k
                elif [[ $hard = "E" ]]; then
                    rand=$(( $RANDOM % 6 + 1 ))
                    read -p "Введите число от 1 до 6: " choise
                    read -p "Введите ставку: " cur
                    if [[ $cur -le 0 || $cur -gt $balance ]]; then
                        echo -e "${RED}Некорректная ставка!${NC}"
                        break
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
            [[ $status == "2" ]] && echo "Ваш балланс: ${balance}" && continue
            [[ $status == "0" ]] && break
            sleep 1
        done
    elif [[ $game == "5" ]]; then
        while [[ $status != "0" ]]; do
            clear
            echo "Бомбы (сапер)"
            echo "0. Выход"
            echo -e "${GREEN}1. Играть"
            echo -e "${YELLOW}2. Баланс ${NC}"
            read -p $'\e[92mВыберите действие: \e[0m' status
            if [[ $status == "1" ]]; then
                coef=1
                lst=(1 1 1 0 0 0 0 0 0)
                read -p "Введите ставку: " curr
                if [[ $curr -le 0 || $curr -gt $balance ]]; then
                    echo -e "${RED}Некорректная ставка!${NC}"
                    continue
                fi
                lst=($(printf "%s\n" "${lst[@]}" | shuf))
                while true; do
                    read -p "Выберите число в диапазоне 0 - $(( ${#lst[@]} - 1 )) или -1 для выхода: " cur
                    sleep 0.5
                    if [[ $cur == "-1" ]]; then
                        echo -e "${GREEN}Вы забрали деньги${NC}"
                        balance=$(( balance + curr * coef ))
                        break
                    fi
                    if [[ $cur -lt 0 || $cur -ge ${#lst[@]} ]]; then
                        echo -e "${RED}Ошибка: число вне диапазона!${NC}"
                        continue
                    fi
                    if [[ ${lst[$cur]} == "1" ]]; then
                        echo -e "${RED}БОМБА!${NC}"
                        echo "0 1 2 3 4 5 6 7 8"
                        echo "${lst[@]}"
                        balance=$(( balance - curr ))
                        sleep 0.5
                        break
                    else
                        echo -e "${GREEN}Бомбы нет!${NC}"
                        unset 'lst[$cur]'
                        lst=("${lst[@]}")
                        coef=$(( $coef + 1 ))
                        echo -e "${YELLOW}Коэффициент: ${coef}${NC}"
                        sleep 0.5
                    fi
                done
            fi
            [[ $status == "2" ]] && echo "Ваш балланс: ${balance}" && continue
            [[ $status == "0" ]] && break
        done
    elif [[ $game == "6" ]]; then
        while [[ $status != "0" ]]; do
            sleep 0.5
            clear
            echo -e "${RED}Слот${NC}-${GREEN}машина${NC}"
            echo "0. Выход"
            echo -e "${GREEN}1. Играть"
            echo -e "${YELLOW}2. Баланс ${NC}"
            read -p $'\e[92mВыберите действие: \e[0m' status
            if [[ $status == "1" ]]; then
                read -p "Введите ставку: " curr
                if [[ $curr -le 0 || $curr -gt $balance ]]; then
                    echo -e "${RED}Некорректная ставка!${NC}"   
                    continue
                fi
                rand1=$(( $RANDOM % 5 + 1 ))
                rand2=$(( $RANDOM % 5 + 1 ))
                rand3=$(( $RANDOM % 5 + 1 ))
                echo -ne "\r---<=|#|#|#|=>---\r"
                sleep 0.5
                echo -ne "\r---<=|${rand1}|#|#|=>---\r"
                sleep 0.5
                echo -ne "\r---<=|${rand1}|${rand2}|#|=>---\r"
                sleep 0.5
                echo -e "---<=|${rand1}|${rand2}|${rand3}|=>---"
                sleep 0.5
                [[ $rand1 -eq $rand2 && $rand2 -eq $rand3 ]] && ( balance=($balance + $curr * 4) ) && echo -e "\e[5;92mДжекпот!\e[5;0m" && continue
                [[ $rand1 -eq $rand2 || $rand2 -eq $rand3 || $rand3 -eq $rand1 ]] && ( balance=($balance + $curr) ) && echo -e "${GREEN}Победа!${NC}" && continue
                [[ $rand1 -ne $rand2 || $rand2 -ne $rand3 || $rand3 -ne $rand1 ]] && ( balance=($balance - $curr) ) && echo -e "${RED}Поражение.${NC}"
            fi
            [[ $status == "2" ]] && echo "Ваш балланс: ${balance}" && continue
            [[ $status == "0" ]] && break
        done
    elif [[ $game == "0" ]]; then
        break
    else
        echo -e "${RED}Ошибка ввода, такого у нас пока нет :(${NC}"
    sleep 0.5
    fi
done