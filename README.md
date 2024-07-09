[![Mac Build](https://github.com/kg6zjl/dotfiles/actions/workflows/build_mac.yml/badge.svg)](https://github.com/kg6zjl/dotfiles/actions/workflows/build_mac.yml) [![Linux Build](https://github.com/kg6zjl/dotfiles/actions/workflows/build_linux.yml/badge.svg)](https://github.com/kg6zjl/dotfiles/actions/workflows/build_linux.yml)

# dotfiles
Framework for my basic dev env. Trying to make it darwin and linux friendly!

# setup
```
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew install a few deps
brew install direnv go-task

# generate a new ssh-key if you need one
task ssh-key

# kick off the setup
task setup
```

# pyenv and virtualenv
```
PYVERSION="3.12.4"
VENV_NAME="sd-py3"

# install a specific version
pyenv install ${PYVERSION}

# create a venv from that version
pyenv virtualenv ${PYVERSION} ${VENV_NAME}

# setup pyenv file
echo ${PYVERSION} > .python-version

# setup direnv
echo "pyenv activate ${VENV_NAME}" >> .envrc
```

Fix for issue installing Python on M1 Pro:
```
brew install python-tk@3.12; \

brew unlink pkg-config; \
CFLAGS="-I$(brew --prefix openssl)/include" \
LDFLAGS="-L$(brew --prefix openssl)/lib" \
CC="/usr/bin/gcc" \
env PYTHON_CONFIGURE_OPTS="--enable-framework" CONFIGURE_OPTS='--enable-optimizations' pyenv install 3.12.4
brew link pkg-config
```

# TODO
- setup Alacritty for cross-platform terminal emulator: https://alacritty.org/
- move file management to GNU Stow: https://www.gnu.org/software/stow/
    - taskfile feels nice for the rest, but file management will be easier with Stow
- swap asdf for pkgx: https://github.com/pkgXdev/pkgx
    - asdf is nice in some ways, but slow and the plugins seem prone to issue
    - i think i'll go the route of pkgx, pyenv, tfswitch, etc with direnv as the trigger for managing versions of things per directory
