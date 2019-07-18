#!/usr/bin/env bash

mkdir -p $HOME/bin/ && cd $HOME/bin/

if [[ "$OSTYPE" == "darwin"* ]]; then
    curl -sL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "$HOME/bin/sessionmanager-bundle.zip"
    unzip $HOME/bin/sessionmanager-bundle.zip
    sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
    rm -rf $HOME/bin/sessionmanager-bundle.zip
else
    curl -sL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "$HOME/bin/session-manager-plugin.rpm"
    sudo yum install -y $HOME/bin/session-manager-plugin.rpm
    rm -rf $HOME/bin/session-manager-plugin.rpm
fi
