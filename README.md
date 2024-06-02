<center>
[![Mac Build](https://github.com/kg6zjl/dotfiles/actions/workflows/build_mac.yml/badge.svg)](https://github.com/kg6zjl/dotfiles/actions/workflows/build_mac.yml) [![Linux Build](https://github.com/kg6zjl/dotfiles/actions/workflows/build_linux.yml/badge.svg)](https://github.com/kg6zjl/dotfiles/actions/workflows/build_linux.yml)
</center>

# dotfiles
Framework for my basic dev env. Trying to make it darwin and linux friendly!

# setup
```
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew install a few deps
brew install direnv asdf go-task

# generate a new ssh-key if you need one
task ssh-key

# kick off the setup
task setup
```
