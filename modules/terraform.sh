#!/usr/bin/env bash

mkdir -p $HOME/bin
cd $HOME/bin
curl -s -L -o $HOME/bin/terraform.zip https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_darwin_amd64.zip
unzip -o $HOME/bin/terraform.zip
rm -f $HOME/bin/terraform.zip