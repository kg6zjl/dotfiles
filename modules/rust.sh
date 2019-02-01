#!/usr/bin/env bash

mkdir -p $HOME/tmp && cd $HOME/tmp

#get and run installer
curl -o $HOME/tmp/rust.sh https://sh.rustup.rs -sSfL
bash $HOME/tmp/rust.sh -y

#cleanup
rm -rf $HOME/tmp/rust.sh