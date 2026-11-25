#!/bin/bash

# Настройки
BAR_WIDTH=30
DURATION=10
SPINNER="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
LOGS=("Инициализация ядра..." "Очистка кэша..." "Взлом Пентагона..." "Подключение к матрице..." "Загрузка котиков..." "Обход блокировок..." "Соединение со спутником...")

# Скрываем курсор
tput civis
trap "tput cnorm; echo" EXIT

start_time=$(date +%s)

for ((i=0; i<=100; i++)); do
    # Расчеты
    filled=$(( i * BAR_WIDTH / 100 ))
    empty=$(( BAR_WIDTH - filled ))
    elapsed=$(( $(date +%s) - start_time ))
    
    # 1. Спиннер (анимация вращения)
    sp_idx=$(( i % 10 ))
    spin=${SPINNER:$sp_idx:1}
    
    # 2. Выбор цвета градиента (от красного к зеленому)
    if [ $i -lt 30 ]; then color="\e[31m"; # Красный
    elif [ $i -lt 70 ]; then color="\e[33m"; # Желтый
    else color="\e[32m"; # Зеленый
    fi

    # 3. Формируем полоску [####....]
    fill_str=$(printf "%${filled}s" | tr ' ' "#")
    empty_str=$(printf "%${empty}s" | tr ' ' ".")
    
    # 4. Рандомные "логи" справа
    log_msg=${LOGS[$(( (i/15) % 6 ))]}

    # ВЫВОД ШЕДЕВРА
    # \r - в начало, \e[K - очистить строку
    printf "\r\e[K"
    printf "\e[1;36m$spin\e[0m " # Спиннер голубой
    printf "\e[37m[\e[0m$color$fill_str\e[38;5;237m$empty_str\e[37m]\e[0m " # Полоса
    printf "\e[1m%3d%%\e[0m " "$i" # Проценты жирным
    printf "\e[2m| Прошло: ${elapsed}s | \e[0m" # Таймер тусклым
    printf "\e[3;34m$log_msg\e[0m" # Логи курсивом синим

    sleep 0.07
done