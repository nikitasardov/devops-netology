
# Домашнее задание к занятию 4 «Оркестрация группой Docker контейнеров на примере Docker Compose»

## Задача 1

Ответ: https://hub.docker.com/r/nikitasardov/custom-nginx (вход в аккаунт не требуется)
или https://hub.docker.com/repository/docker/nikitasardov/custom-nginx/general (требуется вход в аккаунт)

Сценарий выполнения задачи:
- Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.
  
  Установил на ВМ:
```
test@compute-vm-2-2-30-hdd-1749390515746:~$ docker-compose --version
docker-compose version 1.29.2, build unknown
test@compute-vm-2-2-30-hdd-1749390515746:~$ docker --version
Docker version 27.5.1, build 27.5.1-0ubuntu3~22.04.2
```
- Если dockerhub недоступен создайте файл /etc/docker/daemon.json с содержимым: ```{"registry-mirrors": ["https://mirror.gcr.io", "https://daocloud.io", "https://c.163.com/", "https://registry.docker-cn.com"]}```
- Зарегистрируйтесь и создайте публичный репозиторий  с именем "custom-nginx" на https://hub.docker.com (ТОЛЬКО ЕСЛИ У ВАС ЕСТЬ ДОСТУП);
- скачайте образ nginx:1.21.1;
- Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```
- Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 (ТОЛЬКО ЕСЛИ ЕСТЬ ДОСТУП). 
- Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general .

## Задача 2
1. Запустите ваш образ custom-nginx:1.0.0 командой docker run в соответвии с требованиями:
- имя контейнера "ФИО-custom-nginx-t2"
- контейнер работает в фоне
- контейнер опубликован на порту хост системы 127.0.0.1:8080
```
test@compute-vm-2-2-30-hdd-1749390515746:~$ sudo docker run -p 8080:80 --name nsardov-custom-nginx-t2 -d nikitasardov/custom-nginx:1.0.0
5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83
test@compute-vm-2-2-30-hdd-1749390515746:~$ sudo docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED         STATUS         PORTS                                     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   7 seconds ago   Up 6 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   nsardov-custom-nginx-t2
```
1. Не удаляя, переименуйте контейнер в "custom-nginx-t2"
```
test@compute-vm-2-2-30-hdd-1749390515746:~$ sudo docker rename 5904448b565c custom-nginx-t2
test@compute-vm-2-2-30-hdd-1749390515746:~$ sudo docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED         STATUS         PORTS                                     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   2 minutes ago   Up 2 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   custom-nginx-t2
test@compute-vm-2-2-30-hdd-1749390515746:~$
```
2. Выполните команду ```date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8080  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html```
```
test@compute-vm-2-2-30-hdd-1749390515746:~/custom-nginx$ sudo su
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8080  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html
14-06-2025 16:27:27.767133320 MSK
CONTAINER ID   IMAGE                             COMMAND                  CREATED         STATUS         PORTS                                     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   4 minutes ago   Up 4 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   custom-nginx-t2
2025/06/14 13:23:22 [error] 6#6: *1 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 95.24.29.10, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "89.169.139.7:8080", referrer: "http://89.169.139.7:8080/"
PGh0bWw+CjxoZWFkPgpIZXksIE5ldG9sb2d5CjwvaGVhZD4KPGJvZHk+CjxoMT5JIHdpbGwgYmUg
RGV2T3BzIEVuZ2luZWVyITwvaDE+CjwvYm9keT4KPC9odG1sPgo=
```
3. Убедитесь с помощью curl или веб браузера, что индекс-страница доступна.
```
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# curl 89.169.139.7:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# 
```



## Задача 3
1. Воспользуйтесь docker help или google, чтобы узнать как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".
```
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker attach custom-nginx-t2

95.24.29.10 - - [14/Jun/2025:13:30:52 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36" "-"
95.24.29.10 - - [14/Jun/2025:13:30:56 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36" "-"
95.24.29.10 - - [14/Jun/2025:13:31:04 +0000] "GET /?test HTTP/1.1" 200 95 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36" "-"
```
2. Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.
```
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker attach custom-nginx-t2

95.24.29.10 - - [14/Jun/2025:13:30:52 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36" "-"
95.24.29.10 - - [14/Jun/2025:13:30:56 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36" "-"
95.24.29.10 - - [14/Jun/2025:13:31:04 +0000] "GET /?test HTTP/1.1" 200 95 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36" "-"
^C2025/06/14 13:31:56 [notice] 1#1: signal 2 (SIGINT) received, exiting
2025/06/14 13:31:56 [notice] 7#7: exiting
2025/06/14 13:31:56 [notice] 7#7: exit
2025/06/14 13:31:56 [notice] 6#6: exiting
2025/06/14 13:31:56 [notice] 6#6: exit
2025/06/14 13:31:56 [notice] 1#1: signal 17 (SIGCHLD) received from 6
2025/06/14 13:31:56 [notice] 1#1: worker process 6 exited with code 0
2025/06/14 13:31:56 [notice] 1#1: signal 29 (SIGIO) received
2025/06/14 13:31:56 [notice] 1#1: signal 17 (SIGCHLD) received from 7
2025/06/14 13:31:56 [notice] 1#1: worker process 7 exited with code 0
2025/06/14 13:31:56 [notice] 1#1: exit
```
3. Выполните ```docker ps -a``` и объясните своими словами почему контейнер остановился.
Ctrl-C отправляет команду завершить процесс
```
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   12 minutes ago   Exited (0) 3 minutes ago              custom-nginx-t2
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   19 minutes ago   Exited (0) 18 minutes ago             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx#
```
4. Перезапустите контейнер
```
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   12 minutes ago   Exited (0) 3 minutes ago              custom-nginx-t2
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   19 minutes ago   Exited (0) 18 minutes ago             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker ps^C
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# 
exit
test@compute-vm-2-2-30-hdd-1749390515746:~/custom-nginx$ sudo su
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker start 5904448b565c
5904448b565c
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS                                     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   13 minutes ago   Up 2 seconds                0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   custom-nginx-t2
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   20 minutes ago   Exited (0) 19 minutes ago                                             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# 
```
5. Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
```
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker exec -ti 5904448b565c bash
```
6. Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
```
root@5904448b565c:/# apt update
...
root@5904448b565c:/# apt install vim
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  libgpm2 vim-common vim-runtime xxd
Suggested packages:
  gpm ctags vim-doc vim-scripts
The following NEW packages will be installed:
  libgpm2 vim vim-common vim-runtime xxd
0 upgraded, 5 newly installed, 0 to remove and 56 not upgraded.
Need to get 7432 kB of archives.
After this operation, 33.8 MB of additional disk space will be used.
Do you want to continue? [Y/n] y

```
7. Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".
```
root@5904448b565c:/# cat /etc/nginx/conf.d/default.conf
server {
    listen       81;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```
8. Запомните(!) и выполните команду ```nginx -s reload```, а затем внутри контейнера ```curl http://127.0.0.1:80 ; curl http://127.0.0.1:81```.
```
root@5904448b565c:/# curl http://127.0.0.1:80 ; curl http://127.0.0.1:81
curl: (7) Failed to connect to 127.0.0.1 port 80: Connection refused
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
root@5904448b565c:/#
```
9.  Выйдите из контейнера, набрав в консоли  ```exit``` или Ctrl-D.
10. Проверьте вывод команд: ```ss -tlpn | grep 127.0.0.1:8080``` , ```docker port custom-nginx-t2```, ```curl http://127.0.0.1:8080```. Кратко объясните суть возникшей проблемы.
```
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# ss -tlpn | grep 127.0.0.1:8080
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS         PORTS                                     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   19 minutes ago   Up 6 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   custom-nginx-t2
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker port custom-nginx-t2
80/tcp -> 0.0.0.0:8080
80/tcp -> [::]:8080
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# curl http://127.0.0.1:8080
curl: (56) Recv failure: Connection reset by peer
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# 
```
```
nginx теперь слушает порт 81, а не 80
docker ps показывает порт 80, т.к. Docker не обновляет информацию о проброске портов после запуска. nginx работает внутри контейнера, но на другом порту
```
11.  * Это дополнительное, необязательное задание. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. [пример источника](https://www.baeldung.com/linux/assign-port-docker-container)
```
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker port custom-nginx-t2
80/tcp -> 0.0.0.0:8080
80/tcp -> [::]:8080
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker pы
docker: 'pы' is not a docker command.
See 'docker --help'
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS          PORTS                                     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   38 minutes ago   Up 25 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   custom-nginx-t2
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker stop custom-nginx-t2
custom-nginx-t2
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# docker inspect custom-nginx-t2 | grep -i '"id"'
        "Id": "5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83",
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# systemctl stop docker
Warning: Stopping docker.service, but it can still be activated by:
  docker.socket
root@compute-vm-2-2-30-hdd-1749390515746:/home/test/custom-nginx# cd /var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# ls -la
total 52
drwx--x--- 4 root root 4096 Jun 14 17:01 .
drwx--x--- 4 root root 4096 Jun 14 16:23 ..
-rw-r----- 1 root root 9383 Jun 14 17:01 5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83-json.log
drwx------ 2 root root 4096 Jun 14 16:23 checkpoints
-rw------- 1 root root 2693 Jun 14 17:01 config.v2.json
-rw------- 1 root root 1503 Jun 14 17:01 hostconfig.json
-rw-r--r-- 1 root root   13 Jun 14 16:36 hostname
-rw-r--r-- 1 root root  150 Jun 14 17:01 hosts
drwx--x--- 2 root root 4096 Jun 14 16:23 mounts
-rw-r--r-- 1 root root  278 Jun 14 16:36 resolv.conf
-rw-r--r-- 1 root root   71 Jun 14 16:36 resolv.conf.hash
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# vi hostconfig.json 
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# vi config.v2.json
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# systemctl start docker
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# docker ps
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   42 minutes ago   Exited (0) 3 minutes ago              custom-nginx-t2
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   49 minutes ago   Exited (0) 48 minutes ago             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# docker start 5904448b565c
5904448b565c
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS                                     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   42 minutes ago   Up 2 seconds                0.0.0.0:8080->81/tcp, [::]:8080->81/tcp   custom-nginx-t2
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   50 minutes ago   Exited (0) 49 minutes ago                                             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b7root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b7root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b7root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# cost:8080
url http://localhost:808^C
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83# curl http://localhost:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
root@compute-vm-2-2-30-hdd-1749390515746:/var/lib/docker/containers/5904448b565c4765918bb9fdaadb511319e8e651824e4fa4b749a551ff800e83#
```
12.  Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)
```
root@compute-vm-2-2-30-hdd-1749390515746:~# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS                                     NAMES
5904448b565c   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   45 minutes ago   Up 2 minutes                0.0.0.0:8080->81/tcp, [::]:8080->81/tcp   custom-nginx-t2
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   52 minutes ago   Exited (0) 51 minutes ago                                             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:~# docker rm -f 5904448b565c
5904448b565c
root@compute-vm-2-2-30-hdd-1749390515746:~# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS     NAMES
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   52 minutes ago   Exited (0) 51 minutes ago             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:~# 
```

## Задача 4


- Запустите первый контейнер из образа ***centos*** c любым тегом в фоновом режиме, подключив папку  текущий рабочий каталог ```$(pwd)``` на хостовой машине в ```/data``` контейнера, используя ключ -v.
```
root@compute-vm-2-2-30-hdd-1749390515746:~# docker run -d -v $(pwd):/data centos:centos7.9.2009
Unable to find image 'centos:centos7.9.2009' locally
centos7.9.2009: Pulling from library/centos
2d473b07cdd5: Pull complete 
Digest: sha256:be65f488b7764ad3638f236b7b515b3678369a5124c47b8d32916d6487418ea4
Status: Downloaded newer image for centos:centos7.9.2009
2502d83cc0baf0cef870d97ab83ee597dafd2dfe8cb068c0bf74a6548ea127ba
root@compute-vm-2-2-30-hdd-1749390515746:~# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
root@compute-vm-2-2-30-hdd-1749390515746:~# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS     NAMES
2502d83cc0ba   centos:centos7.9.2009             "/bin/bash"              20 seconds ago   Exited (0) 11 seconds ago             peaceful_joliot
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   58 minutes ago   Exited (0) 58 minutes ago             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:~# docker run -it -v $(pwd):/data centos:centos7.9.2009 bash
[root@74152da765b4 /]# 
```
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив текущий рабочий каталог ```$(pwd)``` в ```/data``` контейнера. 
```
root@compute-vm-2-2-30-hdd-1749390515746:~# docker run -it -v $(pwd):/data debian:unstable-slim bash
Unable to find image 'debian:unstable-slim' locally
unstable-slim: Pulling from library/debian
fb1886765faf: Pull complete 
Digest: sha256:5a1fa4e7ca7e4a8ea0449d0e5e6ac6593b4aebac12f658e69af354c0b3cb073a
Status: Downloaded newer image for debian:unstable-slim
root@801f467a23d7:/#
```
```
root@compute-vm-2-2-30-hdd-1749390515746:~# docker run -d -v $(pwd):/data centos:centos7.9.2009 tail -f /dev/null
caa8ebe0afb903e6276ee578e5623158aa4677e337712104b96cf92eba4a3c0b
root@compute-vm-2-2-30-hdd-1749390515746:~# docker run -d -v $(pwd):/data debian:unstable-slim tail -f /dev/null
44dbe70a264fdf845f7c466ba197c20d4962d1811bd81d190c0b1fe48b53e3a4
root@compute-vm-2-2-30-hdd-1749390515746:~# docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED             STATUS                         PORTS     NAMES
44dbe70a264f   debian:unstable-slim              "tail -f /dev/null"      4 seconds ago       Up 2 seconds                             priceless_tu
caa8ebe0afb9   centos:centos7.9.2009             "tail -f /dev/null"      18 seconds ago      Up 16 seconds                            happy_merkle
092036b64174   centos:centos7.9.2009             "bash"                   2 minutes ago       Exited (0) 33 seconds ago                friendly_wozniak
dc1b2de50dd2   nikitasardov/custom-nginx:1.0.0   "nginx -g 'daemon of…"   About an hour ago   Exited (0) About an hour ago             quizzical_rhodes
root@compute-vm-2-2-30-hdd-1749390515746:~#
```
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```.
```
root@compute-vm-2-2-30-hdd-1749390515746:~# docker exec -ti caa8ebe0afb9 bash
[root@caa8ebe0afb9 /]# echo 'test' > /data/test.txt

```
- Добавьте ещё один файл в текущий каталог ```$(pwd)``` на хостовой машине.
```
root@compute-vm-2-2-30-hdd-1749390515746:~# echo 'test2' > test2.txt
```
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.
```
root@compute-vm-2-2-30-hdd-1749390515746:~# docker exec -ti 44dbe70a264f bash
root@44dbe70a264f:/# ls -la /data
total 60
drwx------ 9 root root 4096 Jun 14 14:26 .
drwxr-xr-x 1 root root 4096 Jun 14 14:22 ..
-rw------- 1 root root  301 Jun 14 13:35 .bash_history
-rw-r--r-- 1 root root 3383 Jun 11  2023 .bashrc
drwx------ 2 root root 4096 Dec 12  2022 .cache
drwx------ 4 root root 4096 Jun 11  2023 .config
drwx------ 2 root root 4096 Jun 14 13:14 .docker
-rw-r--r-- 1 root root  161 Jul  9  2019 .profile
drwx------ 2 root root 4096 Jun 11  2023 .pulumi
drwx------ 2 root root 4096 Jun  8 13:55 .ssh
drwxr-xr-x 2 root root 4096 Jun 11  2023 .terraform.d
-rw------- 1 root root 2349 Jun 14 14:04 .viminfo
drwx------ 3 root root 4096 Dec 12  2022 snap
-rw-r--r-- 1 root root    5 Jun 14 14:26 test.txt
-rw-r--r-- 1 root root    6 Jun 14 14:26 test2.txt
root@44dbe70a264f:/# 
```

## Задача 5

1. Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него.
"compose.yaml" с содержимым:
```
version: "3"
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
"docker-compose.yaml" с содержимым:
```
version: "3"
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"
```

И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-application-model/#the-compose-file )
```
запущен сервис registry, потому что дефолтное название конфига docker-compose - docker-compose.yml (или yaml)
```
2. Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)
```
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# cat compose.yaml
x-include:
  - ./docker-compose.yaml
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

root@compute-vm-2-2-30-hdd-1749390515746:~/task5# docker-compose -f compose.yaml up -d
WARNING: Found orphan containers (task5_registry_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
Pulling portainer (portainer/portainer-ce:latest)...
latest: Pulling from portainer/portainer-ce
c02951246260: Pull complete
b7c5ecc05946: Pull complete
04de093ad5ed: Pull complete
a9ff7abff372: Pull complete
e09df2601140: Pull complete
54675ba571ac: Pull complete
886c883b7538: Pull complete
93b4ed907f92: Pull complete
f126cb2940fd: Pull complete
4f4fb700ef54: Pull complete
Digest: sha256:ebead33595e425f88b1d02a74e4cc65a6d295e96c3643bb176dca7cb64bc36b0
Status: Downloaded newer image for portainer/portainer-ce:latest
Creating task5_portainer_1 ... done

```

3. Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/
4. Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)
5. Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local  окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:

```
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```
```
Stacks

Name Filter Type Control Created Updated Ownership

custom-nginx-stack	Compose	Total	2025-06-15 09:08:05 by admin	-	
administrators task5	Compose	Limited 2025-06-15 08:53:31	-	administrators
```
6. Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".
```
{
AppArmorProfile:"docker-default",
Args:[
"-g",
"daemon off;"
],
Config:{
AttachStderr:true,
AttachStdin:false,
AttachStdout:true,
Cmd:[
"-g",
"daemon off;"
],
Domainname:"",
Entrypoint:[
"nginx"
],
Env:[
"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
"NGINX_VERSION=1.21.1",
"NJS_VERSION=0.6.1",
"PKG_RELEASE=1~buster"
],
ExposedPorts:{
80/tcp:{
}
},
Hostname:"e522bb763d6f",
Image:"127.0.0.1:5000/custom-nginx",
Labels:{
com.docker.compose.config-hash:"8b9fe9ab3a7934244a4cb3d97ea83abe99d1849b88a7d7931370a021dd008c42",
com.docker.compose.container-number:"1",
com.docker.compose.depends_on:"",
com.docker.compose.image:"sha256:a3fc276aea1b446f1a6d5d62e7aecf83765d87f1de5c97c07f80a105610e7b20",
com.docker.compose.oneoff:"False",
com.docker.compose.project:"custom-nginx-stack",
com.docker.compose.project.config_files:"",
com.docker.compose.project.working_dir:"/data/compose/1",
com.docker.compose.service:"nginx",
com.docker.compose.version:"",
maintainer:"NGINX Docker Maintainers <docker-maint@nginx.com>"
},
OnBuild:null,
OpenStdin:false,
StdinOnce:false,
StopSignal:"SIGQUIT",
Tty:false,
User:"",
Volumes:null,
WorkingDir:"/"
},
Created:"2025-06-15T06:08:05.88415183Z",
Driver:"overlay2",
...
```

7. Удалите любой из манифестов компоуза(например compose.yaml).  Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите compose-проект ОДНОЙ(обязательно!!) командой.
```
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# ls -la
total 16
drwxr-xr-x  2 root root 4096 Jun 14 17:37 .
drwx------ 10 root root 4096 Jun 14 17:37 ..
-rw-r--r--  1 root root  187 Jun 14 17:37 compose.yaml
-rw-r--r--  1 root root   87 Jun 14 17:30 docker-compose.yaml
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# rm compose.yaml ^C
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# mv compose.yaml ../
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# ls -la
total 12
drwxr-xr-x  2 root root 4096 Jun 15 09:55 .
drwx------ 10 root root 4096 Jun 15 09:55 ..
-rw-r--r--  1 root root   87 Jun 14 17:30 docker-compose.yaml
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# docker-compose up -d
WARNING: Found orphan containers (task5_portainer_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
task5_registry_1 is up-to-date
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# 
```
```
Docker обнаружил этот "орфанный" контейнер и выдал предупреждение, что запущенный контейнер не связан ни с каким из сервисов, описанных в конфигах
```
```
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# docker-compose up -d --remove-orphans
Removing orphan container "task5_portainer_1"
task5_registry_1 is up-to-date
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# 
```
```
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# docker-compose down
Stopping task5_registry_1 ... done
Removing task5_registry_1 ... done
Removing network task5_default
root@compute-vm-2-2-30-hdd-1749390515746:~/task5# 
```
![](https://i.postimg.cc/0j5ZLKr5/image.png)
![](https://i.postimg.cc/J4PS4MWd/image.png)


