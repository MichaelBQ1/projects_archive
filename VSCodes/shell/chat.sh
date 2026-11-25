#!/bin/bash

# --- Конфиг и цвета ---
PORT=12345
FIFO="/tmp/chat_fifo"
CLR_BG="\e[44;1;37m" # Синий фон
CLR_CYAN="\e[36m"
CLR_PINK="\e[35m"
CLR_LIME="\e[32m"
CLR_RED="\e[31m"
RESET="\e[0m"
BOLD="\e[1m"

#!/bin/bash

# Цвета для загрузки
G1="\e[38;5;82m"  # Ярко-зеленый
G2="\e[38;5;46m"  # Зеленый
G3="\e[38;5;34m"  # Темно-зеленый
R="\e[31m"
W="\e[37m"
RESET="\e[0m"

tput clear
tput civis # Спрятать курсор

# --- МОЙ ФИРМЕННЫЙ ЗАГРУЗОЧНЫЙ ЭКРАН ---
echo -e "${G1}${BOLD}ИНИЦИАЛИЗАЦИЯ КРИПТО-КАНАЛА...${RESET}\n"

steps=(
    "Поиск свободных портов"
    "Генерация RSA-ключей"
    "Обход брандмауэра"
    "Оптимизация свистоперделок"
    "Подключение к матрице"
)

for ((i=0; i<${#steps[@]}; i++)); do
    # Текст текущего шага
    echo -ne "${W} > ${steps[$i]}... "
    sleep 0.4
    
    # Мини-полоска для каждого шага
    BAR_WIDTH=20
    for ((j=0; j<=$BAR_WIDTH; j++)); do
        pct=$((j * 100 / BAR_WIDTH))
        filled=$((j))
        empty=$((BAR_WIDTH - j))
        
        # Рисуем классику [####....] с цветом
        fill_str=$(printf "%${filled}s" | tr ' ' "#")
        empty_str=$(printf "%${empty}s" | tr ' ' ".")
        
        printf "\r\e[K ${W}> ${steps[$i]}... ${G2}[${G1}%s${G3}%s${G2}] ${W}%d%%" "$fill_str" "$empty_str" "$pct"
        sleep 0.01
    done
    echo -e " ${G1}OK!${RESET}"
done

echo -e "\n${G1}${BOLD}ВСЕ СИСТЕМЫ ГОТОВЫ. ВХОД В ТЕРМИНАЛ...${RESET}"
sleep 1
tput clear
tput cnorm # Вернуть курсор
# --- КОНЕЦ ЗАГРУЗКИ ---


cleanup() { rm -f "$FIFO"; tput cnorm; echo -e "${CLR_RED}\n[СВЯЗЬ ПРЕРВАНА]${RESET}"; exit; }
trap cleanup EXIT
rm -f "$FIFO" && mkfifo "$FIFO"

tput clear
tput civis # Скрываем курсор

# --- Фан-заставка ---
show_intro() {
    local msg="ПОДКЛЮЧЕНИЕ К ЗАСЕКРЕЧЕННОМУ КАНАЛУ..."
    for ((i=0; i<${#msg}; i++)); do echo -ne "${CLR_CYAN}${msg:$i:1}"; sleep 0.03; done
    echo -e "\n"
    for i in {1..15}; do 
        printf "\r${CLR_PINK}[%-15s] %d%%" $(printf '#%.0s' $(seq 1 $i)) $((i*100/15))
        sleep 0.05
    done
    echo -e "${RESET}\n"
}

# --- Эффект Глюка ---
glitch_screen() {
    for i in {1..20}; do
        tput cup $((RANDOM % $(tput lines))) $((RANDOM % $(tput cols)))
        echo -ne "\e[$((31 + RANDOM % 7))m$((RANDOM % 2))"
        sleep 0.01
    done
    tput clear
}

show_intro

echo -e "${BOLD}КТО ТЫ?${RESET}"
echo "1) ХОСТ (Создать комнату)"
echo "2) ГОСТЬ (Войти по IP)"
read -p ">> " MODE
read -p "Твой позывной: " NICK

if [ "$MODE" == "1" ]; then
    IP=$(hostname -I | awk '{print $1}')
    echo -e "${CLR_LIME}[СИСТЕМА] Твой IP: $IP. Ждем гостя...${RESET}"
    # Фоновое прослушивание
    (tail -f "$FIFO" | nc -l -p $PORT) &
    # Чтение входящих
    nc -l -p $((PORT+1)) | while read line; do
        echo -e "\a\r\e[K${CLR_PINK} < $line${RESET}"
        echo -ne "${CLR_LIME}$NICK > ${RESET}"
    done &
else
    read -p "IP Хоста: " HOST_IP
    glitch_screen
    # Фоновое прослушивание
    (tail -f "$FIFO" | nc $HOST_IP $((PORT+1))) &
    # Чтение входящих
    nc $HOST_IP $PORT | while read line; do
        echo -e "\a\r\e[K${CLR_LIME} < $line${RESET}"
        echo -ne "${CLR_PINK}$NICK > ${RESET}"
    done &
fi

tput cnorm
# --- Основной цикл отправки ---
while true; do
    echo -ne "\r\e[K${BOLD}${CLR_CYAN}$NICK > ${RESET}"
    read MSG
    
    if [[ "$MSG" == "/glitch" ]]; then
        glitch_screen
        continue
    elif [[ "$MSG" == "/exit" ]]; then
        exit
    fi

    # Отправка сообщения в FIFO
    echo -e "${BOLD}$NICK:${RESET} $MSG" > "$FIFO"
done
