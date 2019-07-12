#!/usr/bin/env bash

function get_direnv() {
    mkdir -p $HOME/bin
    if [[ "$OSTYPE" == *"darwin"* ]]; then
        curl -s -L -o $HOME/bin/direnv https://github.com/direnv/direnv/releases/download/v2.18.2/direnv.darwin-386
    else
        curl -s -L -o $HOME/bin/direnv https://github.com/direnv/direnv/releases/download/v2.20.0/direnv.linux-amd64
    fi
    sudo chmod +x $HOME/bin/direnv
}

function py3-presetup() { 
    if cat /etc/*-release | grep -iq 'debian\|ubuntu'; then
        sudo apt-get install python3-venv -y
    fi
}

function allow_direnv() {
    cd $2
    $HOME/bin/direnv allow .
    echo "source \$HOME/venvs/$1/bin/activate" > .envrc
    $HOME/bin/direnv allow .
    source $HOME/venvs/$1/bin/activate
}

function python2_setup() {
    PIP_REQUIRE_VIRTUALENV=false pip install virtualenv --user
    if [[ ! -d $HOME/venvs/$1 ]]; then
        virtualenv --python=/usr/bin/python2.7 $HOME/venvs/$1
    fi    
    source $HOME/venvs/$1/bin/activate
    pip install --upgrade pip
    pip install nose
    pip install -r $git_dir/dotfiles/files/py2-pip-requirements.txt
    pip install -I awscli
}

function python3_setup() {
    if [[ ! -d $HOME/venvs/$1 ]]; then
        python3 -m venv $HOME/venvs/$1
    fi
    source $HOME/venvs/$1/bin/activate
    pip3 install --upgrade pip
    pip3 install nose
    pip3 install -r $git_dir/dotfiles/files/py3-pip-requirements.txt
    pip3 install -I awscli
}

git_dir="$1"

py3-presetup

get_direnv
python2_setup venv-py2
python3_setup venv-py3

source $HOME/.bash_profile

#py3
allow_direnv venv-py3 $git_dir
allow_direnv venv-py3 $git_dir/dotfiles
#add python3 projects here

#py2
#add python2 projects here
#allow_direnv venv-py2 $git_dir
