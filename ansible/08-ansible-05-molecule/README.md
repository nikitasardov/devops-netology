# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.
![molecule errors](https://i.postimg.cc/1XksBxXP/2025-09-29-10-05.png)

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
![init scenario](https://i.postimg.cc/wTz61pCx/2025-09-29-10-11.png)

3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
![add distr](https://i.postimg.cc/8C2TSJMR/2025-09-29-10-50.png)

Ошибка при запуске тестирования
![error](https://i.postimg.cc/LsCNYLNx/2025-09-29-10-54.png)

Добавил role_name и namespace
![error](https://i.postimg.cc/LsCNYLNx/2025-09-29-10-54.png)

![test sequence](https://i.postimg.cc/kGR2F6Kw/2025-09-29-11-24.png)

```
$ molecule test
INFO     default scenario test matrix: create, converge, verify, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/ai/.cache/ansible-compat/f5bcd7/modules:/home/ai/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/ai/.cache/ansible-compat/f5bcd7/collections:/home/ai/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/ai/.cache/ansible-compat/f5bcd7/roles:/home/ai/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/ai/.cache/ansible-compat/f5bcd7/roles/ns.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > create
INFO     Sanity checks: 'docker'

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'defaultCentOS', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'defaultCentOS', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}) 

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'defaultCentOS', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}) 
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'defaultCentOS', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/quay.io/centos/centos:stream8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'defaultCentOS', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=defaultCentOS)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '143258502933.2290303', 'results_file': '/home/ai/.ansible_async/143258502933.2290303', 'changed': True, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'defaultCentOS', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '614578379736.2290331', 'results_file': '/home/ai/.ansible_async/614578379736.2290331', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '300210271621.2290396', 'results_file': '/home/ai/.ansible_async/300210271621.2290396', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [defaultCentOS]
ok: [centos8]
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [ns.vector : Download Vector] *********************************************
changed: [defaultCentOS]
changed: [centos7]
changed: [centos8]

TASK [ns.vector : Extract Vector] **********************************************
changed: [defaultCentOS]
changed: [centos8]
changed: [centos7]

TASK [ns.vector : Create vector binary symlink] ********************************
changed: [centos7]
changed: [defaultCentOS]
changed: [centos8]

TASK [ns.vector : Deploy vector config] ****************************************
changed: [centos7]
changed: [defaultCentOS]
changed: [centos8]

RUNNING HANDLER [ns.vector : Restart vector service] ***************************
changed: [centos7]
changed: [defaultCentOS]
changed: [centos8]

PLAY RECAP *********************************************************************
centos7                    : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
defaultCentOS              : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [defaultCentOS] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
defaultCentOS              : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=defaultCentOS)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=defaultCentOS)
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```
4. Добавьте несколько assert в verify.yml-файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
![verification passed](https://i.postimg.cc/zBvcX8Y7/2025-09-29-11-50.png)

6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
![tag](https://i.postimg.cc/wjdxtbvd/2025-09-29-11-55.png)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
![tox configs](https://i.postimg.cc/qMKyVYSq/2025-09-29-11-59.png)

3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

4. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
5. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
Запуск пового тестового сенария происходит успешно. Выявлена проблема совместимости ansible-galaxy с python 3.9
![success](https://images2.imgbox.com/72/0a/XY9FchzL_o.png)

7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

## Решение
Тег решения части про Molecule 1.1.0 https://github.com/nikitasardov/vector-role/commit/615b6ad245bfbf68f91473e1b6cac600dad19914

Тег решения части про Tox 1.2.0 https://github.com/nikitasardov/vector-role/commit/0b5624b1aa9e9121b2bea57137ac3ea9297a7437

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.