#!/bin/bash
set -e

PACKER_VERSION=1.6.4
TERRAFORM_VERSION=0.12.29
ANSIBLE_LINT_VERSION=4.3.5
TFLINT_VERSION=0.20.3

curl -L -o packer.zip "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
unzip -d ~/bin packer.zip
packer version

curl -L -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip -d ~/bin terraform.zip
terraform --version

#TF_LINK=$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")
curl -L "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" -o tflint.zip
unzip -d ~/bin tflint.zip
tflint --version

pip3 install ansible-lint==${ANSIBLE_LINT_VERSION}
ansible-lint --version
