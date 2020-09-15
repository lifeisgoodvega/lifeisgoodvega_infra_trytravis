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
