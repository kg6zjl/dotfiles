#!/usr/bin/env bash

#install git
brew install git

#python2 setup
brew install python@2

#python3 setup
brew install python

#setup for openconnect vpn client
brew install gcc vpnc lz4 stoken gnutls
brew install openconnect --with-stoken
brew install stoken

#other misc brew installs
brew install pwgen watch tree tmux node npm kubectl jq dep gnu-sed