#!/bin/bash

echo "Настройка Docker окружения для Ansible..."

# Остановить и удалить существующие контейнеры (если есть)
docker stop centos8 ubuntu clickhouse-01 vector-01 2>/dev/null || true
docker rm centos8 ubuntu clickhouse-01 vector-01 2>/dev/null || true

# Запустить CentOS 8 контейнер
echo "Запуск CentOS 8 контейнера..."
docker run -d --name centos8 --hostname centos8 \
  -p 2222:22 \
  centos:8 /bin/bash -c "while true; do sleep 30; done"

# Запустить Ubuntu контейнер  
echo "Запуск Ubuntu контейнера..."
docker run -d --name ubuntu --hostname ubuntu \
  -p 2223:22 \
  ubuntu:20.04 /bin/bash -c "while true; do sleep 30; done"

# Запустить CentOS контейнер (clickhouse)
echo "Запуск CentOS контейнера (clickhouse)..."
docker run -d --name clickhouse-01 --hostname clickhouse-01 \
  -p 2224:22 \
  centos:8 /bin/bash -c "while true; do sleep 30; done"

# Запустить CentOS контейнер (vector)
echo "Запуск CentOS контейнера (vector)..."
docker run -d --name vector-01 --hostname vector-01 \
  -p 2225:22 \
  centos:8 /bin/bash -c "while true; do sleep 30; done"


# Установить SSH в контейнерах
echo "Настройка SSH в контейнерах..."

# CentOS 8
docker exec centos8 bash -c "
  yum update -y && 
  yum install -y openssh-server openssh-clients &&
  ssh-keygen -A &&
  echo 'root:password' | chpasswd &&
  sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config &&
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
  /usr/sbin/sshd
"

# Ubuntu
docker exec ubuntu bash -c "
  apt-get update && 
  apt-get install -y openssh-server &&
  ssh-keygen -A &&
  echo 'root:password' | chpasswd &&
  sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config &&
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
  service ssh start
"

# CentOS clickhouse-01
docker exec clickhouse-01 bash -c "
  yum update -y && 
  yum install -y openssh-server openssh-clients &&
  ssh-keygen -A &&
  echo 'root:password' | chpasswd &&
  sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config &&
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
  /usr/sbin/sshd
"

# CentOS vector-01
docker exec vector-01 bash -c "
  yum update -y && 
  yum install -y openssh-server openssh-clients &&
  ssh-keygen -A &&
  echo 'root:password' | chpasswd &&
  sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config &&
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config &&
  /usr/sbin/sshd
"

echo "Контейнеры запущены!"
echo "CentOS 8: localhost:2222"
echo "Ubuntu: localhost:2223"
echo "CentOS clickhouse-01: localhost:2224"
echo "CentOS vector-01: localhost:2225"
echo ""
echo "Для проверки подключения:"
echo "ssh -p 2222 root@localhost (пароль: password)"
echo "ssh -p 2223 root@localhost (пароль: password)"
echo "ssh -p 2224 root@localhost (пароль: password)"
echo "ssh -p 2225 root@localhost (пароль: password)"
