# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
[deployment-nginx-multitool.yaml](./deployment-nginx-multitool.yaml)
![deployment-nginx-multitool](https://i.yapx.ru/djaiO.png)
Контейнеры в поде пытаются занять один и тот же порт 80.
У мультитула тоже есть nginx, который хочет слушать дефолтный порт 80.
Нужно переопределить порт в одном из контейнеров. Используем переменную окружения HTTP_PORT для контейнера с мультитулом.
![successfully deployed](https://i.yapx.ru/dja0v.png)
2. После запуска увеличить количество реплик работающего приложения до 2.
Увеличиваем в манифесте replicas до 2. И снова применяем манифест.
3. Продемонстрировать количество подов до и после масштабирования.
![before scaling](https://i.yapx.ru/dja1u.png)
![scaling in progress](https://i.yapx.ru/dja3Q.png)
Второй под поднимается.
![after scaling](https://i.yapx.ru/dja4I.png)
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
[svc-nginx-multitool.yaml](./svc-nginx-multitool.yaml)
![service created](https://i.yapx.ru/djcDL.png)
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.
[pod-multitool.yaml](./pod-multitool.yaml)
![pod created](https://i.yapx.ru/djkGD.png)
Внутри пода запускаем `curl http://localhost:8083` и `curl http://localhost:8084` и видим, что доступ есть к обоим приложениям из деплоймента nginx-multitool-deployment, отвечающих черех сервис nginx-multitool-svc.

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
[deployment-nginx.yaml](./deployment-nginx.yaml)
В деплойменте добавляем init-контейнер, который будет ждать, пока сервис nginx-svc будет запущен.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
![deployment created](https://i.yapx.ru/djnPU.png)
3. Создать и запустить Service. Убедиться, что Init запустился.
[svc-nginx.yaml](./svc-nginx.yaml)
4. Продемонстрировать состояние пода до и после запуска сервиса.
![waiting for dns](https://i.yapx.ru/djoQA.png)

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------