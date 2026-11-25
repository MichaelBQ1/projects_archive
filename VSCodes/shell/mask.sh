#!/bin/bash

# ==========================================
#   СМЕНА ИДЕНТИЧНОСТИ (до перезагрузки)
# ==========================================

# --- Цвета ---
NC='\e[0m'
RED='\e[91m'
GREEN='\e[92m'
YELLOW='\e[93m'
BLUE='\e[94m'

# --- Проверка прав ---
if [[ "$EUID" -ne 0 ]]; then
    echo -e "${RED}Запусти с sudo: sudo $0${NC}"
    # exit 1
fi

# --- Проверка интерфейса ---
IFACE=$(ip route | grep default | awk '{print $5; exit}')
if [[ -z "$IFACE" ]]; then
    echo -e "${RED}Не удалось определить интерфейс${NC}"
    exit 1
fi

echo "=== СМЕНА ИДЕНТИЧНОСТИ ==="
echo ""
echo "=== СПРАВКА ==="
echo "IP       — адрес в сети (только свободный!)"
echo "MAC      — ID сетевой карты (валидный!)"
echo "hostname — имя компьютера (буквы, цифры, дефисы)"
echo "TTL      — 64=Linux, 128=Windows, 255=роутеры"
echo "User-Agent — браузерный отпечаток"
echo "NetBIOS  — имя в Windows-сети"
echo "Все изменения — до перезагрузки"
echo ""

# --- Текущие настройки ---
echo "=== ТЕКУЩИЕ НАСТРОЙКИ ==="
echo "Интерфейс: $IFACE"
echo "IP:        $(ip -4 addr show $IFACE 2>/dev/null | grep inet | awk '{print $2}' | head -1)"
echo "MAC:       $(ip link show $IFACE 2>/dev/null | grep ether | awk '{print $2}')"
echo "hostname:  $(hostname)"
echo "TTL:       $(ping -c 1 8.8.8.8 2>/dev/null | grep -o 'ttl=[0-9]*' | cut -d= -f2 | head -1)"
echo ""

# --- Ввод данных ---
read -p "Новый IP (172.18.19.111/23): " IP
read -p "Новый MAC (50:6F:74:61:74:6F): " MAC
read -p "Новое имя хоста (POTATO): " HOSTNAME
read -p "Новый TTL (64/128/255/60): " TTL_N

# --- Валидация IP ---
if [[ -n "$IP" ]]; then
    # Проверка формата
    if [[ ! "$IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+$ ]]; then
        echo -e "${RED}Ошибка: IP должен быть в формате 172.18.19.111/23${NC}"
        exit 1
    fi
    # Проверка, свободен ли IP
    IP_ONLY=$(echo "$IP" | cut -d/ -f1)
    if ping -c 1 -W 1 "$IP_ONLY" >/dev/null 2>&1; then
        echo -e "${RED}Ошибка: IP $IP_ONLY уже занят!${NC}"
        # exit 1
    fi
    echo -e "${GREEN}IP $IP_ONLY свободен${NC}"
fi

# --- Валидация MAC ---
if [[ -n "$MAC" ]]; then
    if [[ ! "$MAC" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
        echo -e "${RED}Ошибка: MAC должен быть в формате 50:6F:74:61:74:6F${NC}"
        exit 1
    fi
    # Проверка, что первый байт чётный (unicast)
    FIRST_BYTE=$(echo "$MAC" | cut -d: -f1)
    if (( 0x$FIRST_BYTE % 2 != 0 )); then
        echo -e "${RED}Ошибка: MAC должен быть unicast (первый байт чётный)${NC}"
        exit 1
    fi
fi

# --- Валидация hostname ---
if [[ -n "$HOSTNAME" ]]; then
    if [[ ! "$HOSTNAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
        echo -e "${RED}Ошибка: hostname может содержать только буквы, цифры и дефисы${NC}"
        exit 1
    fi
fi

# --- Выбор User-Agent ---
echo ""
echo "=== ВЫБОР USER-AGENT ==="
echo "1) Windows 11 / Chrome"
echo "2) Windows 11 / Firefox"
echo "3) macOS / Safari"
echo "4) Linux / Chrome"
echo "5) Android / Chrome"
echo "6) iPhone / Safari"
echo "7) Potato"
echo "8) Холодильник Samsung"
echo "9) GLaDOS"
echo "10) Minos Prime"
echo "11) Свой UA"
echo "12) Рандомный UA"
read -p "Выбери (1-12): " UA_CHOICE

case $UA_CHOICE in
1) UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" ;;
2) UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0" ;;
3) UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15" ;;
4) UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" ;;
5) UA="Mozilla/5.0 (Linux; Android 14; SM-S918B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36" ;;
6) UA="Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1" ;;
7) UA="Mozilla/5.0 (compatible; Potato/1.0)" ;;
8) UA="Mozilla/5.0 (Linux; Android 7.1.2; Samsung Smart Fridge)" ;;
9) UA="Mozilla/5.0 (compatible; GLaDOS/1.0; Aperture Science)" ;;
10) UA="Mozilla/5.0 (compatible; Linux/1.0; Minos Prime)" ;;
11) read -p "Введи свой User-Agent: " UA ;;
12) 
UA_LIST=(
"Mozilla/5.0 (compatible; Arch/1.0; I use Arch btw)"
"Mozilla/5.0 (compatible; Gentoo/1.0; compiling since 2019)"
"Mozilla/5.0 (compatible; Linux/1.0; kernel panic)"
"Mozilla/5.0 (compatible; vim/1.0; how to exit)"
"Mozilla/5.0 (compatible; Potato/1.0)"
)
UA=${UA_LIST[$RANDOM % ${#UA_LIST[@]}]} ;;
*) echo "Неверный выбор" && exit 1 ;;
esac

read -p "Новое NetBIOS-имя (POTATO): " NETBIOS

# --- Подтверждение ---
echo ""
echo "=== БУДЕТ ИЗМЕНЕНО ==="
[[ -n "$IP" ]] && echo "  IP:        $IP"
[[ -n "$MAC" ]] && echo "  MAC:       $MAC"
[[ -n "$HOSTNAME" ]] && echo "  Hostname:  $HOSTNAME"
[[ -n "$TTL_N" ]] && echo "  TTL:       $TTL_N"
[[ -n "$UA" ]] && echo "  User-Agent: $UA"
[[ -n "$NETBIOS" ]] && echo "  NetBIOS:   $NETBIOS"
echo ""

read -p "Продолжить? (y/n): " CONFIRM
[[ "$CONFIRM" != "y" ]] && echo "Отмена" && exit 0

# --- Применение ---
echo ""
echo "Применяем изменения..."

sudo ip link set "$IFACE" down

# IP
if [[ -n "$IP" ]]; then
    sudo ip addr flush dev "$IFACE"
    sudo ip addr add "$IP" dev "$IFACE"
    echo -e "${GREEN}  IP изменён${NC}"
fi

# MAC
if [[ -n "$MAC" ]]; then
    sudo ip link set dev "$IFACE" address "$MAC"
    echo -e "${GREEN}  MAC изменён${NC}"
fi

# Hostname
if [[ -n "$HOSTNAME" ]]; then
    sudo hostname "$HOSTNAME"
    echo -e "${GREEN}  hostname изменён${NC}"
fi

# TTL
if [[ -n "$TTL_N" ]]; then
    sudo iptables -t mangle -D POSTROUTING -j TTL --ttl-set "$TTL_N" 2>/dev/null
    sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set "$TTL_N"
    echo -e "${GREEN}  TTL изменён${NC}"
fi

# UA
if [[ -n "$UA" ]]; then
    mkdir -p ~/.config/chromium
    echo "user-agent: $UA" > ~/.config/chromium/Local\ State 2>/dev/null
    export http_proxy=""
    export https_proxy=""
    echo -e "${GREEN}  User-Agent изменён${NC}"
fi

# NetBIOS
if [[ -n "$NETBIOS" ]]; then
    if [[ -f /etc/samba/smb.conf ]]; then
        sudo sed -i "s/^\(netbios name = \).*/\1$NETBIOS/" /etc/samba/smb.conf 2>/dev/null
        echo -e "${GREEN}  NetBIOS изменён${NC}"
    else
        echo -e "${YELLOW}  NetBIOS: samba не установлена${NC}"
    fi
fi

sudo ip link set "$IFACE" up

# --- Проверка ---
echo ""
echo "=== НОВЫЕ НАСТРОЙКИ ==="
[[ -n "$IP" ]] && ip addr show "$IFACE" | grep inet | head -1
[[ -n "$MAC" ]] && ip link show "$IFACE" | grep ether
[[ -n "$HOSTNAME" ]] && echo "  hostname: $(hostname)"
[[ -n "$TTL_N" ]] && echo "  TTL:      $(ping -c 1 8.8.8.8 2>/dev/null | grep -o 'ttl=[0-9]*' | cut -d= -f2)"
[[ -n "$UA" ]] && echo "  User-Agent: $UA"
[[ -n "$NETBIOS" ]] && echo "  NetBIOS:   $NETBIOS"

echo ""
echo -e "${GREEN}Готово! (до перезагрузки)${NC}"