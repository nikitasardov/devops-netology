# Ansible Playbook для установки ClickHouse и Vector

Простой playbook для учебного задания по Ansible.

## Описание

Playbook устанавливает:
1. **ClickHouse** - база данных для хранения логов
2. **Vector** - система для отправки логов в ClickHouse

## Структура

```
playbook/
├── inventory/prod.yml          # Инвентарь с Docker хостами
├── group_vars/
│   ├── clickhouse/vars.yml     # Переменные ClickHouse
│   └── vector/vars.yml         # Переменные Vector
├── templates/
│   └── vector.toml.j2         # Конфигурация Vector
├── site.yml                   # Основной playbook
└── README.md                  # Этот файл
```

## Переменные

### ClickHouse
- `clickhouse_version`: "22.3.3.44"

### Vector  
- `vector_version`: "0.28.1"

## Использование

1. **Проверка синтаксиса:**
   ```bash
   ansible-lint site.yml
   ```

2. **Тестовый запуск:**
   ```bash
   ansible-playbook -i inventory/prod.yml site.yml --check
   ```

3. **Запуск с изменениями:**
   ```bash
   ansible-playbook -i inventory/prod.yml site.yml --diff
   ```

4. **Полный запуск:**
   ```bash
   ansible-playbook -i inventory/prod.yml site.yml
   ```

## Что делает playbook

### ClickHouse
- Скачивает и устанавливает ClickHouse
- Создает базу данных "logs"

### Vector
- Скачивает и распаковывает Vector
- Создает символическую ссылку на бинарный файл
- Развертывает конфигурацию через Jinja2 шаблон
- Настраивает отправку логов в ClickHouse

## Handlers

- `Start clickhouse service` - перезапуск ClickHouse
- `Restart vector service` - перезапуск Vector

## Результаты тестирования

✅ **ansible-lint** - ошибок нет  
✅ **--check** - проходит проверку  
✅ **--diff** - показывает изменения  
✅ **Идемпотентность** - повторный запуск не изменяет систему
