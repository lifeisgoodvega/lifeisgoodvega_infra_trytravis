#!/bin/bash
set -e

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
