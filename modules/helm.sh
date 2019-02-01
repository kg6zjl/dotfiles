#!/usr/bin/env bash

export RELEASE=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4)

#to override version:
#RELEASE="helm-v2.10.0"

curl -s https://api.github.com/repos/helm/helm/releases/latest

mkdir -p $HOME/bin/
if [[ "$OSTYPE" == "darwin"* ]]; then
    curl -s -L -o $HOME/bin/helm.tar.gz https://storage.googleapis.com/kubernetes-helm/$RELEASE-darwin-amd64.tar.gz
    DIR="darwin-amd64"
else
    curl -s -L -o $HOME/bin/helm.tar.gz https://storage.googleapis.com/kubernetes-helm/$RELEASE-linux-amd64.tar.gz
    DIR="linux-amd64"
fi

mkdir -p $HOME/bin && cd $HOME/bin
tar -zxvf $HOME/bin/helm.tar.gz
mv $HOME/bin/$DIR/helm $HOME/bin/

#cleanup
rm -rf $HOME/bin/$DIR
rm -rf $HOME/bin/helm.tar.gz