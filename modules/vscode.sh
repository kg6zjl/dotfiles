#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  mkdir -p $HOME/tmp/
  echo "Downloading VSCode"
  curl -Ls -o $HOME/tmp/vscode.zip https://go.microsoft.com/fwlink/?LinkID=620882
  unzip -o $HOME/tmp/vscode.zip -d $HOME/Applications/
  rm -f $HOME/tmp/vscode.zip
fi
