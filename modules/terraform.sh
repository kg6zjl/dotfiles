#!/usr/bin/env bash

VERSION="0.11.14"

cd $HOME/bin

if [[ "$OSTYPE" == *"darwin"* ]]; then
    curl -s -L -o $HOME/bin/terraform.zip https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_darwin_amd64.zip
else
    curl -s -L -o $HOME/bin/terraform.zip https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip
fi

unzip -o $HOME/bin/terraform.zip
rm -f $HOME/bin/terraform.zip
