# Домашнее задание к занятию «Сетевое взаимодействие в Kubernetes»

### Примерное время выполнения задания

120 минут

### Цель задания

Научиться настраивать доступ к приложениям в Kubernetes:
- Внутри кластера через **Service** (ClusterIP, NodePort).
- Снаружи кластера через **Ingress**.

Это задание поможет вам освоить базовые принципы сетевого взаимодействия в Kubernetes — ключевого навыка для работы с кластерами.
На практике Service и Ingress используются для доступа к приложениям, балансировки нагрузки и маршрутизации трафика. Понимание этих механизмов поможет вам упростить управление сервисами в рабочих окружениях и снизит риски ошибок при развёртывании.

------

## **Задание 1: Настройка Service (ClusterIP и NodePort)**
### **Задача**
Развернуть приложение из двух контейнеров (`nginx` и `multitool`) и обеспечить доступ к ним:
- Внутри кластера через **ClusterIP**.
- Снаружи через **NodePort**.

### **Шаги выполнения**
1. **Создать Deployment** с двумя контейнерами:
   - `nginx` (порт `80`).
   - `multitool` (порт `8080`).
   - Количество реплик: `3`.

[deployment-nginx-multitool.yaml](./deployment-multi-container.yaml)
![deployment-nginx-multitool](https://i.yapx.ru/dj2rQ.png)

2. **Создать Service типа ClusterIP**, который:
   - Открывает `nginx` на порту `9001`.
   - Открывает `multitool` на порту `9002`.

[svc-nginx-multitool.yaml](./service-clusterip.yaml)
![svc-nginx-multitool](https://i.yapx.ru/dj2wn.png)

3. **Проверить доступность** изнутри кластера:
```bash
 kubectl run test-pod --image=wbitt/network-multitool --rm -it -- sh
 curl <service-name>:9001 # Проверить nginx
 curl <service-name>:9002 # Проверить multitool
```
![test-pod](https://i.yapx.ru/dj2yn.png)

4. **Создать Service типа NodePort** для доступа к `nginx` снаружи.

[service-nodeport.yaml](./service-nodeport.yaml)
![service-nodeport](https://i.yapx.ru/dj23E.png)

5. **Проверить доступ** с локального компьютера:
```bash
 curl <node-ip>:<node-port>
```
 или через браузер.
![curl-nodeport](https://i.yapx.ru/dj24a.png)

### **Что сдать на проверку**
- Манифесты:
  - `deployment-multi-container.yaml`
  - `service-clusterip.yaml`
  - `service-nodeport.yaml`
- Скриншоты проверки доступа (`curl` или браузер).

---
## **Задание 2: Настройка Ingress**
### **Задача**
Развернуть два приложения (`frontend` и `backend`) и обеспечить доступ к ним через **Ingress** по разным путям.

### **Шаги выполнения**
1. **Развернуть два Deployment**:
   - `frontend` (образ `nginx`).

    [deployment-frontend.yaml](./deployment-frontend.yaml)
   - `backend` (образ `wbitt/network-multitool`).

    [deployment-backend.yaml](./deployment-backend.yaml)
    ![frontend and backend deployments](https://i.yapx.ru/dj3Oc.png)

2. **Создать Service** для каждого приложения. 

    [service-frontend.yaml](./service-frontend.yaml) 

    [service-backend.yaml](./service-backend.yaml)
    ![frontend and backend services](https://i.yapx.ru/dj3PY.png)

3. **Включить Ingress-контроллер**:
```bash
 microk8s enable ingress
   ```
![ingress-controller](https://i.yapx.ru/dj3AO.png)
```
kubectl get svc -n ingress-nginx ingress-nginx-controller
NAME                       TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller   NodePort   10.97.100.43   <none>        80:32150/TCP,443:32103/TCP   103m
```

4. **Создать Ingress**, который:
   - Открывает `frontend` по пути `/`.
   - Открывает `backend` по пути `/api`.

    [ingress.yaml](./ingress.yaml)
    ![ingress](https://i.yapx.ru/dj3US.png)

2. **Проверить доступность**:
```bash
 curl <host>/
 curl <host>/api
   ```
 или через браузер.

```
 Порт 80 на сервере занят хостовым nginx, поэтому используем порт 32150, назначенный сервису при установке ingress-контроллера.
```
 ![curl tests](https://i.yapx.ru/dj3VB.png)

### **Что сдать на проверку**
- Манифесты:
  - `deployment-frontend.yaml`
  - `deployment-backend.yaml`
  - `service-frontend.yaml`
  - `service-backend.yaml`
  - `ingress.yaml`
- Скриншоты проверки доступа (`curl` или браузер).