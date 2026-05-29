
# 🔄 Bedolaga Cabinet Auto Update

Простой bash-скрипт для автоматизации процесса обновления веб-кабинета **Bedolaga Bot**. 

Скрипт самостоятельно скачивает последнюю версию образа, извлекает статические файлы, обновляет нужные директории, перезапускает контейнеры бота и предлагает удобное меню для перезагрузки веб-сервера Caddy.

## ⚡ Быстрый запуск одной командой

Вам не нужно ничего скачивать вручную. Просто скопируйте эту команду и вставьте в терминал вашего сервера:

```bash
curl -sSL [https://raw.githubusercontent.com/Zover1337/BedolagaCabinetAutoUpd/refs/heads/main/cabinet_updater.sh](https://raw.githubusercontent.com/Zover1337/BedolagaCabinetAutoUpd/refs/heads/main/cabinet_updater.sh) | bash

```

---

## 🛠 Ручная установка (Альтернативный способ)

Если вы хотите сначала скачать и посмотреть код скрипта перед запуском:

**1. Скачайте скрипт:**

```bash
wget [https://raw.githubusercontent.com/Zover1337/BedolagaCabinetAutoUpd/refs/heads/main/cabinet_updater.sh](https://raw.githubusercontent.com/Zover1337/BedolagaCabinetAutoUpd/refs/heads/main/cabinet_updater.sh)

```

**2. Сделайте его исполняемым:**

```bash
chmod +x cabinet_updater.sh

```

**3. Запустите обновление:**

```bash
./cabinet_updater.sh

```

---

## 🚀 Что делает скрипт?

* Удобно останавливает текущие контейнеры бота (`docker compose down`).
* Безопасно очищает старые файлы кабинета.
* Скачивает свежий образ `ghcr.io/bedolaga-dev/bedolaga-cabinet:latest`.
* Извлекает обновленную статику и копирует её в `/srv/cabinet`.
* Снова поднимает контейнеры в фоновом режиме (`docker compose up -d`).
* Интерактивно предлагает перезагрузить **Caddy** (через APT системным демоном или через Docker).

## ⚠️ Требования

Для корректной работы скрипта убедитесь, что:

* У вашего пользователя есть права `sudo`.
* Установлен `curl` (или `wget`), `docker` и плагин `docker compose`.
* Бот располагается в стандартной директории: `/opt/remnawave-bedolaga-telegram-bot` (именно туда переходит скрипт для команд `docker compose`).
