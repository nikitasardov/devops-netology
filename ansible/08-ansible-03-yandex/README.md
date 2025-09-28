# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.
![yc](https://i.postimg.cc/263xyKpM/photo-2025-09-28-09-43-43.jpg)
![lighthouse](https://i.postimg.cc/MH2jwPz5/photo-2025-09-28-09-43-47.jpg)
![vector](https://i.postimg.cc/VL45ZL0j/photo-2025-09-28-09-43-52.jpg)
![clickhouse](https://i.postimg.cc/pLFbhsvh/photo-2025-09-28-09-43-59.jpg)
![playbook success](https://i.postimg.cc/PrMK6ZMz/2025-09-28-09-52.png)
---
## Описание плейбука

Плейбук выполняет установку и настройку ClickHouse, Lighthouse и Vector на соответствующих хостах. Cкачивает необходимые пакеты, устанавливает их, копирует конфиги из шаблонов j2.

Во многих тасках добавлено  "when: not ansible_check_mode" чтобы не было ошибок при запусках с --check

## Установка и настройка ClickHouse

### Параметры
hosts: clickhouse </br>
become: true

### Хэндлеры
Start clickhouse service </br>
Перезапускает службу ClickHouse </br>
Чтобы при запуске с --check не было ошибок, добавлено: "changed_when: false" </br>
Теги: clickhouse, start

### Задачи
* Get clickhouse distrib и Get clickhouse common stati</br>
Скачивает дистрибутивы ClickHouse </br>
Теги: clickhouse, distr

* Install clickhouse packages </br>
Устанавливает пакеты ClickHouse </br>
Теги: clickhouse, distr </br>
Notify: Start clickhouse service

* Flush handlers </br>
Выполняет все отложенные хэндлеры </br>
Теги: clickhouse, start

* Start clickhouse service </br>
Запускает ClickHouse
Теги: clickhouse, start

* Wait for Clickhouse to start </br>
Ожидает, пока ClickHouse станет доступен на порту 8123 </br>
Теги: clickhouse, wait

* Create database </br>
Создаёт базу данных logs в ClickHouse

## Установка и настройка Vector

### Параметры
hosts: vector </br>
become: true

### Хэндлеры
Restart vector service </br>
Перезапускает службу Vector
Теги: vector, restart

### Задачи
* Download Vector </br>
Скачивает дистрибутив Vector </br>
Теги: vector, distr

* Extract Vector </br>
Распаковывает архив Vector
Теги: vector, distr

* Create vector binary symlink </br>
Создаёт симлинк на бинарный файл Vector
Теги: vector, distr

* Deploy vector config </br>
Развёртывает конфигурационный файл Vector из шаблона </br>
Вызывает хэндлер Restart vector service
Теги: vector, config

## Установка и настройка Nginx
была сложность с установкой nginx на centOS, решил использовать ВМ с ubuntu для этого хоста </br>
в хэндлере не было необходимости
### Параметры
hosts: lighthouse </br>
become: true

### Задачи
* Update apt cache </br>
Обновляет кэш apt
Теги: nginx, install

* Install nginx </br>
Устанавливает nginx
Теги: nginx, install

* Start nginx </br>
Запускает и включает nginx
Теги: nginx, start

## Установка и настройка Lighthouse

### Параметры
hosts: lighthouse </br>
become: true

### Хэндлеры
Restart nginx </br>
Перезапускает службу nginx </br>
Теги: lighthouse, nginx, start

### Задачи
* Create lighthouse directory </br>
Создаёт директорию для Lighthouse </br>
Теги: lighthouse, install

* Download Lighthouse </br>
Скачивает Lighthouse </br>
Теги: lighthouse, distr

* Extract Lighthouse </br>
Распаковывает Lighthouse </br>
Теги: lighthouse, install

* Copy Lighthouse files </br>
Копирует файлы Lighthouse в директорию установки </br>
Теги: lighthouse, install

* Deploy nginx config </br>
Копирует конфиг nginx для lighthouse из шаблона </br>
Notify: Restart nginx </br>
Теги: lighthouse, nginx, start

* Enable nginx site </br>
Включает сайт nginx, заменяет симлинк на дефолтный конфиг, допустимо, т.к. lighthouse единственный сервис на этом хосте</br>
Notify: Restart nginx </br>
Теги: lighthouse, nginx, start

## Переменные 
clickhouse_version: Версия ClickHouse для установки </br>
clickhouse_packages: Список пакетов ClickHouse для установки </br>
vector_version: Версия Vector для установки. </br>
vector_config_path: Путь для конфигурационного файла Vector </br>
lighthouse_version: версия lighthouse </br>
lighthouse_install_dir: путь к lighthouse на целевом хосте </br>
lighthouse_nginx_config: путь к конфигу nginx для lighthouse на целевом хосте

---