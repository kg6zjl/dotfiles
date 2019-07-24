#!/usr/bin/env bash

RELEASE="1.0.0"

mkdir $HOME/bin
curl -sL -o $HOME/bin/packer.zip https://releases.hashicorp.com/packer/${RELEASE}/packer_${RELEASE}_darwin_amd64.zip
unzip -o $HOME/bin/packer.zip -d $HOME/bin
rm -rf $HOME/bin/packer.zip
