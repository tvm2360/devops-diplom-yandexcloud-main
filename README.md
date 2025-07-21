## Дипломный практикум в Yandex.Cloud (devops-diplom-yandexcloud)
---
  * [Описание](#Описание)
  * [Подготовка](#Подготовка)
  * [Разворачивание](#Разворачивание)

---
### Описание
---
В процессе прохождения дипломного практикума в Yandex.Cloud будет развернута инфраструктура, состоящая из:
+ сеть и 4 подсети (3 - приватных в 3 зонах доступности, 1 - публичная)
+ инстанс для разворачивания Gitlab
+ инстанс для разворачивания Jumphost и NAT
+ группы инстансов masters и workers для разворачивания Kubernetes
+ группа инстансов для разворачивания gitlab worker'ов
+ application балансировщик с бакендом в виде целевых групп, состоящих  из worker нод kubernetes
+ группы безопасности и прочие компоненты

Разворачивание инфраструктуры происходит c использованием terraform из соответствующих репозиториев Github с использование рабочих процессов: проверки синтаксиса, плана развертывания, а также его применения на инфраструктуре YC.
После разворачивания инфраструктуры, при помощи kubespray будет создан кластер Kubernetes, развернута CI/CD на базе Gitlab.
В Gitlab будут созданы 3 группы репозиториев:
+ docker - группа, содержащая репозитории, предназначенные для создания различныя образов контейнеров docker и их размещения в registry
+ helm - группа, содержащая репозитории с различными версиями чартов helm, для их размещения в registry и дальнейшего развертывания в k8s, а также репозитории helm values
+ kubernetes - группа, содержащая различные функциональные сущности

Схема стенда показана на рисунке:

![Stand](./pictures/Stand.png)

---
### Подготовка
---
Процесс подготовки перед разворачиванием основной инфраструктуры описана в [devops-diplom-yandexcloud-prepare](https://github.com/tvm2360/devops-diplom-yandexcloud-prepare)

---
### Разворачивание
---
Процесс разворачивания основной инфраструктуры описана в [devops-diplom-yandexcloud-infrastructure](https://github.com/tvm2360/devops-diplom-yandexcloud-infrastructure)

---
### Gitlab
---
Приступаем к настройке Gitlab. Перед первым входом нужно узнать сгенерированный пароль root:
```
ssh -t -i ~/.ssh/id_yc_ed25519 ubuntu@jumphost.tvm2360.ru ssh -i ~/.ssh/id_yc_ed25519_1 ubuntu@<Внутренний IP Gitlab> sudo cat /etc/gitlab/initial_root_password
```
, а также ключ для работы с репозиторием gitlab:
```
ssh-keygen -t ed25519 -C "tvm2360@gitlab.tvm2360.ru" -f ~/.ssh/id_ed25519_gitlab
```
и сразу добавим привязку ключа к хосту в ~/.ssh/config:
```
Host gitlab.tvm2360.ru
   User ubuntu
   IdentityFile ~/.ssh/id_ed25519_gitlab
```
+ ссылки на ключи вставляем свои из [devops-diplom-yandexcloud-infrastructure](https://github.com/tvm2360/devops-diplom-yandexcloud-infrastructure)

Далее входим http://gitlab.tvm2360.ru пользователем root с сгенерированным паролем, который потом можно поменять. Создаем учетную запись с правами админа, устанавиваем ему пароль. Заходим новой УЗ.

Теперь затянем ключ для работы с репозиторием. Заходим Edit Profile -> SSH Keys -> Add new key и в Key вставляем содержимое ```cat ~/.ssh/id_ed25519_gitlab.pub``` без tvm2360@gitlab.tvm2360.ru, в Title tvm2360@gitlab.tvm2360.ru

Далее активируем runner's. Заходим в Admin Area -> CI/CD -> Runners -> New instance runner, платформу выбираем Linux, отмечаем Run untagged jobs, в Runner description вставляем имя раннера, можно имя инстанса (gitlab-runner1) -> Create runner.

Запоминаем токен, заходим через на jumphost