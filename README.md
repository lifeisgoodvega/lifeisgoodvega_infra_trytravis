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
