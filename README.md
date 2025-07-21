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

Разворачивание приложений (тест-задания, компонент мониторинга и пр.) будет происходить отсюда.

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
, а также сгенерировать ключ для работы с репозиторием gitlab:
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
Запоминаем токен, заходим через ssh на jumphost и в директорию /opt/gitlab-runners/inventory:
```
ssh jumphost.tvm2360.ru
/opt/gitlab-runners/inventory
```
Там находятся подготовленные файлы с конфигурациями ansible для разворачивания gitlab-runner. Количество фалов соответствует количеству инстансов в группе ig-gitlab-runners. Находим нужную конфигурацию по IP в ansible_host, если runner'ов используется несколько, и в поле gitlab_registration_token вставляем токен.
Как только все токены внесены, возвращаемся на каталог выше и запускаем ansible-playbook:
```
cd ..
./start_reg_runners.sh
exit
```
Ждем окончания процесса...

![Ansible-Gitlab-Runners](./pictures/Ansible-Gitlab-Runners.png)

Возвращаемся в gitlab View Runners - runner подключен и ожидает заданий

![Runners](./pictures/Runners.png)

Теперь приступаем к настройке переменных окружения. Заходим в Admin Area -> Settings -> CI/CD -> Variables и добавляем (не забывая проверять установленный признак Protect variable):

+ key:CI_REGISTRY type:VARIABLE value:cr.yandex
+ key:CI_REGISTRY_USER type:VARIABLE value:json_key
+ key:CI_REPOSITORY type:VARIABLE value:<вставляем ID реестра devops-diplom-registry>

Для установки значения следующей переменной необходимо сгенерировать ключ сервисного аккаунта sa-devops-diplom-registry-pusher. Для этого:
```
yc iam key create --service-account-name sa-devops-diplom-registry-pusher -o sa-devops-diplom-registry-pusher-key.json
cat sa-devops-diplom-registry-pusher-key.json | base64     -----> вывод копируем в буфер обмена
rm sa-devops-diplom-registry-pusher-key.json
```
+ key:CI_SA_PUSHER_KEY_BASE64 type:FILE value:<вставляем из буфера обмена>

Для установки значения следующей переменной необходимо зайти через ssh на jumphost:
```
ssh jumphost.tvm2360.ru
cat /home/ubuntu/.kube/config | base64      -----> вывод копируем в буфер обмена
```
+ key:CI_KUBE_CONFIG_BASE64 type:FILE value:<вставляем из буфера обмена>







