#!/usr/bin/env bash

echo "Get latest release"
unset RELEASE
export RELEASE=$(curl -s https://api.github.com/repos/osxfuse/osxfuse/releases/latest | jq -r '.tag_name')

mkdir -p $HOME/tmp/
echo "Downloading osxfuse"
curl -sL -o $HOME/tmp/osxfuse.dmg https://github.com/osxfuse/osxfuse/releases/download/$RELEASE/$RELEASE.dmg

#mount the image
echo "mounting the downloaded dmg"
hdiutil mount $HOME/tmp/osxfuse.dmg

#install the package
echo "installing from disk image"
sudo installer -pkg "/Volumes/FUSE for macOS/FUSE for macOS.pkg" -target /

#cleanup
echo "cleaning up"
hdiutil unmount "/Volumes/FUSE for macOS/"
rm $HOME/tmp/osxfuse.dmg
