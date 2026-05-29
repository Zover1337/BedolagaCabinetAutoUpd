#!/bin/bash

# ==========================================
# Шапка (Баннер)
# ==========================================
clear
echo -e "\e[36m"
cat << "EOF"
  ____          _       _                   
 |  _ \        | |     | |                  
 | |_) | ___ __| | ___ | | __ _  __ _  __ _ 
 |  _ < / _ \ _` |/ _ \| |/ _` |/ _` |/ _` |
 | |_) |  __/ (_| | (_) | | (_| | (_| | (_| |
 |____/ \___|\__,_|\___/|_|\__,_|\__, |\__,_|
                                  __/ |     
   Cabinet Auto Update Script    |___/      
EOF
echo -e "\e[0m"
echo "=========================================="
echo ""

WORK_DIR="/opt/remnawave-bedolaga-telegram-bot"

# Проверка существования директории
if [ ! -d "$WORK_DIR" ]; then
    echo -e "\e[31m[!] Ошибка: Директория $WORK_DIR не найдена!\e[0m"
    exit 1
fi

cd "$WORK_DIR" || exit

echo -e "\e[33m[*] Удаляем старые файлы кабинета...\e[0m"
sudo rm -rf cabinet-dist
sudo rm -rf /srv/cabinet

echo -e "\e[33m[*] Скачиваем свежий образ...\e[0m"
docker pull ghcr.io/bedolaga-dev/bedolaga-cabinet:latest

echo -e "\e[33m[*] Извлекаем статику из контейнера...\e[0m"
docker create --name tmp_cabinet ghcr.io/bedolaga-dev/bedolaga-cabinet:latest
docker cp tmp_cabinet:/usr/share/nginx/html ./cabinet-dist
docker rm tmp_cabinet

echo -e "\e[33m[*] Копируем файлы в /srv/cabinet...\e[0m"
sudo mkdir -p /srv/cabinet
sudo cp -r ./cabinet-dist/* /srv/cabinet/

echo ""
echo "=========================================="
echo " Выбери способ перезагрузки Caddy:"
echo "=========================================="
echo " 1) Caddy через APT (systemctl)"
echo " 2) Caddy через Docker"
echo " 3) Пропустить перезагрузку"
echo "=========================================="
# Читаем ввод напрямую с терминала, чтобы curl | bash не ломал скрипт
read -rp "Введи цифру (1/2/3): " CADDY_CHOICE < /dev/tty
echo ""

case $CADDY_CHOICE in
    1)
        echo -e "\e[33m[*] Перезагружаем Caddy (APT)...\e[0m"
        caddy reload --config /etc/caddy/Caddyfile
        sudo systemctl restart caddy
        ;;
    2)
        echo -e "\e[33m[*] Перезагружаем Caddy (Docker)...\e[0m"
        docker exec caddy caddy reload --config /etc/caddy/Caddyfile
        ;;
    3|*)
        echo -e "\e[33m[*] Перезагрузка Caddy пропущена.\e[0m"
        ;;
esac

echo ""
echo -e "\e[32m==========================================\e[0m"
echo -e "\e[32m           Обновление завершено!          \e[0m"
echo -e "\e[32m==========================================\e[0m"
