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

---

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
```
Ресурсы
Платформа
Intel Cascade Lake
Гарантированная доля vCPU
5%
​vCPU
2
RAM
2 ГБ
Объём дискового пространства
30 ГБ
Прерываемая
Да
```
2. Подключитесь к Вм по ssh и установите docker.
```
test@compute-vm-2-2-30-hdd-1749390515746:~$ docker --version
Docker version 28.2.2, build e6534b4
test@compute-vm-2-2-30-hdd-1749390515746:~$ 
```
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
![](https://i.postimg.cc/MHbVbyWn/2025-07-17-12-39.png)
4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```.
![](https://i.postimg.cc/MHxjTvyq/2025-07-17-12-41.png)
 Таким образом трафик будет направлен в ingress-proxy. Трафик должен пройти через цепочки: Пользователь → Internet → Nginx → HAProxy → FastAPI(запись в БД) → HAProxy → Nginx → Internet → Пользователь
5. (Необязательная часть)
6. Повторите SQL-запрос на сервере и приложите скриншот и ссылку на fork.
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| virtd              |
+--------------------+
5 rows in set (0.00 sec)

mysql> use virtd;
Database changed
mysql> show tables;
+-----------------+
| Tables_in_virtd |
+-----------------+
| requests        |
+-----------------+
1 row in set (0.00 sec)

mysql> select * from requests;
+----+---------------------+-----------------+
| id | request_date        | request_ip      |
+----+---------------------+-----------------+
|  1 | 2025-07-17 09:50:12 | 109.124.228.85  |
|  2 | 2025-07-17 09:50:29 | 195.211.27.85   |
|  3 | 2025-07-17 09:50:29 | 185.37.147.117  |
|  4 | 2025-07-17 09:50:29 | 195.137.244.1   |
|  5 | 2025-07-17 09:50:29 | 45.159.248.77   |
|  6 | 2025-07-17 09:50:29 | 167.235.135.184 |
|  7 | 2025-07-17 09:50:29 | 78.40.116.61    |
|  8 | 2025-07-17 09:50:29 | 185.209.161.145 |
|  9 | 2025-07-17 09:50:29 | 194.26.229.20   |
| 10 | 2025-07-17 09:50:29 | 195.154.114.92  |
| 11 | 2025-07-17 09:50:29 | 185.25.204.60   |
| 12 | 2025-07-17 09:50:29 | 185.19.33.131   |
| 13 | 2025-07-17 09:50:29 | 185.221.199.82  |
| 14 | 2025-07-17 09:50:29 | 185.224.3.111   |
| 15 | 2025-07-17 09:50:29 | 185.130.104.238 |
| 16 | 2025-07-17 09:50:29 | 194.146.57.64   |
| 17 | 2025-07-17 09:50:29 | 94.183.157.253  |
| 18 | 2025-07-17 09:50:29 | 65.109.182.130  |
| 19 | 2025-07-17 09:50:29 | 185.23.17.21    |
| 20 | 2025-07-17 09:50:29 | 185.83.213.25   |
| 21 | 2025-07-17 09:50:30 | 178.239.146.199 |
| 22 | 2025-07-17 09:50:29 | 178.216.200.169 |
| 23 | 2025-07-17 09:50:30 | 198.135.169.20  |
| 24 | 2025-07-17 09:50:29 | 77.92.151.181   |
| 25 | 2025-07-17 09:50:29 | 93.123.16.89    |
| 26 | 2025-07-17 09:50:30 | 45.252.248.142  |
| 27 | 2025-07-17 09:50:29 | 185.86.77.126   |
| 28 | 2025-07-17 09:50:29 | 179.43.148.195  |
| 29 | 2025-07-17 09:50:29 | 195.211.24.48   |
| 30 | 2025-07-17 09:50:29 | 185.255.91.239  |
| 31 | 2025-07-17 09:50:29 | 77.75.230.51    |
| 32 | 2025-07-17 09:50:29 | 185.185.132.179 |
| 33 | 2025-07-17 09:50:29 | 45.9.168.235    |
| 34 | 2025-07-17 09:50:29 | 88.135.72.11    |
| 35 | 2025-07-17 09:50:30 | 64.72.205.76    |
| 36 | 2025-07-17 09:50:30 | 185.24.253.139  |
| 37 | 2025-07-17 09:50:30 | 185.120.77.165  |
| 38 | 2025-07-17 09:50:29 | 88.119.179.10   |
| 39 | 2025-07-17 09:50:29 | 194.5.50.94     |
| 40 | 2025-07-17 09:50:29 | 91.231.182.39   |
| 41 | 2025-07-17 09:50:29 | 109.122.245.39  |
| 42 | 2025-07-17 09:50:29 | 178.17.171.235  |
| 43 | 2025-07-17 09:50:29 | 147.45.113.30   |
| 44 | 2025-07-17 09:50:29 | 145.224.101.208 |
| 45 | 2025-07-17 09:50:30 | 103.99.52.202   |
| 46 | 2025-07-17 09:50:30 | 38.145.202.12   |
| 47 | 2025-07-17 09:50:30 | 185.105.238.209 |
| 48 | 2025-07-17 09:50:31 | 103.42.116.205  |
| 49 | 2025-07-17 09:50:30 | 185.143.223.66  |
| 50 | 2025-07-17 09:50:33 | 217.15.166.168  |
| 51 | 2025-07-17 09:50:33 | 45.162.230.209  |
| 52 | 2025-07-17 09:50:33 | 141.98.234.68   |
| 53 | 2025-07-17 09:50:33 | 109.248.161.218 |
| 54 | 2025-07-17 09:50:33 | 103.214.169.52  |
| 55 | 2025-07-17 09:50:33 | 46.250.241.154  |
+----+---------------------+-----------------+
55 rows in set (0.00 sec)

mysql> ^DBye
test@compute-vm-2-2-30-hdd-1749390515746:/opt$
```

![](https://i.postimg.cc/tC9prhq9/2025-07-17-12-52.png)

```
https://github.com/nikitasardov/shvirtd-example-python
```

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive
![](https://i.postimg.cc/C56jPbZJ/dive.png)


 и docker save.

```
ai@ai:/var/www/study/netology/devops/devops-netology (master)$: docker save hashicorp/terraform:latest -o terraform-image.tar
ai@ai:/var/www/study/netology/devops/devops-netology (master)$: mkdir -p terraform_extracted
ai@ai:/var/www/study/netology/devops/devops-netology (master)$: tar xf terraform-image.tar -C terraform_extracted
ai@ai:/var/www/study/netology/devops/devops-netology (master)$: cd terraform_extracted/
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: ls -la
total 28
drwxrwxr-x 3 ai ai       4096 июл 17 13:35 .
drwxr-x--- 6 ai www-data 4096 июл 17 13:35 ..
drwxr-xr-x 3 ai ai       4096 июн 11 13:26 blobs
-rw-r--r-- 1 ai ai        367 янв  1  1970 index.json
-rw-r--r-- 1 ai ai       1390 янв  1  1970 manifest.json
-rw-r--r-- 1 ai ai         31 янв  1  1970 oci-layout
-rw-r--r-- 1 ai ai        102 янв  1  1970 repositories
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: find -type f -name terraform
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: find . -type f -name terraform
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: cd ../
ai@ai:/var/www/study/netology/devops/devops-netology (master)$: find terraform_extracted -name layer.tar -exec tar tf {} \; | grep '/bin/terraform'
ai@ai:/var/www/study/netology/devops/devops-netology (master)$: find . -type f -name 'terraform*'
./terraform
./terraform-image.tar
./terraform-bin
ai@ai:/var/www/study/netology/devops/devops-netology (master)$: cd terraform_extracted/
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: find .  -name 'terraform*'
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: ls -la blobs/
total 12
drwxr-xr-x 3 ai ai 4096 июн 11 13:26 .
drwxrwxr-x 3 ai ai 4096 июл 17 13:35 ..
drwxr-xr-x 2 ai ai 4096 июл 17 13:34 sha256
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: ls -la blobs/sha256/
total 120072
drwxr-xr-x 2 ai ai     4096 июл 17 13:34 .
drwxr-xr-x 3 ai ai     4096 июн 11 13:26 ..
-rw-r--r-- 1 ai ai      482 июн 11 13:26 4cd4d392a58866c5787c8d21921400d7d18547a8a006d1b992ab37156fc71d8a
-rw-r--r-- 1 ai ai     8704 июн 11 13:26 6bb76c4390d16c34eb26fa6e5f13f650dbac732c2dd1add8b3771b5c62df11f4
-rw-r--r-- 1 ai ai 93604352 июн 11 13:26 6be188821a1e6d0af92854aa290cf75a053ad8525dfc35f3d7d256daeb20bc34
-rw-r--r-- 1 ai ai      406 июн 11 13:26 6fe1930671b4c47c0599717544b6744a0403c9578c9fa5d5b1e8f53565576834
-rw-r--r-- 1 ai ai     4270 июн 11 13:26 c1599db6ecf1c491613c4c25cc94a6effadd98d81dccae0a9b1c3117060660e6
-rw-r--r-- 1 ai ai 20697088 июн 11 13:26 d21c43a3466f67bc6e807f617aebd1d8be84e89c5eb7cc85fe93a3f53575ed3d
-rw-r--r-- 1 ai ai      859 янв  1  1970 d700b0943404f1c187f8133fbedcda51601eb79a365dc400c761a0ffa2ff81b3
-rw-r--r-- 1 ai ai     1695 июн 11 13:26 d8af71b4dccb4de7bc140edbf76866888eca3e2ceb2ea2f61867bc4987860908
-rw-r--r-- 1 ai ai      482 июн 11 13:26 fa0c98219c59f1492343f160182d116eb914377258ad9dd61145f4bc0f1e64c3
-rw-r--r-- 1 ai ai  8593920 июн 11 13:26 fd2758d7a50e2b78d275ee7d1c218489f2439084449d895fa17eede6c61ab2c4
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: ls -la blobs/sha256/6be188821a1e6d0af92854aa290cf75a053ad8525dfc35f3d7d256daeb20bc34
-rw-r--r-- 1 ai ai 93604352 июн 11 13:26 blobs/sha256/6be188821a1e6d0af92854aa290cf75a053ad8525dfc35f3d7d256daeb20bc34
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: cp 6be188821a1e6d0af92854aa290cf75a053ad8525dfc35f3d7d256daeb20bc34 ./layer.tar
cp: cannot stat '6be188821a1e6d0af92854aa290cf75a053ad8525dfc35f3d7d256daeb20bc34': No such file or directory
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: cp blobs/sha256/6be188821a1e6d0af92854aa290cf75a053ad8525dfc35f3d7d256daeb20bc34 ./layer.tar
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: mkdir -p terraform_layer
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: tar xf layer.tar -C terraform_layer
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted (master)$: cd terraform_layer/
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted/terraform_layer (master)$: sl -la

Command 'sl' not found, but can be installed with:

sudo apt install sl

ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted/terraform_layer (master)$: ls -la
total 12
drwxrwxr-x 3 ai ai 4096 июл 17 13:43 .
drwxrwxr-x 4 ai ai 4096 июл 17 13:43 ..
drwxr-xr-x 2 ai ai 4096 июн 11 13:26 bin
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted/terraform_layer (master)$: cd bin/
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted/terraform_layer/bin (master)$: ls -la
total 91420
drwxr-xr-x 2 ai ai     4096 июн 11 13:26 .
drwxrwxr-x 3 ai ai     4096 июл 17 13:43 ..
-rwxr-xr-x 1 ai ai 93601976 июн 11 13:22 terraform
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted/terraform_layer/bin (master)$: terraform --version
Terraform v1.8.4
on linux_amd64
ai@ai:/var/www/study/netology/devops/devops-netology/terraform_extracted/terraform_layer/bin (master)$: 
```
![](https://i.postimg.cc/LsPdTVW4/2025-07-17-13-44.png)
Предоставьте скриншоты  действий .

## Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты  действий .
![](https://i.postimg.cc/7L2wf4ML/2025-07-17-13-28.png)

