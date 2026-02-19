#!/bin/bash
# Настройка сервера

set -e

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 🚀 Настройка сервера ===${NC}"
echo ""

# [1/7] Обновление системы
echo -e "${GREEN}[1/7] Обновление пакетов...${NC}"
apt update && apt upgrade -y

# [2/7] Установка зависимостей
echo -e "${GREEN}[2/7] Установка curl, gnupg, ufw...${NC}"
apt install -y curl gnupg ufw

# [3/7] Настройка фаервола
echo -e "${GREEN}[3/7] Настройка фаервола (UFW)...${NC}"
ufw --force enable
ufw allow 22/tcp    # SSH — чтобы не потерять доступ
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS (для Reality-сертификатов)
ufw allow 2053/tcp  # Порт панели 3x-ui
echo -e "${YELLOW}✅ Открыты порты: 22, 80, 443, 2053${NC}"
echo ""
echo -e "${YELLOW}📌 Пример: чтобы открыть порт 4433 для нового VLESS-подключения:${NC}"
echo "   sudo ufw allow 4433/tcp"
echo -e "${YELLOW}📌 Проверить статус фаервола:${NC}"
echo "   sudo ufw status verbose"
echo ""

# [4/9] Установка Docker (код из ТЗ)
echo -e "${GREEN}[4/9] Установка Docker...${NC}"
apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "${GREEN}[5/9] Настройка Docker...${NC}"
systemctl enable docker
systemctl start docker

# [6/9] Запуск 3x-ui панели (команда из ТЗ, без изменений)
echo -e "${GREEN}[6/9] Запуск панели 3x-ui...${NC}"
docker run -itd \
    --name=3x-ui-new \
    --restart=always \
    --network=host \
    -v /opt/3x-ui/db:/etc/x-ui/ \
    -v /opt/3x-ui/cert:/root/cert/ \
    ghcr.io/mhsanaei/3x-ui:latest

sleep 3

# [7/9] Генерация пароля и вывод информации
echo -e "${GREEN}[7/9] Генерация безопасного пароля...${NC}"
RANDOM_PASS=$(openssl rand -base64 12 | tr -d '=+/' | cut -c1-16)

# Получение IP-адреса сервера
SERVER_IP=$(curl -s ifconfig.me)

echo ""
echo -e "${GREEN}=== ✅ Установка завершена! ===${NC}"
echo ""
echo -e "${YELLOW}🌐 Панель управления:${NC}"
echo "   http://${SERVER_IP}:2053"
echo ""
echo -e "${YELLOW}🔑 Данные для первого входа:${NC}"
echo "   Логин: admin"
echo "   Пароль: admin"
echo ""
echo -e "${RED}⚠️  СРАЗУ после входа смените пароль!${NC}"
echo "   1. Откройте: http://${SERVER_IP}:2053/panel/settings"
echo "   2. Перейдите в «Настройки панели» (далее на вторую вкладку)"
echo "   3. Установите новый пароль:"
echo -e "      ${GREEN}${RANDOM_PASS}${NC}"
echo "   4. Нажмите «Сохранить»"
echo ""
echo -e "${YELLOW}📡 Протокол по умолчанию: VLESS + Reality + gRPC${NC}"
echo "   При создании нового подключения:"
echo "   - Порт можно выбрать любой (например, 4433)"
echo "   - Не забудьте открыть его в фаерволе: sudo ufw allow 4433/tcp"
echo ""
echo -e "${GREEN}🎉 Готово! Теперь настройте подключение в панели и добавьте его в клиентское приложение.${NC}"