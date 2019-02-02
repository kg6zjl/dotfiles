#!/usr/bin/env bash

#################################################
#change these to match your personal preferences:
ssh_key="id_rsa"
git_dir="$HOME/git"
#################################################

#don't change these:
dotfiles=$git_dir/dotfiles

function common-dirs() {
    mkdir -p $git_dir
    mkdir -p $HOME/.aws/
    mkdir -p $HOME/.ssh/
    mkdir -p $HOME/.kube
}

function ssh-setup() {
    if ssh-add -l | grep -q "$ssh_key"; then
        echo "ssh key $ssh_key is ready"
    else
        eval $(ssh-agent -s)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            ssh-add -K $HOME/.ssh/$ssh_key
        else
            ssh-add $HOME/.ssh/$ssh_key
        fi
    fi
}

function git-setup() {
    read -p "Enter your name for git config: " -e name
    read -p "Enter your email for git config: " -e email
    git config --global user.email "$email"
    git config --global user.name "$name"
}

function clone-dotfiles() {
    cd $git_dir && git clone git@github.com:kg6zjl/dotfiles.git
}

function copy-dotfiles() {
    cp $dotfiles/files/aws-config $HOME/.aws/config
    cp $dotfiles/files/ssh-config $HOME/.ssh/config
    cp $dotfiles/files/vimrc $HOME/.vimrc
    cp $dotfiles/files/bash_profile_customizations.sh $HOME/.bash_profile
    source $HOME/.bash_profile
}

################
#call functions#
################
common-dirs

git-setup

ssh-setup

clone-dotfiles

copy-dotfiles