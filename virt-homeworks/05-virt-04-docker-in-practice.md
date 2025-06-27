# Домашнее задание к занятию 5. «Практическое применение Docker»

---
## Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

---

## Задача 0
1. Убедитесь что у вас НЕ(!) установлен ```docker-compose```, для этого получите следующую ошибку от команды ```docker-compose --version```
В случае наличия установленного в системе ```docker-compose``` - удалите его.  
2. Убедитесь что у вас УСТАНОВЛЕН ```docker compose```(без тире) версии не менее v2.24.X, для это выполните команду ```docker compose version```  

```
test@compute-vm-2-2-30-hdd-1749390515746:~$ docker compose version
Docker Compose version v2.36.2
```
---

## Задача 1
1. Сделайте в своем GitHub пространстве fork [репозитория](https://github.com/netology-code/shvirtd-example-python).

2. Создайте файл ```Dockerfile.python``` на основе существующего `Dockerfile`:
   - Используйте базовый образ ```python:3.12-slim```
   - Обязательно используйте конструкцию ```COPY . .``` в Dockerfile
   - Создайте `.dockerignore` файл для исключения ненужных файлов
   - Используйте ```CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]``` для запуска
   - Протестируйте корректность сборки 
```
ai@ai:/var/www/study/netology/devops/devops-netology/shvirtd-example-python (main)$: docker build -t py312:tst -f Dockerfile.python .
[+] Building 1.5s (8/8) FINISHED                                                                                                                                                        docker:default
 => [internal] load build definition from Dockerfile.python                                                                                                                                       0.0s
 => => transferring dockerfile: 265B                                                                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/python:3.12-slim                                                                                                                               1.2s
 => [auth] library/python:pull token for registry-1.docker.io                                                                                                                                     0.0s
 => [internal] load .dockerignore                                                                                                                                                                 0.0s
 => => transferring context: 34B                                                                                                                                                                  0.0s
 => [internal] load build context                                                                                                                                                                 0.0s
 => => transferring context: 148.52kB                                                                                                                                                             0.0s
 => CACHED [1/2] FROM docker.io/library/python:3.12-slim@sha256:e55523f127124e5edc03ba201e3dbbc85172a2ec40d8651ac752364b23dfd733                                                                  0.0s
 => [2/2] COPY . .                                                                                                                                                                                0.1s
 => exporting to image                                                                                                                                                                            0.1s
 => => exporting layers                                                                                                                                                                           0.1s
 => => writing image sha256:c6e862ab73b17c8b719538a42009a706fe9b1b4196de49e16af994a475d210e5                                                                                                      0.0s
 => => naming to docker.io/library/py312:tst                                                                                                                                                      0.0s
ai@ai:/var/www/study/netology/devops/devops-netology/shvirtd-example-python (main)$: 
```
3. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker, с помощью venv. (Mysql БД можно запустить в docker run).
```
   к сожалению, не успеваю сделать дополнительное, нужно догонять
```
4. (Необязательная часть, *) Изучите код приложения и добавьте управление названием таблицы через ENV переменную.
```
   к сожалению, не успеваю сделать дополнительное, нужно догонять
```

---

## Задача 2 (*)
```
   к сожалению, не успеваю сделать дополнительное, нужно догонять
```

1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
4. Просканируйте образ на уязвимости.
5. В качестве ответа приложите отчет сканирования.

## Задача 3
1. Изучите файл "proxy.yaml"
2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".
3. Опишите в файле ```compose.yaml``` следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!
```
ai@ai:/var/www/study/netology/devops/devops-netology/shvirtd-example-python (main)$: docker compose -f compose.yaml build --no-cache
WARN[0000] /var/www/study/netology/devops/devops-netology/shvirtd-example-python/proxy.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
Compose can now delegate builds to bake for better performance.
 To do so, set COMPOSE_BAKE=true.
[+] Building 12.3s (12/12) FINISHED                                                                                                                                                     docker:default
 => [web internal] load build definition from Dockerfile.python                                                                                                                                   0.0s
 => => transferring dockerfile: 339B                                                                                                                                                              0.0s
 => [web internal] load metadata for docker.io/library/python:3.12-slim                                                                                                                           1.1s
 => [web auth] library/python:pull token for registry-1.docker.io                                                                                                                                 0.0s
 => [web internal] load .dockerignore                                                                                                                                                             0.0s
 => => transferring context: 34B                                                                                                                                                                  0.0s
 => [web 1/5] FROM docker.io/library/python:3.12-slim@sha256:e55523f127124e5edc03ba201e3dbbc85172a2ec40d8651ac752364b23dfd733                                                                     0.0s
 => [web internal] load build context                                                                                                                                                             0.0s
 => => transferring context: 9.85kB                                                                                                                                                               0.0s
 => CACHED [web 2/5] WORKDIR /app                                                                                                                                                                 0.0s
 => [web 3/5] COPY requirements.txt .                                                                                                                                                             0.0s
 => [web 4/5] RUN pip install -r requirements.txt                                                                                                                                                10.0s
 => [web 5/5] COPY . .                                                                                                                                                                            0.1s 
 => [web] exporting to image                                                                                                                                                                      0.9s 
 => => exporting layers                                                                                                                                                                           0.9s 
 => => writing image sha256:35203b1ed0c16aeba85aee97a654f0a7fe2d41f67bfcde3e3def336377dfbec8                                                                                                      0.0s 
 => => naming to docker.io/library/shvirtd-example-python-web                                                                                                                                     0.0s 
 => [web] resolving provenance for metadata file                                                                                                                                                  0.0s 
[+] Building 1/1
 ✔ web  Built                                                                                                                                                                                     0.0s 
ai@ai:/var/www/study/netology/devops/devops-netology/shvirtd-example-python (main)$: docker compose -f compose.yaml up -d
WARN[0000] /var/www/study/netology/devops/devops-netology/shvirtd-example-python/proxy.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 5/5
 ✔ Network shvirtd-example-python_backend            Created                                                                                                                                      0.0s 
 ✔ Container shvirtd-example-python-web-1            Started                                                                                                                                      0.2s 
 ✔ Container shvirtd-example-python-ingress-proxy-1  Started                                                                                                                                      0.2s 
 ✔ Container shvirtd-example-python-reverse-proxy-1  Started                                                                                                                                      0.3s 
 ✔ Container shvirtd-example-python-db-1             Started                                                                                                                                      0.3s 
ai@ai:/var/www/study/netology/devops/devops-netology/shvirtd-example-python (main)$: docker ps -a
CONTAINER ID   IMAGE                                COMMAND                  CREATED          STATUS                      PORTS                                             NAMES
c9ca4a288b09   mysql:8                              "docker-entrypoint.s…"   15 seconds ago   Up 15 seconds               3306/tcp, 33060/tcp                               shvirtd-example-python-db-1
09c147b9ed5a   shvirtd-example-python-web           "uvicorn main:app --…"   15 seconds ago   Up 15 seconds                                                                 shvirtd-example-python-web-1
434a6476ba9a   haproxy:2.4                          "docker-entrypoint.s…"   15 seconds ago   Up 15 seconds               127.0.0.1:8080->8080/tcp                          shvirtd-example-python-reverse-proxy-1
e71d2759d5a6   nginx:1.21.1                         "/docker-entrypoint.…"   15 seconds ago   Up 15 seconds                                                                 shvirtd-example-python-ingress-proxy-1
```

2. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ```curl -L http://127.0.0.1:8090``` должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: ```docker ps -a ``` и ```docker logs <container_name>``` . Если вместо IP-адреса вы получаете информационную ошибку --убедитесь, что вы шлете запрос на порт ```8090```, а не 5000.
```
ai@ai:/var/www/study/netology/devops/devops-netology/shvirtd-example-python (main)$: curl -L http://127.0.0.1:8090
"TIME: 2025-06-27 12:19:13, IP: 127.0.0.1"
```
5. Подключитесь к БД mysql с помощью команды ```docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT * from requests LIMIT 10;```.
```
ai@ai:~$: docker exec -ti shvirtd-example-python-db-1 mysql -uapp -pQwErTy1234
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 13
Server version: 8.4.5 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| performance_schema |
| virtd              |
+--------------------+
3 rows in set (0.00 sec)

mysql> use virtd; show tables; SELECT * from requests LIMIT 10;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
+-----------------+
| Tables_in_virtd |
+-----------------+
| requests        |
+-----------------+
1 row in set (0.00 sec)

+----+---------------------+------------+
| id | request_date        | request_ip |
+----+---------------------+------------+
|  1 | 2025-06-27 12:18:08 | 127.0.0.1  |
|  2 | 2025-06-27 12:18:17 | 127.0.0.1  |
|  3 | 2025-06-27 12:19:13 | 127.0.0.1  |
+----+---------------------+------------+
3 rows in set (0.00 sec)

mysql> exit
```

6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.
```
ai@ai:/var/www/study/netology/devops/devops-netology/shvirtd-example-python (main)$: docker compose down
WARN[0000] /var/www/study/netology/devops/devops-netology/shvirtd-example-python/proxy.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 5/5
 ✔ Container shvirtd-example-python-web-1            Removed                                                                                                                                      0.4s 
 ✔ Container shvirtd-example-python-reverse-proxy-1  Removed                                                                                                                                      0.2s 
 ✔ Container shvirtd-example-python-db-1             Removed                                                                                                                                      1.5s 
 ✔ Container shvirtd-example-python-ingress-proxy-1  Removed                                                                                                                                      0.1s 
 ✔ Network shvirtd-example-python_backend            Removed                                                                                                                                      0.1s 
ai@ai:/var/www/study/netology/devops/devops-netology/shvirtd-example-python (main)$: 
```

## Задача 4
1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).
2. Подключитесь к Вм по ssh и установите docker.
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy. Трафик должен пройти через цепочки: Пользователь → Internet → Nginx → HAProxy → FastAPI(запись в БД) → HAProxy → Nginx → Internet → Пользователь
5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
6. Повторите SQL-запрос на сервере и приложите скриншот и ссылку на fork.
```
https://github.com/nikitasardov/shvirtd-example-python
```

## Задача 5 (*)
```
   к сожалению, не успеваю сделать дополнительное, нужно догонять
```
1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."
2. Протестируйте ручной запуск
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!
4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты  действий .

## Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты  действий .

## Задача 6.2 (**)
```
   к сожалению, не успеваю сделать дополнительное, нужно догонять
```
Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.  
Предоставьте скриншоты  действий .

## Задача 7 (***)
```
   к сожалению, не успеваю сделать дополнительное, нужно догонять
```
Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
Предоставьте скриншоты  действий .