#!/usr/bin/env bash

mkdir -p $HOME/bin/
echo "Downloading Postman"
curl -s -L -o $HOME/bin/postman.zip https://dl.pstmn.io/download/latest/osx
unzip -o $HOME/bin/postman.zip -d $HOME/Applications/
rm -rf $HOME/bin/postman.zip
