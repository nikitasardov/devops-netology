# Домашнее задание к занятию 6 «Создание собственных модулей»

## Подготовка к выполнению

1. Создайте пустой публичный репозиторий в своём любом проекте: `my_own_collection`.
2. Скачайте репозиторий Ansible: `git clone https://github.com/ansible/ansible.git` по любому, удобному вам пути.
3. Зайдите в директорию Ansible: `cd ansible`.
4. Создайте виртуальное окружение: `python3 -m venv venv`.
5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении.
![activate vetnv](https://i.postimg.cc/kgYQjgYH/2025-10-02-07-35.png)

6. Установите зависимости `pip install -r requirements.txt`.
![install requirements](https://i.postimg.cc/Z5QN8D0w/2025-10-02-07-37.png)

7. Запустите настройку окружения `. hacking/env-setup`.
8. Если все шаги прошли успешно — выйдите из виртуального окружения `deactivate`.
9.  Ваше окружение настроено. Чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`.
![env-setup](https://i.postimg.cc/yxfxVkZP/2025-10-02-07-39.png)

## Основная часть

Ваша цель — написать собственный module, который вы можете использовать в своей role через playbook. Всё это должно быть собрано в виде collection и отправлено в ваш репозиторий.

**Шаг 1.** В виртуальном окружении создайте новый `my_own_module.py` файл.

**Шаг 2.** Наполните его содержимым:

```python
# перенес код отсюда в файл
```
Или возьмите это наполнение [из статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

**Шаг 3.** Заполните файл в соответствии с требованиями Ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.

**Шаг 4.** Проверьте module на исполняемость локально.
![local](https://i.postimg.cc/4ypPqRHZ/2025-10-02-11-17.png)

**Шаг 5.** Напишите single task playbook и используйте module в нём.

**Шаг 6.** Проверьте через playbook на идемпотентность.
![ok](https://i.postimg.cc/NFsGPV43/2025-10-02-12-29.png)

**Шаг 7.** Выйдите из виртуального окружения.

**Шаг 8.** Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`.
Сделал `ansible-galaxy collection init ns.my_own_collection`

**Шаг 9.** В эту collection перенесите свой module в соответствующую директорию.

**Шаг 10.** Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module.

**Шаг 11.** Создайте playbook для использования этой role.

**Шаг 12.** Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.
1.0.0: https://github.com/nikitasardov/my_own_collection/commit/541e3b92aabb5252a35b93d03bef432d0a762475
1.0.1: https://github.com/nikitasardov/my_own_collection/commit/15e0bde449bd1b355fcf27910107f0c40cf85fef
1.0.2: https://github.com/nikitasardov/my_own_collection/commit/46f1fa09586db0c88eb0aebb2442e4d2019b975b

1.0.2 - финальный вариант. Были исправления в роли

**Шаг 13.** Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.
![collection build](https://i.postimg.cc/7hgjvYB6/2025-10-02-13-08.png)

**Шаг 14.** Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.

**Шаг 15.** Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`.
![collection installed](https://i.postimg.cc/0QZJVpvY/2025-10-02-13-11.png)

**Шаг 16.** Запустите playbook, убедитесь, что он работает.
Сначала не указал namespace, поэтому установленная коллекция не нашлась
![missing namespace](https://i.postimg.cc/jSQq6RtD/2025-10-02-13-13.png)
Убрал sudo для проверки на localhost и решил переопределить переменные.

Исправил определение переменных в роли, все успешно отработало
![success](https://i.postimg.cc/cLKSLYLL/2025-10-02-13-40.png)

Проверил идемпотентность
![success](https://i.postimg.cc/qM3wBvdk/2025-10-02-13-42.png)


**Шаг 17.** В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.


---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---