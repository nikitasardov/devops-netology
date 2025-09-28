# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
```
$: ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
Warning: the ECDSA host key for 'github.com' differs from the key for the IP address '140.82.121.3'
Offending key for IP in /home/ai/.ssh/known_hosts:82
Matching host key in /home/ai/.ssh/known_hosts:103
Are you sure you want to continue connecting (yes/no)? yes
- extracting clickhouse to /var/www/study/netology/devops/devops-netology/ansible/08-ansible-04-role/playbook/roles/clickhouse
- clickhouse (1.13) was installed successfully
```
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9.  Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Решение

Таски разложены по ролям:

ClickHouse: https://github.com/AlexeySetevoi/ansible-clickhouse.git

Vector: https://github.com/nikitasardov/vector-role.git

LightHouse: https://github.com/nikitasardov/lighthouse-role

Nginx: https://github.com/nikitasardov/nginx-role.git

В playbook внесены исправления для использования ролей.

![playbook](https://i.postimg.cc/rynP6B6K/2025-09-28-15-27.png)

Папка с ролями добавлена в .gitignore

Все необходимые роли добавлены в requirements.yml
![yc](https://i.postimg.cc/CMBQgvwq/2025-09-28-15-27-1.png)

Была проблема со скачиванием одной из созданных ролей. Проблема решилась исправлением структуры yaml файла.
![install roles](https://i.postimg.cc/pTNPBmCV/2025-09-28-15-26.png)

Одна из прерываемых ВМ успела остановиться, пришлось менять ip в inventory
![yc](https://i.postimg.cc/Fsh3ZRCp/2025-09-28-15-36.png)


![yc](https://i.postimg.cc/263xyKpM/photo-2025-09-28-09-43-43.jpg)

```
В итоге все успешно отработало в новой версии с ролями
...
TASK [lighthouse : Copy Lighthouse files] ******************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse : Deploy nginx config] ********************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse : Enable nginx site] **********************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [nginx : Update apt cache] ****************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [nginx : Install nginx] *******************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [nginx : Start nginx] *********************************************************************************************************************************************************************************
ok: [lighthouse-01]

PLAY RECAP *************************************************************************************************************************************************************************************************
clickhouse-01              : ok=23   changed=0    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
lighthouse-01              : ok=10   changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
---