#!/usr/bin/env bash

mkdir -p $HOME/bin/
if [[ "$OSTYPE" == "darwin"* ]]; then
    curl -s -L -o $HOME/bin/rancher.tar.gz https://github.com/rancher/cli/releases/download/v2.0.6/rancher-darwin-amd64-v2.0.6.tar.gz #maybe downgrade to 2.17.0? 2.18.2 might be buggy on osx?
else
    curl -s -L -o $HOME/bin/rancher.tar.gz https://github.com/rancher/cli/releases/download/v2.0.6/rancher-linux-amd64-v2.0.6.tar.gz
fi

cd $HOME/bin && tar -zxvf $HOME/bin/rancher.tar.gz
cd $HOME/bin/rancher-v2.0.6
mv rancher $HOME/bin/
rm -rf $HOME/bin/rancher-v2.0.6
rm -rf $HOME/bin/rancher.tar.gz