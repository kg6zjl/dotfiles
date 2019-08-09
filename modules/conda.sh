#!/usr/bin/env bash

mkdir -p $HOME/tmp/
mkdir -p $HOME/anaconda/

echo "Downloading Conda..."
curl -L -o $HOME/tmp/anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2019.07-MacOSX-x86_64.sh

echo "Installing Conda..."
bash $HOME/tmp/anaconda.sh -f -b -p $HOME/anaconda

eval "$(${HOME}/anaconda/bin/conda shell.bash hook)"

conda init

conda config --set auto_activate_base false

conda deactivate

echo "list envs: 'conda info --envs'"
echo "create an env: 'conda create -n conda-py35 python=3.5'"
echo "activate an env: 'conda activate conda-py35'"
echo "deactive an env: 'conda deactivate'"
