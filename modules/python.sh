#!/usr/bin/env bash

if [[ "$OSTYPE" == *"linux-gnu"* ]]; then
    sudo apt update -y
    sudo apt install -y python3
    sudo apt install -y python

    sudo apt install -y python-dev python3-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev
fi