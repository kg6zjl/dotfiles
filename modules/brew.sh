#!/usr/bin/env bash

#install git
brew install git

#python2 setup
brew install python@2

#python3 setup
brew install python

#setup java
brew cask install java

#setup for openconnect vpn client
brew install gcc vpnc lz4 stoken gnutls
brew install stoken

#other misc brew installs
brew install pwgen watch tree tmux node npm kubectl jq dep gcc llvm bash-completion maven osxfuse

#brew installs for kvpn tool
brew install datawire/blackbird/telepresence dos2unix

#replace sed with gnu-sed, and symlink since --with-default-names is not available now
brew install gnu-sed #--with-default-names
ln -s /usr/local/bin/gsed /usr/local/bin/sed
