#!/usr/bin/env bash

mkdir $HOME/bin
curl -sL -o $HOME/bin/packer.zip https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_darwin_amd64.zip
unzip -o $HOME/bin/packer.zip -d $HOME/bin
rm -rf $HOME/bin/packer.zip
