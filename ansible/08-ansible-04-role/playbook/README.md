# Ansible Playbook для установки ClickHouse, Vector и Lighthouse

Этот playbook автоматизирует установку и настройку трех компонентов системы логирования на виртуальных машинах Yandex Cloud.

## Описание

Playbook состоит из трех основных plays:

1. **Install Clickhouse** - устанавливает ClickHouse Server и Client на CentOS
2. **Install Vector** - устанавливает и настраивает Vector для отправки логов в ClickHouse
3. **Install Lighthouse** - устанавливает и настраивает Lighthouse веб-интерфейс с nginx

## Структура проекта

```
playbook/
├── inventory/
│   └── prod.yml              # Инвентарь с виртуальными машинами
├── group_vars/
│   ├── clickhouse/
│   │   └── vars.yml          # Переменные для ClickHouse
│   ├── vector/
│   │   └── vars.yml          # Переменные для Vector
│   └── lighthouse/
│       └── vars.yml          # Переменные для Lighthouse
├── templates/
│   ├── vector.toml.j2        # Конфигурация Vector
│   └── lighthouse.conf.j2    # Конфигурация nginx для Lighthouse
├── site.yml                  # Основной playbook
├── ansible.cfg              # Конфигурация Ansible
└── README.md                # Этот файл
```

## Переменные

### ClickHouse (group_vars/clickhouse/vars.yml)
- `clickhouse_version`: "22.3.3.44" - версия ClickHouse

### Vector (group_vars/vector/vars.yml)
- `vector_version`: "0.28.1" - версия Vector

### Lighthouse (group_vars/lighthouse/vars.yml)
- `lighthouse_version`: "master" - версия Lighthouse
- `lighthouse_install_dir`: "/var/www/lighthouse" - директория установки
- `lighthouse_nginx_config`: "/etc/nginx/sites-available/lighthouse" - конфигурация nginx

## Использование

### Предварительные требования
- Ansible 2.10+
- Виртуальные машины в Yandex Cloud
- SSH ключи настроены на всех хостах
- Пользователь `admin` на всех хостах

### Запуск playbook

1. **Проверка синтаксиса:**
   ```bash
   ansible-lint site.yml
   ```

2. **Тестовый запуск (dry-run):**
   ```bash
   ansible-playbook site.yml --check
   ```

3. **Запуск с отображением изменений:**
   ```bash
   ansible-playbook site.yml --diff
   ```

4. **Полный запуск:**
   ```bash
   ansible-playbook site.yml
   ```

5. **Запуск только для определенной группы:**
   ```bash
   ansible-playbook site.yml --limit lighthouse
   ```

## Что делает playbook

### ClickHouse Play
- Скачивает RPM пакеты ClickHouse
- Устанавливает пакеты через yum
- Запускает сервис ClickHouse
- Создает базу данных "logs"

### Vector Play
- Скачивает и распаковывает Vector
- Создает символическую ссылку на бинарный файл
- Развертывает конфигурацию через Jinja2 шаблон
- Настраивает отправку логов в ClickHouse

### Lighthouse Play
- Обновляет apt cache
- Устанавливает nginx
- Скачивает и распаковывает Lighthouse
- Копирует файлы Lighthouse в веб-директорию
- Настраивает nginx для обслуживания Lighthouse
- Включает сайт nginx

## Handlers

- `Start clickhouse service` - перезапускает ClickHouse при изменении конфигурации
- `Restart vector service` - перезапускает Vector при изменении конфигурации
- `Restart nginx` - перезапускает nginx при изменении конфигурации

## Результаты тестирования

✅ **ansible-lint** - ошибок нет  
✅ **--check** - проходит проверку  
✅ **--diff** - показывает изменения  
✅ **Идемпотентность** - повторный запуск не изменяет систему

## Доступ к сервисам

После выполнения playbook будут доступны:
- **ClickHouse**: `http://clickhouse-01:8123` - веб-интерфейс ClickHouse
- **Lighthouse**: `http://lighthouse-01` - веб-интерфейс для работы с ClickHouse
- **Vector**: работает в фоновом режиме, отправляет логи в ClickHouse