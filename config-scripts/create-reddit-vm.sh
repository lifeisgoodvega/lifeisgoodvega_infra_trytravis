yc compute instance create \
  --name reddit-full-instance \
  --hostname reddit-full-instance \
  --memory=4 \
  --create-boot-disk image-family=reddit-full,size=10GB \
  --network-interface subnet-name=default-ru-central1-b,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/id_rsa.pub
