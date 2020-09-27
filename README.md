# lifeisgoodvega_infra
lifeisgoodvega Infra repository


# Домашнее задание 3
Подключение в одну команду
consul % ssh -J appuser@84.201.155.49 appuser@10.129.0.19

Для подключение через alias необходимо добавить в конфигурационный файл ssh
Host bastion
	User appuser
	Hostname 84.201.155.49

Host someinternalhost
	Hostname 10.129.0.19
	User appuser
	ProxyJump bastion

Примечание к домашнему заданию - пришлось установить iptables для запуска vpn сервера, без него pritunl
писал ошибки в лог, но UI делала вид, что всё нормально, хотя сервер не стартовал

Домен для входа без жалоб на сертификат: 84-201-155-49.sslip.io

bastion_IP = 84.201.155.49
someinternalhost_IP = 10.129.0.19

# Домашнее задание 4
testapp_IP = 84.201.142.132
testapp_port = 9292

Для использования метаданных cloud-config использовал следующую команду

yc compute instance create \
  --name reddit-app-2 \
  --hostname reddit-app-2 \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-b,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=./metadata.yaml

# Домашнее задание 5

Команда запуска для параметризованного шаблона packer:

packer build -var-file=variables.json ./ubuntu16.json

В variables.json.example выдуманные значения.
fake_key был создан, чтобы пройти Travis

Для запуска с "запечённым" reddit'ом

packer build -var-file=variables.json ./immutable.json

В files были вынесен скрипт для запуска reddit'а и файл сервиса для systemd unit

Скрипт для создания ВМ с использованием reddit-full family находится в config-scripts/create-reddit-vm.sh

# Домашнее задание 6

В конфигурации без count присутствует повтор кода и невозможность как-то нормально конфигурацию горизонтально масштабировать

В процессе выполнения был оформлен файл main в котором описан набор из N reddit-app интсансов. Все использованные входные переменные

описаны в variables.tf, а в terraform.tfvars.example пример их заполнения

В lb.tf разворачивается балансировщик и его целевая группа. Целевая группа заполняется информацией о запущенных ВМ, информация заполняется

посредством динамических блоков.

В output.tf описаны две выходные переменные. Одна с массивом IP-адресов серверов-приложений, другая с IP-адресом балансировщика.

# Домашнее задание 7

Изменения с yandex object state есть в папке prod

В процессе создания s3 bucket'а для terraform'а пришлось создать новый ключ для сервисного аккаунта, подходящего формата. Так же пришлось
явно указать в tf файле эти ключи, потому что переменные в данном разделе не поддерживались. Теперь state хранится не локально,
а в облаке. А при попытке создать одновременно две инфраструктуры, более поздний запуск падает с ошибкой, что инстансы уже созданы. Когда же state в облаек обновляется, terraform apply сообщает нам, что ничего делать не нужно.

Изменения с reddit-app есть в папке stage

1) В модуль db добавлен провизионер, который менят binding IP у mongodb и перезапускает сервис

2) В модуль db добвлена выходная переменная с внутренним IP-адресом

3) В модуле app добавлен входная переменна db_url, передача данные в переменную происходит через main.tf

4) puma.service заменён на puma.service.template

5) Перед установкой и запуском reddit.service в puma.service.template прокидывается DATABASE_URL

Файлы storage-bucket.tf и директория vpc созданы только для того, чтобы пройти travis
