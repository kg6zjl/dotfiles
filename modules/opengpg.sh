#!/usr/bin/env bash

mkdir -p $HOME/tmp/
echo "Downloading"
curl -sL -o $HOME/tmp/gpgtools.dmg https://releases.gpgtools.org/GPG_Suite-2018.5.dmg

#mount the image
echo "mounting the downloaded dmg"
hdiutil mount $HOME/tmp/gpgtools.dmg

#install the package
echo "installing from disk image"
sudo installer -pkg "/Volumes/GPG Suite/Install.pkg" -target /

#cleanup
echo "cleaning up"
hdiutil unmount "/Volumes/GPG Suite/"
rm $HOME/tmp/gpgtools.dmg
