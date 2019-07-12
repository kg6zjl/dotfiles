#!/usr/bin/env bash
mkdir -p ~/tmp
sudo apt-get install -y python3-distutils
curl -Ls https://bootstrap.pypa.io/get-pip.py -o ~/tmp/get-pip.py
PIP_REQUIRE_VIRTUALENV=false && python3 ~/tmp/get-pip.py --user