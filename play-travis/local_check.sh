#!/bin/bash
PACKER_VERSION=1.6.4
TERRAFORM_VERSION=0.12.29

set -e
curl -L -o packer.zip \"https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
unzip -d ~/bin packer.zip
packer version

curl -L -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip -d ~/bin terraform.zip
terraform --version

pip install --user ansible-lint
ansible-lint --version

curl https://raw.githubusercontent.com/wata727/tflint/master/install_linux.sh | bash
tflint --version

packer validate -var-file=packer/variables.json.example packer/db.json
packer validate -var-file=./packer/variables.json.example ./packer/app.json
cd terraform/prod
terraform get && terraform init -backend=false && terraform validate
cd ../../terraform/stage
terraform get && terraform init -backend=false && terraform validate
cd ../../

tflint terraform/prod
tflint terraform/stage
ansible-lint -v ansible/playbooks/*.yml
